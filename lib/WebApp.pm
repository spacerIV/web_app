package WebApp;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    # documentation browser under "/perldoc"
    $self->plugin( 'PODRenderer' );

    # router
    my $r = $self->routes;

    # dashboard 
    $r->route( '/' )->to( controller => 'dashboard', action => 'index' );

    # login 
    $r->get( '/login' )->name( 'login_form' )->to( template => 'login/login_form' );
    $r->post( '/login' )->name( 'do_login' )->to( 'Login#on_user_login' );

    # maps weather
    $r->route( '/maps/weather' )->to( 'maps#weather' );
    $r->route( '/maps/getweather/*location' )->to( 'maps#get_weather' );
    # map borisbikes
    $r->route( '/maps/borisbikes' )->to( 'maps#borisbikes' );
    $r->route( '/maps/get_bb_station_info/*station_id' )->to( 'maps#get_bb_station_info' );

    # misc schwarzschild
    $r->route( '/misc/schwarzschild' )->to( 'misc#schwarzschild' );
    $r->route( '/misc/calculate_schwarzschild_radius/*mass' )->to( 'misc#calculate_schwarzschild_radius' );
    # misc tetris
    $r->route( '/misc/tetris' )->to( 'misc#tetris' );
    # misc csrf
    $r->route( '/misc/csrf' )->to( 'misc#csrf' );
}

1;

