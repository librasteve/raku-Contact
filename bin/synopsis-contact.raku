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
USA
END

ddt Contact.new: :$text, country => 'USA';
#]

#[
$text = q:to/END/;
Dr. Jane Doe,
Sleepy Cottage
123, Badgemore Lane
Henley-on-Thames
Oxon
RG9 2XX
END

#Oxon

ddt Contact.new: :$text, country => 'UK';
#]

