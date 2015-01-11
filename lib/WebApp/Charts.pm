package WebApp::Charts;

use Mojo::Base 'Mojolicious::Controller';

sub morris 
{
    my $self = shift;

    $self->render( title => 'Morris',
                   msg   => 'Morris', 
                   blurb => '  some morris charts' );
}

sub flot 
{
    my $self = shift;

    $self->render( title => 'Flot',
                   msg   => 'Flot', 
                   blurb => '  some flot charts' );
}

1;
