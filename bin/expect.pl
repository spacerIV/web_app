#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

use Expect;
use Data::Dumper;

my $command = Expect->spawn("stockfish-7-64")
    or die "Couldn't start program: $!\n";

# prevent the program's output from being shown on our STDOUT
$command->log_stdout(0);

# 1. got prompt
unless ($command->expect(2, "Stockfish 7 64 by T")) {
    say 'not';
    exit;
}
say 'got prompt';

# 2. start uci mode
print $command "uci\n";
unless ($command->expect(2, "uciok")) {
    say 'not uciok';
    exit;
}
say 'got uciok';

# 3. setoption hash size
print $command "setoption name Hash value 512\n";

# 4. isready
print $command "isready\n";
unless ($command->expect(2, "readyok")) {
    say 'not readyok';
    exit;
}
say 'got readyok';

# 5. ucinewgame
print $command "ucinewgame\n";

# 6. position
print $command "position startpos moves e2e4 e7e5 d1f3 f8c5 f1c4 b8c6\n";
--nomovenumbers

print $command "go movetime 3\n";
my @out;
unless (@out = $command->expect(2, "bestmove")) {
    say 'not bestmove';
    exit;
}
say 'got bestmove';
say Dumper @out;

# n. close
print $command "quit\n";
$command->soft_close();

say "exiting";
