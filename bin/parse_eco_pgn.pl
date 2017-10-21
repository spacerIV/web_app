#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

use Data::Dumper;
use File::Slurp;

my @c = read_file "eco_fixed.pgn" or die "cant find eco_fixed.pgn";
chomp @c;

my @a;
my ($eco, $opening, $variation, $pgn);

LINE:
foreach my $line (@c) {
   chomp $line;
   if ($line =~ /^\[ECO "(\w\d\d)"\]/) {
     $eco = $1;
     ($opening, $variation, $pgn) = (undef, undef, undef);
     say $eco;
   }
   if ($line =~ /^\[Opening "(.*)"\]/) {
     $opening = $1;
     say $opening;
   }
   if ($line =~ /^\[Variation "(.*)"\]/) {
     $variation = $1;
     say $variation;
   }
   if ($line =~ /^(1\. .*)/) {
     $pgn = $1;
     say $pgn;
     push @a, { eco => $eco, opening => $opening, variation => $variation, pgn => $pgn  };
   }

   next LINE;
}
 
say Dumper @a;

