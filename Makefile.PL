use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME              => 'MetaEx',
  AUTHOR            => q{Mirko Westermeier (SCDH) <mirko.westermeier@uni-muenster.de>},
  VERSION_FROM      => '0.1',
  LICENSE           => 'mit',
  MIN_PERL_VERSION  => '5.20.0',
  TEST_REQUIRES     => {'Test::More' => '0'},
  PREREQ_PM         => {},
  test              => {TESTS => 't/*.t'}
);
