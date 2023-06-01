package MetaEx;

use utf8;
use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';

use File::Slurp qw(read_file);
use Encode qw(decode encode);
use List::MoreUtils qw(any);

use Class::Tiny {

  # Regular attributes
  encoding    => 'UTF-8',
  separator => ';',
  ignore    => sub {[map {chomp; $_} <DATA>]},
  filename  => sub {die "No filename given!\n"},

  # Processed attributes for accessible intermediate results
  _input    => sub($self) {decode($self->encoding, read_file($self->filename))},
  _cleaned  => sub($self) {$self->preprocess()},
  _columns  => sub($self) {$self->split_columns()},
};

sub preprocess($self) {
  my $contents = $self->_input;

  # Remove everything before "Verarbeitungsparameter"
  $contents =~ s/^.*Verarbeitungsparameter\s*//s;

  # Remove everything after the last table row
  $contents =~ s/(\s|Seite \d+)*$//;

  # Remove page numbers but preserve column splits
  $contents =~ s/\s*Seite \d+\s*/\n\n/g;

  # Check "CSV"ability
  my $sep = $self->separator;
  die "File content contains separator '$sep'!\n"
    if $contents =~ /$sep/;
  
  # Done
  return $contents;
}

sub split_columns($self) {
  my ($is_left, @left, @right) = 1;

  # Process line by line
  LINE: for my $line (split /\R/ => $self->_cleaned) {

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
      next LINE if any {$line eq $_} @{$self->ignore};
      push @left, $line;
    }

    # On the right side
    else {
      push @right, $line;
    }
  }

  # Check result validity
  die "Columns don't match!\n" if @left != @right;

  # Done
  return {left => \@left, right => \@right};
}

sub to_csv($self) {

  # Generate pseudo-CSV
  my @lines = map {
    join($self->separator => @{$self->_columns->{$_}}) . "\n"
  } qw(left right);

  # Write out
  return encode $self->encoding => join '' => @lines;
}

1; # End of MetaEx

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
