#!/usr//bin/env perl

use Test::More;
use Modern::Perl '2013';

use_ok 'WebApp::Libs::BorisBikes';

my $BB = WebApp::Libs::BorisBikes->new();

ok ( ref $BB eq 'WebApp::Libs::BorisBikes'  , 'Instantiated Redis object' );
ok ( $BB->connect() == 1                    , 'Connect to Redis' );
ok ( $BB->is_connected() == 1               , 'Surely connected to Redis' );
ok ( $BB->update_redis_with_tfl_data() == 1 , 'Redis populated' );

my $rh_bb_data = $BB->get_all_station_ids_names_coordinates_icon_colour();
 
done_testing();
