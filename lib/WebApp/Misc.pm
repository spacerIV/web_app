package WebApp::Misc;

use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

use Mojo::Log;
use HTML::Entities;
use Astro::Constants::MKS qw(:long);

sub schwarzschild {
    my $self = shift;

    $self->render( title => 'Schwarzschild Radius', 
                   msg   => 'Schwarzschild Radius', 
                   icon  => '<i class="fa fa-coffee"></i>',
                   blurb => '' ),
}

sub calculate_schwarzschild_radius {
    my $self = shift;

    my $mass = encode_entities $self->param( 'mass' );
 
    my $answer = 2 * GRAVITATIONAL * $mass / LIGHT_SPEED ** 2;

    warn "Question: 2 * GRAVITATIONAL * $mass / LIGHT_SPEED ** 2";
    warn "Answer: $answer";

    $answer =~ s/e-(\d+)$/ x 10 <sup>-$1<\/sup>/; 

    $self->render( json => { schwarzschild_radius => $answer } );
}

sub tetris {
    my $self = shift;

    $self->render( title => 'WebGL Tetris', 
                   msg   => 'WebGL Tetris', 
                   icon  => '<i class="fa fa-coffee"></i>',
                   blurb => 'Ported from C & OpenGL to Javascript using Emscripten' ),
}

sub csrf {
    my $self = shift;

    # POST only param
    my $city = $self->req->body_params->param('city');

    unless ( defined $city ) {
        $self->render( title => 'CSRF', 
                       msg   => 'CSRF', 
                       icon  => '<i class="fa fa-coffee"></i>',
                       blurb => 'This form contains a hidden csrf token', );
        return;
     }

    # Check CSRF token
    my $validation = $self->validation;

    return $self->render(text => 'Bad CSRF token!', status => 403)
        if $validation->csrf_protect->has_error('csrf_token');

    $city = $validation->required('city')->param('city');

    $self->render( title => 'CSRF', 
                   msg   => 'CSRF', 
                   icon  => '<i class="fa fa-coffee"></i>',
                   text  => "Low orbit ion cannon pointed at $city!" )
        unless $validation->has_error;
}

1;
