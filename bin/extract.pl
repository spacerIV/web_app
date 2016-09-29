#!/usr/bin/env perl
#
use warnings;
use strict;
use feature 'say';
use Data::Dumper;
use IPC::Run3;

=head3
   my $pgn = "1. e3 e5 2. c4 d6 3. Nc3 Nc6 4. b3 Nf6 1-0";

    my (@cmd, $in, $out, $err);
    @cmd = ('/Users/victor/Documents/github/web_app/bin/pgn-extract.mac', '-s', '-Wlalg', '-eeco.pgn', '--nomovenumbers' );
    $in = $pgn;
    run3 \@cmd, \$in, \$out, \$err;
    my @out = split '\n', $out;
    say Dumper @out;
=cut
my @out = ('[ECO "A00"]', '[Opening "Amsterdam attack"]');
    my @ret;
    my ($opening, $variation, $eco);
    foreach my $line (@out) {
        ($opening) = ($line =~ /Opening/);
        say $opening;
        ($variation) = ($line =~ /Variation/);
        say $variation;
        ($eco) = ($line =~ /ECO/);
        say $eco;
        push @ret, $_ unless $line =~ /^\[/;
    }
    my $return = join " ", @ret;
    $return =~ s/ 1-0$//;
    $return =~ s/\+//g;   # --nochecks doesnt seem to work.
    $return =~ s/\*//g;

    my %r = (pgn      => $return,
            opening   => $opening,
            eco   => $eco,
            variation => $variation);
say Dumper %r;
