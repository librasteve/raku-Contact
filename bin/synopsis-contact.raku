#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

#use Contact;
use Contact::Address;

my ($address, $match, $ao);

#[
$address = q:to/END/;
123, Main St.,
Springfield,
IL 62704
USA
END

$ao = Contact::AddressFactory['USA'].new.parse: $address;
ddt $ao;
say $ao ~~ Address;
say $ao.^name;
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

$ao = Contact::AddressFactory['UK'].new.parse: $address;
ddt $ao;
say $ao ~~ Address;
say $ao.^name;
#]

