#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

#use Contact;
use Contact::Address;

my $address;

#[
$address = q:to/END/;
123, Main St.,
Springfield,
IL 62704
USA
END

ddt AddressFactory['USA'].new.parse: $address;
#]

#[
$address = q:to/END/;
Greenwich Cottage
123 Tokers Green Lane
Kidmore End
Reading
RG4 9AY
END

#Oxon

ddt AddressFactory['UK'].new.parse: $address;
#]

