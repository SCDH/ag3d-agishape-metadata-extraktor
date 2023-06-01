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

<h1>Welcome to the Metadata Extraktor Web Service</h1>

<p>The following form lets you upload your PDF files to</p>
<ol>
  <li>Convert them to plain text using pdftotext (poppler-utils)</li>
  <li>Extract metadata using <a href="https://zivgitlab.uni-muenster.de/SCDH/ag-3d/metadata-extraktor">metadata-extraktor</a></li>
  <li>The extracted metadata will be downloaded as CSV</li>
</ol>

%= form_for pdf_upload => (enctype => 'multipart/form-data') => begin
  %= t p => begin
    %= file_field 'pdf'
    %= submit_button 'Upload PDF'
  % end
% end

@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="en">
  <head><title><%= title %></title></head>
  <body>
    %= content
    <hr>
    <p>&copy; 2022-2023 <a href="https://www.uni-muenster.de/DH/">SCDH</a></p>
  </body>
</html>
