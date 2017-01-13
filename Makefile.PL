use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
      'Mojolicious'                          => '5.08',
      'DBIx::Class::Schema'                  => 0,
      'JSON::XS'                             => '2.32',
      'LWP::Simple'                          => '6.00',
      'XML::Simple'                          => '2.20',
      'LWP::UserAgent'                       => '6.04',
      'URI::Escape'                          => '3.31',
      'URI'                                  => '1.60',
      'WWW::Wunderground::API'               => '0.03',
      'List::MoreUtils'                      => 0,
      'WWW::Wunderground::API'               => 0,
      'WebService::BorisBikes'               => 0,
      'Data::Dumper'                         => 0,
      'HTML::Entities'                       => 0,
      'Astro::Constants'                     => 0,
      'JSON'                                 => 0,
      'IPC::Run3'                            => 0,
      'Expect'                               => 0,
      'IO::Tty'                              => 0,
      'IO::Stty'                             => 0,
      'POSIX'                                => 0,
      'Fcntl'                                => 0,
      'Hash::AsObject'                       => 0,
      'JSON::MaybeXS'                        => 0,
      'LWP::Simple'                          => 0,
      'Moo'                                  => 0,
      'XML::Simple'                          => 0,
      'Mojolicious::Plugin::AccessLog'       => 0,
      'LWP::Protocol::https'                 => 0,
  },
  test      => {TESTS => 't/*.t'}
);

