package WebApp::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;

  $self->render( title => 'Welcome', 
                 msg   => 'Mojolicious', 
                 icon  => '<i class="fa fa-cloud" aria-hidden="true"></i>',
                 blurb => ' the real-time web framework' );
}

1;
