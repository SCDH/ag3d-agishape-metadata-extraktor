# Extract metadata workflow

Extract data following a certain model from PDFs and create pseudo CSV from it.

## Prerequisites

- `pdftotext` ([poppler-utils][pu])
- [Perl 5][pl]

## Workflow

0. Have your PDF file following the right format ready as `somename.pdf`
1. Extract plain text from PDF via `pdftotext`:
    ```
    pdftotext somename.pdf > somename.txt
    ```
2. Invoke the extractor perl script:
    ```
    perl meta-extrakt.pl somename.txt > somename.csv
    ```

## Author and license

(c) 2022-2023 Mirko Westermeier, Service Center for Digital Humanities

Licensed under the MIT license, see LICENSE for details.

[pu]: https://wiki.ubuntuusers.de/poppler-utils/
[pl]: https://www.perl.org/
