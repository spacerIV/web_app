#!/usr//bin/env perl

use Modern::Perl '2013';
use Redis;
use LWP::Simple;
use XML::Simple qw(:strict);
use Perl6::Slurp;
use List::MoreUtils qw(apply);
use Data::Dumper;
use Test::More;
use Test::Deep;

my @station_fields = ( qw/id name terminalName lat long installed locked temporary nbBikes nbEmptyDocks nbDocks/ );

# get cycle data
#my $xml = LWP::Simple::get('http://www.tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml');
my $xml = slurp 'workfiles/livecyclehireupdates.xml'; 

# parse XML
my $parser = XMLin($xml,
   ForceArray    => 0,
   KeyAttr       => {},
   SuppressEmpty => undef,
);


my $rhh_stations;
foreach my $station (@{$parser->{station}}) {
    $rhh_stations->{$station->{id}}->{$_} = $station->{$_} foreach @station_fields;
}

diag 'Parsed XML';

diag 'We have ' . scalar keys $rhh_stations, ' stations';

# insert into redis
#my $redis = Redis->new;  # defaults to $ENV(REDIS_SERVER) or 127.0.0.1:6379
my $redis = Redis->new(
     server   => 'barb.redistogo.com:9502',
     password => '9c6a355642c5faef7c688a0827e52691',
);

$redis->flushall;

diag 'Redis connected & flushed';

foreach my $station ( keys $rhh_stations ) {
   eval {
       local $SIG{PIPE};
       $SIG{PIPE} = sub {print "redis down";};
       $redis->hmset( $station, $_, $rhh_stations->{$station}->{$_}, sub {} ) for keys $rhh_stations->{$station};
   };
   if (my $err = $@) {
      say $err;
      exit;
   }
}

diag 'Redis populated';

# query redis
my @redis_station_keys = $redis->keys("*");
my $rhh_redis_stations;
for my $redis_station_key ( @redis_station_keys ) {
    my %stations_data;
    @stations_data{@station_fields} = $redis->hmget($redis_station_key, @station_fields );
    diag "Getting station $redis_station_key from redis";
    $rhh_redis_stations->{$redis_station_key} = \%stations_data;
}
cmp_deeply ($rhh_redis_stations, $rhh_stations, "Stations XML = Stations redis");
done_testing();
