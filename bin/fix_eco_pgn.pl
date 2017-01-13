#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

use Expect;
use Data::Dumper;
use File::Slurp;

my @c = read_file "eco.pgn" or die "cant find eco.pgn";
chomp @c;

my @a;
my ($pgn, $pgn2, $mightbe);

LINE:
foreach my $line (@c) {
   chomp $line;
   if ($line =~ /^(1\. .*)/) {
     $pgn = $1;
     chomp $pgn;
     $mightbe = 1;
   }
   elsif ( defined $line && $pgn) {
       $pgn2 = $line;
       chomp $pgn2;
       push @a, "$pgn$pgn2\n"; 
       ($pgn, $pgn2) = (undef, undef);
   }
   else {
      push @a, "$line\n"; 
      $mightbe = 0;
   }
}
 
say @a;

