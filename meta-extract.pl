#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use MetaEx;

my $filename  = $ARGV[0] // die "No filename given!\n";
my $extraktor = MetaEx->new(filename => $filename);
print $extraktor->to_csv();

__END__
