#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use MetaEx;
use File::Slurp;
use Encode;

my $ENCODING  = 'UTF-8';

my $filename  = $ARGV[0] // die "No filename given!\n";
my $input     = decode($ENCODING => read_file($filename));
my $extraktor = MetaEx->new(input => $input);
print $extraktor->to_csv();

__END__
