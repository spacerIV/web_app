package WebApp::Maps;

use Mojo::Base 'Mojolicious::Controller';

use Mojo::Log;

use WWW::Wunderground::API;
use WebService::BorisBikes;

my $BB;

sub weather {
    my $self = shift;

    $self->render( title => 'Weather',
                   msg   => 'Weather', 
                   blurb => 'click somewhere to show live weather' );
}

sub get_weather {
    my $self = shift;

    # eg: $location =~ (16.130262012034766, 31.201171875)
    $self->param( 'location' ) =~ m/^\((?<lat>-?\d{1,3}\.\d+), (?<lng>-?\d{1,3}\.\d+)\)/; 

    my ( $lat, $lng ) = ( $+{lat}, $+{lng} ); 

    my $W = WWW::Wunderground::API->new( location  => $lat . ',' . $lng,
                                         api_key  => '7c6a2de5aedd381b',
                                         auto_api => 1, );
    my %w = (
        place           => $W->display_location->full,
        temp_c          => $W->temp_c,
        wind_condition  => $W->wind_string,
        humidity        => $W->relative_humidity,
        condition       => $W->weather,
        icon            => $W->icon_url,
    );

    # change icon set
    $w{ icon } =~ s/\/i\/\/c\/\/k\//\/i\/\/c\/\/i\//g; 

    my $ok = ( defined $w{ place } ) ? 1 : 0;

    $self->render(
        json => {
            lat     => $lat,
            lng     => $lng,
            weather => \%w, 
            success => $ok, } );
} 

sub borisbikes {
    my $self = shift;

    $BB = WebService::BorisBikes->new( { refresh_rate => 120 } ) 
        unless defined $BB && $BB->isa( 'WebService::BorisBikes' );

    my $stations = $BB->get_all_stations;

    my $data;

    foreach my $s ( keys $stations ) {
        my ( $nbBikes, $nbDocks ) = ( $stations->{ $s }->get_nbBikes, $stations->{ $s }->get_nbDocks );

        next if $nbDocks == 0;

        my $value =  $nbBikes / $nbDocks;

        my $icon = 1 if ( $value >= 0.00 && $value < 0.33 );
        $icon    = 2 if ( $value >= 0.33 && $value < 0.66 );
        $icon    = 3 if ( $value >= 0.66 );

        $data->{ $s } = { 
            lat         => $stations->{ $s }->get_lat,
            long        => $stations->{ $s }->get_long,
            name        => $stations->{ $s }->get_name,
            nbBikes     => $nbBikes,
            nbDocks     => $nbDocks,
            icon_colour => $icon,
        };
    }

    my $success = ( defined $data ) ? 1 : 0;

    $self->render( 
            title      => 'Boris Bikes',
            msg        => 'Boris Bikes',
            blurb      => '',
            success    => $success, 
            stations   => $data, 
    );
}

sub get_bb_station_info {
    my $self = shift;

    $BB = WebService::BorisBikes->new( { refresh_rate => 120 } ) 
        unless defined $BB && $BB->isa( 'WebService::BorisBikes' );

    my $s = $BB->get_station_by_id( $self->param( 'station_id' ) );

    my %data = (
        name    => $s->get_name,
        nbBikes => $s->get_nbBikes,
        nbDocks => $s->get_nbDocks,
        lat     => substr( $s->get_lat, 0, 6 ),
        long    => substr( $s->get_long, 0, 6 ),
    );

    $self->render( json => { station_info => \%data } );
}

1;
