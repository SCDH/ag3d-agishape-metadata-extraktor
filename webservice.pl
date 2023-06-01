#!/usr/bin/env perl

use Mojolicious::Lite -signatures;

get '/' => 'index';

post '/pdf_upload' => sub ($c) {

} => 'pdf_upload';

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
