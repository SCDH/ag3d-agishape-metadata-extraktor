use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME              => 'MetaEx',
  AUTHOR            => q{Mirko Westermeier (SCDH) <mirko.westermeier@uni-muenster.de>},
  VERSION           => '0.1',
  LICENSE           => 'mit',
  MIN_PERL_VERSION  => '5.20.0',
  TEST_REQUIRES     => {
    'Test::More' => '0',
  },
  PREREQ_PM         => {
    'Class::Tiny'     => 1.0008,
    'File::Slurp'     => 9999,
    'List::MoreUtils' => 0,       # Any version works
    'Text::CSV'       => 2,
    'Mojolicious'     => 9,
    'File::Temp'      => 0.23,
  },
  test              => {TESTS => 't/*.t'}
);
