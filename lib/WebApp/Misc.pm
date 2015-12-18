package WebApp::Misc;

use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

use Mojo::Log;
use HTML::Entities;
use Astro::Constants::MKS qw(:long);

sub schwarzschild {
    my $self = shift;

    $self->render(
        title => 'Schwarzschild Radius',
        msg   => 'Schwarzschild Radius',
        blurb => ''
        ),
        ;
}

sub calculate_schwarzschild_radius {
    my $self = shift;

    my $mass = encode_entities $self->param('mass');

    my $answer = 2 * GRAVITATIONAL * $mass / LIGHT_SPEED**2;

    $answer =~ s/e-(\d+)$/ x 10 <sup>-$1<\/sup>/;

    $self->render( json => { schwarzschild_radius => $answer } );
}

sub tetris {
    my $self = shift;

    $self->render(
        template => 'misc/tetris',
        title    => 'WebGL Tetris',
        msg      => 'WebGL Tetris',
        blurb    => 'Ported from C & OpenGL to Javascript using Emscripten'
        ),
        ;
}

sub csrf {
    my $self = shift;

    # POST only param
    my $city = $self->req->body_params->param('city');

    unless ( defined $city ) {
        $self->render(
            template => 'misc/csrf',
            title    => 'CSRF',
            msg      => 'CSRF',
            blurb    => 'This form contains a hidden csrf token',
        );
        return;
    }

    # Check CSRF token
    my $validation = $self->validation;

    return $self->render( text => 'Bad CSRF token!', status => 403 )
        if $validation->csrf_protect->has_error('csrf_token');

    $city = $validation->required('city')->param('city');

    $self->render(
        title => 'CSRF',
        msg   => 'CSRF',
        text  => "Low orbit ion cannon pointed at $city!"
    ) unless $validation->has_error;
}

1;
