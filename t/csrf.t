#!/usr//bin/env perl

use strict;
use warnings;
use feature 'say';

use Test::More;
use Data::Dumper;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new;
my $response = $ua->post( 'http://127.0.0.1:3000/misc/csrf', { city => 'nyc' } );
ok ( $response->decoded_content eq 'Bad CSRF token!', 'Couldnt submit form using LWP::UserAgent.' );

done_testing();
