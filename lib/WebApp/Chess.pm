package WebApp::Chess;

use Mojo::Base 'Mojolicious::Controller';

use Mojo::Log;

use JSON; 
use Expect; 
use IPC::Run3;
use Data::Dumper; 
use Chess::PGN::Extract; 

my $stockfish = Expect->spawn("bin/stockfish-7-64") 
    or die "Couldnt start stockfish.";

has sf => sub { $stockfish };

sub paste {
    my $self = shift;

    $self->render( title => 'Chess Paste',
        title => 'Chess Paste',
        msg   => 'Paste', 
        icon  => '<b style="font-size:100%;">&#9812;</b>',
        blurb => 'paste PGN to analyse',
    );
}

sub analyse {
    my $self = shift;

    $self->render( 
        title      => 'Chess Analyse',
        msg        => 'Analyse',
        blurb      => 'blurb',
        icon       => '<b style="font-size:100%;">&#9812;</b>',
    );
}

sub vsstockfish {
    my $self = shift;

    $self->sf->log_stdout(0);

    $self->render( 
        title      => 'vs Stockfish 7',
        msg        => 'vs',
        blurb      => 'Stockfish 7',
        icon       => '<b style="font-size:100%;">&#9812;</b>',
    );
}

sub ws {
    my $self = shift;

    $self->on( json => sub {
        my ($ws, $data) = @_;
        if ($data =~ /Hello server/) {
            $ws->send({ json => {data => 'Connection Established!'} });
        }
        if ($data =~ /^uci - (.*)/) {
            $ws->send({ json => {data => $1} });
            my @out = $self->stockfish($1);
            foreach (@out) {
                next unless defined;
                $ws->send({ json => {data => "$_"} });
            }
        }
    });
}

sub stockfish {
    my ($self, $str) = @_;

    my $sf = $self->sf;

    if ($str eq 'uci') {
        print $sf "$str\n";
        my @out;
        unless (@out = $sf->expect(2, "uciok")) {
            print 'not uciof';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2]);
    }  
    elsif ($str eq 'isready') {
        print $sf "$str\n";
        my @out;
        unless (@out = $sf->expect(2, "readyok")) {
            warn 'not readyok';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2]);
    }
    elsif ($str eq 'ucinewgame') {
        print $sf "$str\n";
        return ($str);
    }
    elsif ($str =~ /position/) {
        my $pgn = $self->pgn_extract($str); 
        print $sf "position startpos moves $pgn\n";
        print $sf "go movetime 4\n";
        my @out;
        unless (@out = $sf->expect(3, "bestmove")) {
            warn 'not bestmove';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2], $out[4]);
    }
    elsif ($str =~ /^go movetime/) {
        print $sf "$str\n";
        my @out;
        unless (@out = $sf->expect(6, "bestmove")) {
            warn 'not bestmove';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2], $out[4]);
    }
}

sub pgn_extract { 
    my ($self, $pgn) = @_; 

    $pgn =~ s/^position - //;
    $pgn .= ' 1-0';

    my (@cmd, $in, $out, $err);
    @cmd = qw{bin/pgn-extract -s -Wlalg -nochecks --nomovenumbers}; 
    $in = $pgn;
    warn "Running command @cmd $pgn";
    run3 \@cmd, \$in, \$out, \$err;
    my @out = split '\n', $out;
    my @ret;
    foreach (@out) {
        push @ret, $_ unless $_ =~ /^\[/;    
    }
    my $return = join " ", @ret;
    $return =~ s/ 1-0$//;
    $return =~ s/\+//g;   # --nochecks doesnt seem to work.
    warn "Got back: $return";

    return $return;
};


sub gen_data {
  my $x = shift;
  return [ $x, sin( $x + 2*rand() - 2*rand() ) ];
}

1;
