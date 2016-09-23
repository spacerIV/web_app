package WebApp::Chess;

use Mojo::Base 'Mojolicious::Controller';

use Mojo::Log;

use JSON; 
use Data::Dumper; 
use IO::Async::Process;
use IO::Async::Loop;

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

    $self->render( 
        title      => 'vs Stockfish 7',
        msg        => 'vs',
        blurb      => 'Stockfish 7',
        icon       => '<b style="font-size:100%;">&#9812;</b>',
    );
}

sub ws {
    my $self = shift;

    #my $timer = Mojo::IOLoop->recurring( 1 => sub {
    #    state $i = 0;
    #    $self->send({ json => gen_data($i++) });
    #});

    #$self->on( finish => sub {
    #    Mojo::IOLoop->remove($timer);
    #});

    $self->on( json => sub {
        my ($ws, $data) = @_;
        if ($data =~ /Hello server/) {
            $ws->send({ json => {data => '--> Hello server!'} });
            $ws->send({ json => {data => '<-- Hello client!'} });
            init_stockfish();

        }
    });
}

sub init_stockfish {
    my $str;
    
}

sub gen_data {
  my $x = shift;
  return [ $x, sin( $x + 2*rand() - 2*rand() ) ];
}

1;
