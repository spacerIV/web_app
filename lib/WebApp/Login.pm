package Moblo::Login;

use Mojo::Base 'Mojolicious::Controller';

sub user_exists {
    my ( $username, $password ) = @_;

    return ( $username eq 'foo' && $password eq 'bar' );
}


sub on_user_login {
    my $self = shift;

    my $username = $self->param( 'username' );
    my $password = $self->param( 'password' );

    return $self->render( text => 'Logged in!' )
        if user_exists ( $username, $password );

    return $self->render( text => 'Wrong username/password', status => 403 );
}

1;
