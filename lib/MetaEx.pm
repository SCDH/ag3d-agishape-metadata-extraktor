package MetaEx;

use utf8;
use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';

use List::MoreUtils qw(any);
use Text::CSV qw(csv);

# Need to fetch this once at the beginning. DATA is empty after first read.
our @IGNORE = map {chomp; $_} <DATA>;

use Class::Tiny {

  # Regular attributes
  encoding  => 'UTF-8',
  separator => ';',
  ignore    => \@IGNORE,

  # Processed attributes for accessible intermediate results
  input     => sub        {die "No input given!\n"},
  _cleaned  => sub($self) {$self->preprocess()},
  _columns  => sub($self) {$self->split_columns()},
  lines     => sub($self) {$self->columns_to_lines()},
};

sub preprocess($self) {
  my $contents = $self->input;

  # Remove everything before "Verarbeitungsparameter"
  $contents =~ s/^.*Verarbeitungsparameter\s*//s;

  # Remove everything after the last table row
  $contents =~ s/(\s|Seite \d+)*$//;

  # Remove page numbers but preserve column splits
  $contents =~ s/\s*Seite \d+\s*/\n\n/g;
  
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

sub columns_to_lines($self) {
  return [@{$self->_columns}{qw(left right)}];
}

sub to_csv($self) {
  csv(
    sep_char  => $self->separator,
    encoding  => $self->encoding,
    in        => $self->lines,
    out       => \my $csv,
  );
  return $csv;
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
