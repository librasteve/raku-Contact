#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

use Contact;

my $text;

#`[
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
Dr.John Smith
123 Main Street
London
SW1A 1AA
UK
END

#Oxon

ddt Contact.new: :$text, country => 'UK';
#]

