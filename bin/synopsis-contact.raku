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

#`[
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



