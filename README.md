[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0) [![test](https://github.com/librasteve/raku-Contact/actions/workflows/test.yml/badge.svg)](https://github.com/librasteve/raku-Contact/actions/workflows/test.yml)

# Contact

## Synopsis

```raku
#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

use Contact;

my ( $country, $text );

#[
$country = 'USA';

$text = q:to/END/;
John Doe,
123, Main St.,
Springfield,
IL 62704
END
#]

#[
$country = 'UK';

$text = q:to/END/;
Dr. Jane Doe,
Sleepy Cottage,
123, Badgemore Lane,
Henley-on-Thames,
Oxon,
RG9 2XX
END
#]

my Contact $contact .= new: :$country, :$text;

ddt  $contact;
say ~$contact;
say  $contact.to-json;
```

_you are welcome to view / raise issues / make PRs if you would like to contribute..._

### TODOs

- [ ] add Email::Address (dependency)
- [ ] add more countries (GE, FR ...)

### Copyright
copyright(c) 2023 Henley Cloud Consulting Ltd.
