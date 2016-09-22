package WebApp::Chess;

use Mojo::Base 'Mojolicious::Controller';

use Mojo::Log;

sub paste {
    my $self = shift;

    $self->render( title => 'Chess Paste',
                   msg   => 'Paste', 
                   icon  => '<b style="font-size:100%;">&#9812;</b>',
                   blurb => 'paste PGN to analyse',
    );

}

sub analyse {
    my $self = shift;

    $self->render( 
            title      => 'Chess Analyse',
            msg        => 'Analyse this',
            blurb      => 'motherfucker',
            icon       => '<b style="font-size:100%;">&#9812;</b>',
    );
}

1;
