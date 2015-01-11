use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
      'Mojolicious'                          => '5.08',
      'DBIx::Class::Schema'                  => '0',
      'DateTime::Fiction::JRRTolkien::Shire' => '0.02',
      'JSON::XS'                             => '2.32',
      'LWP::Simple'                          => '6.00',
      'XML::Simple'                          => '2.20',
      'LWP::UserAgent'                       => '6.04',
      'URI::Escape'                          => '3.31',
      'URI'                                  => '1.60',
      'WWW::Wunderground::API'               => '0.03',
      'List::MoreUtils'                      => '0',
      'WWW::Wunderground::API'               => '0',
      'WebService::BorisBikes'               => '0',
      'Data::Dumper'                         => '0',
      'HTML::Entities'                       => '0',
      'Astro::Constants::MKS'                => '0',
  },
  test      => {TESTS => 't/*.t'}
);
