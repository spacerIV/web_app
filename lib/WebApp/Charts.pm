package WebApp::Charts;

use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

use Mojo::Log;

sub morris {
    shift->render( title => 'Morris Charts', 
                   msg   => 'Morris Charts', 
                   blurb => '' ),
}

sub flot {
    shift->render( title => 'Flot Charts', 
                   msg   => 'Flot Charts', 
                   blurb => '' ),
}

sub inline {
    shift->render( title => 'Inline Charts', 
                   msg   => 'Inline Charts', 
                   blurb => '' ),
}

1;
