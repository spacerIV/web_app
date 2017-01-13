package WebApp::Chess;

use Mojo::Base 'Mojolicious::Controller';

use Mojo::Log;

use JSON; 
use Expect; 
use IPC::Run3;
use Data::Dumper; 

my $os = $^O;
my $stockfish_binary   = $os eq 'darwin' ? 'bin/stockfish-7-64.mac' : 'bin/stockfish-7-64.linux';
my $pgn_extract_binary = $os eq 'darwin' ? 'bin/pgn-extract.mac'    : 'bin/pgn-extract.linux';

my $stockfish = Expect->spawn($stockfish_binary) 
    or die "Couldnt start stockfish.";

has sf => sub { $stockfish };

sub opening_book {
    my $self = shift;

    $self->render( 
        title => 'Opening Book',
        msg   => 'Opening Book',
        icon  => '<b style="font-size:100%;">&#9812;</b>',
        blurb => 'Know your openings',
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

    $self->sf->log_stdout(1);

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
            my @out = $self->stockfish($ws, $1);
            foreach (@out) {
                next unless defined;
                $ws->send({ json => {data => "$_"} });
            }
        }
    });
}

sub stockfish {
    my ($self, $ws, $str) = @_;

    my $sf = $self->sf;

    if ($str eq 'uci') {
        say $sf "$str";
        my @out;
        unless (@out = $sf->expect(2, "uciok")) {
            warn 'not uciof';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2]);
    }  
    elsif ($str eq 'isready') {
        say $sf "$str";
        my @out;
        unless (@out = $sf->expect(2, "readyok")) {
            warn 'not readyok';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2]);
    }
    elsif ($str =~ /setoption/) {
        say $sf $str;
        return ();
    }
    elsif ($str eq 'ucinewgame') {
        say $sf "$str";
        return ();
    }
    elsif ($str =~ /position/) {
        my %extract = $self->pgn_extract($str); 
        say $sf "position startpos moves " . $extract{pgn};
        $ws->send({ json => { data => $extract{eco}}}) if defined $extract{eco};
        $ws->send({ json => { data => $extract{opening}}}) if defined $extract{opening};
        $ws->send({ json => { data => $extract{variation}}}) if defined $extract{variation};
        say $sf "go movetime 4";
        my @out;
        unless (@out = $sf->expect(3, "bestmove")) {
            warn 'not bestmove';
        }
        my @lines = split( "\n", $out[3] ); 
        return (@lines, $out[2], $out[4]);
    }
    elsif ($str =~ /^go movetime/) {
        say $sf "$str";
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
    @cmd = ($pgn_extract_binary, '-s', '-Wlalg', '-ebin/eco.pgn', '--nomovenumbers' ); 
    $in = $pgn;
    run3 \@cmd, \$in, \$out, \$err;
    my @out = split '\n', $out;
    my @ret;
    my ($opening, $variation, $eco);
    foreach my $line (@out) {
        $opening = $line if $line =~ /Opening/;
        $variation = $line if $line =~ /Variation/;
        $eco = $line if $line =~ /ECO/;
        push @ret, $line unless $line =~ /^\[/;    
    }
    my $return = join " ", @ret;
    $return =~ s/ 1-0$//;
    $return =~ s/\+//g;   # --nochecks doesnt seem to work.
    $return =~ s/\*//g;   

    my %r = (pgn      => $return, 
            opening   => $opening, 
            eco       => $eco, 
            variation => $variation);
    return %r;
};


sub gen_data {
  my $x = shift;
  return [ $x, sin( $x + 2*rand() - 2*rand() ) ];
}


1;
