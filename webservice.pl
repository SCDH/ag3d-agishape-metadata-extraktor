#!/usr/bin/env perl

use Mojolicious::Lite -signatures;
use Mojo::File qw(path);
use File::Temp qw(tempdir);
use Encode;

use FindBin;
use lib "$FindBin::Bin/lib";
use MetaEx;

# Add CSV content type
app->types->type(csv => 'text/csv');

# Render the upload form
get '/' => 'index';

# Handle uploaded PDF files
post '/pdf' => sub ($c) {
  my $pdf   = $c->param('pdf');
  my $name  = $pdf->filename;

  # Move to temporary directory
  my $dir       = path(tempdir(CLEANUP => 1));
  my $pdf_file  = $dir->child($name);
  $pdf->move_to($pdf_file);

  # Extract CSV data via external command and MetaEx
  my $txt = decode 'UTF-8' => qx(pdftotext $pdf_file -);
  my $csv = MetaEx->new(input => $txt)->to_csv();

  # Render as CSV download
  $c->res->headers->content_disposition("attachment; filename=$name.csv;");
  $c->render(data => $csv, format => 'csv');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Metadata Extraktor';
<h1><%= title %></h1>
%= form_for pdf => (enctype => 'multipart/form-data') => begin
  %= file_field 'pdf'
  %= submit_button 'Upload PDF'
% end

@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="en">
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
