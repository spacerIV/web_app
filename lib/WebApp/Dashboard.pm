package WebApp::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;

  $self->render( title => 'Welcome', 
                 msg   => 'Mojolicious', 
                 blurb => ' the real-time web framework!' );
}

1;
