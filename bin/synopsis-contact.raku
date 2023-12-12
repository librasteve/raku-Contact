#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

use Contact;

my $text;

#[
$text = q:to/END/;
John Doe,
123, Main St.,
Springfield,
IL 62704
END

my $us-c = Contact.new: :$text, country => 'USA';
ddt $us-c;
say ~$us-c;
#]

#[
$text = q:to/END/;
Dr. Jane Doe,
Sleepy Cottage,
123, Badgemore Lane,
Henley-on-Thames,
Oxon,
RG9 2XX
END

my $uk-c = Contact.new: :$text, country => 'UK';
ddt $uk-c;
say ~$uk-c;
#]

