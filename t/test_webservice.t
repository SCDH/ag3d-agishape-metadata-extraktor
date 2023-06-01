use Test::More;
use Mojo::File qw(curfile);
use Test::Mojo;
use File::Slurp;

my $t = Test::Mojo->new(curfile->dirname->sibling('webservice.pl'));

subtest 'Home page with upload form' => sub {
  $t->get_ok('/')->status_is(200)
    ->text_is('title' => 'Metadata Extraktor')
    ->text_is('h1' => 'Metadata Extraktor')
    ->element_exists('form[action="/pdf"]');
};

subtest 'PDF metadata extraction' => sub {

  my $dir = curfile->sibling('test-data');
  my $pdf = read_file $dir->child('example.pdf');
  my $csv = read_file $dir->child('example.csv');

  my $upload = {pdf => {content => $pdf, filename => 'example.pdf'}};
  $t->post_ok('/pdf', form => $upload)->status_is(200)
    ->content_type_is('text/csv')
    ->header_is("Content-Disposition" => "attachment; filename=example.pdf.csv;");
  is $t->tx->res->body => $csv, 'Correct CSV content';
};

done_testing();
