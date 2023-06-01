use strict;
use warnings;

use Test::More;
use File::Slurp;
use Encode;
use FindBin;

use_ok 'MetaEx';

my $ENCODING = 'UTF-8';

# Load test data
my $dir = "$FindBin::Bin/test-data";
my $txt = decode $ENCODING => read_file "$dir/example.txt";
my $csv = read_file "$dir/example.csv";

subtest 'Expected output for given input' => sub {

  my $extraktor = MetaEx->new(input => $txt);
  is $extraktor->to_csv() => $csv, 'Correct CSV content';
};

done_testing();
