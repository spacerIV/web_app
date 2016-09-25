#!/usr/bin/env perl
#
use warnings;
use strict;
use feature 'say';
use Expect;
use Data::Dumper;

my $pgn_extract = Expect->spawn("/Users/victor/Documents/github/web_app/bin/pgn-extract -Wlalg -nochecks") or die "Couldnt start pgn-extract.";

$pgn_extract->log_stdout(1);

print $pgn_extract '1.  f4 b5 2. f5 g5 3. f6 1-0';

my @o;
unless (@o = $pgn_extract->expect(3, "1. ")) {
    say 'noope';
}

say Dumper @o;

