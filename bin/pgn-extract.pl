#!/usr/bin/env perl

use strict;
use warnings;

use feature 'say';

use lib 'lib';

use Chess::PGN::Extractv;
use Data::Dumper; 
use JSON;

my @games = read_games ("vic.pgn");
#say Dumper @games;

my $str;
foreach my $g (@games) {
    $str = (join ' ',  @{$g->{Moves}});
}

say $str;
$str =~ s/-//g;
$str =~ s/\+//g;
say $str;
