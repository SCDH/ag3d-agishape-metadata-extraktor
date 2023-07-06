use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';

use Test::More;
use File::Slurp;
use Encode;
use FindBin;

use_ok 'MetaEx';

my $ENCODING = 'UTF-8';

sub txt2csv($fn) {
  $fn =~ s/txt$/csv/;
  return $fn;
}

# Load test data
my $dir   = "$FindBin::Bin/test-data";
my @files = <"$dir/example*.txt">;
my %txt   = map {$_ => decode($ENCODING => scalar(read_file($_)))} @files;
my %csv   = map {$_ => scalar(read_file(txt2csv($_)))} @files;

subtest 'Expected output for given input' => sub {

  for my $f (@files) {
    my $extraktor = MetaEx->new(input => $txt{$f});
    is $extraktor->to_csv() => $csv{$f}, "Correct $f CSV content";
  }
};

done_testing();
