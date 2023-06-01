use strict;
use warnings;

use Test::More;
use File::Slurp;
use FindBin;

use_ok 'MetaEx';

# Load test data
my $dir = "$FindBin::Bin/test-data";
my $csv = read_file "$dir/example.csv";

subtest 'Expected output for given input' => sub {

  my $extraktor = MetaEx->new(filename => "$dir/example.txt");
  is $extraktor->to_csv() => $csv, 'Correct CSV content';
};

done_testing();
