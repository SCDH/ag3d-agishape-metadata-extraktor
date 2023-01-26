#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use Encode;
use List::MoreUtils qw(any);

############### Helper and preparation #############

my $ENCODING  = 'utf-8';
my $SEPARATOR = ';';

# Slurp helper sub
sub slurp {
  my $filename = shift;
  open my $fh, "<:encoding($ENCODING)", $filename or die "Unable to open file '$filename'!\n";
  return do {local $/; <$fh>};
}

# Headers to ignore (loaded from DATA section at end of file)
my @ignore = map {chomp; $_} <DATA>;

############### Preprocess that file ################

# Slurp file content from command line
my $filename = $ARGV[0] or die "No filename given!\n";
my $contents = slurp($filename);

# Remove everything before "Verarbeitungsparameter"
$contents =~ s/^.*Verarbeitungsparameter\s*//s;

# Remove everything after the last table row
$contents =~ s/(\s|Seite \d+)*$//;

# Remove page numbers but preserve column splits
$contents =~ s/\s*Seite \d+\s*/\n\n/g;

# Check "CSV"ability
die "File content contains separator '$SEPARATOR'!\n" if $contents =~ /$SEPARATOR/;

# For all lines:
my ($is_left, @left, @right) = 1;
LINE: for my $line (split /\R/ => $contents) {

  # Trim
  $line =~ s/^\s+//;
  $line =~ s/\s+$//;

  # Side switch
  if ($line eq '') {
    $is_left = not $is_left;
    next LINE;
  }

  # On the left side
  if ($is_left) {

    # Skip ignored lines
    next LINE if any {$line eq $_} @ignore;
    push @left, $line;
  }

  # On the right side
  else {
    push @right, $line;
  }
}

############# Combine and output ###############

die "Columns don't match!\n" if @left != @right;

# Zip em
my @items = map +{field => $left[$_], data => $right[$_]} => 0 .. $#left;

# Generate pseudo-CSV
print encode($ENCODING, join $SEPARATOR => map $_->{field} => @items), "\n";
print encode($ENCODING, join $SEPARATOR => map $_->{data}  => @items), "\n";

__DATA__
Allgemein
Punktwolke
Ausrichtungsparameter
Tiefenbilder
Parameter für Tiefenbilderzeugung
Dichte Punktwolke
Parameter für Erzeugung der dichten Punktwolke
Modell
Rekonstruktionsparameter
Texturierungsparameter
DEM
Orthomosaik
System
