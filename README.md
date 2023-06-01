# Extract metadata workflow

Extract data following a certain model from PDFs and create CSV from it.

There are two workflows available:

1. Manual execution via command line
2. As a (dockerized) webservice

## Prerequisites

- `pdftotext` ([poppler-utils][pu])
- [Perl 5][pl]

## Script execution

0. Have your PDF file following the right format ready as `somename.pdf`
1. Extract plain text from PDF via `pdftotext`:
    ```
    pdftotext somename.pdf > somename.txt
    ```
2. Invoke the extractor perl script:
    ```
    perl meta-extrakt.pl somename.txt > somename.csv
    ```

## Webservice

1. Install dependencies via
    ```
    cpanm -nq --installdeps .
    ```
2. Run the webservice via
    ```
    hypnotoad webservice.pl
    ```
3. Navigate to that page with your browser and upload your PDF file! It's usually `http://localhost:8080/`.

The webservice can be stopped with `hypnotoad -s webservice.pl`.

## Dockerized webservice

The webservice can also be run in docker using standard procedures:
```
$ docker build -t metaex-web .
$ docker run -d -p 3000:3000 metaex-web
```

## Author and license

(c) 2022-2023 Mirko Westermeier, Service Center for Digital Humanities

Licensed under the MIT license, see LICENSE for details.

[pu]: https://wiki.ubuntuusers.de/poppler-utils/
[pl]: https://www.perl.org/
