#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;

my ($address, $match);

#[
#use Contact;
use Contact::Address;

$address = q:to/END/;
123, Main St.,
Springfield,
IL 62704
USA
END

#$address = q:to/END/;
#Greenwich Cottage
#123 Tokers Green Lane
#Kidmore End
#Reading
#RG4 9AY
#END

my $ao = Contact::AddressFactory['USA'].new.parse: $address;
ddt $ao;
say $ao ~~ Address;
say $ao.^name;
#ddt Contact::Address::USA.new;

#$match = Contact::Address::Parse.new($address);
#ddt $match;
#]


#----------------------

#`[
my @street-types = <Street St Avenue Ave Av Road Rd Lane Ln Boulevard Blvd>;

role Address::Grammar::Base {
    token street {
        ^^ [<number> ','? <.ws>]? <plain-words> <.ws> <street-type> '.'? $$
    }

    token number {
        \d ** 1..5
    }

    token plain-words {
        <plain-word>+ % \h
    }

    token plain-word {
        \w+  <?{ $/ ne @street-types.any }>
    }

    token street-type {
        @street-types
    }

    token town    { <whole-line> }
    token city    { <whole-line> }
    token county  { <whole-line> }
    token country { <whole-line> }

    token whole-line {
        ^^ \V* $$
    }
}

grammar AddressUK::Grammar does Address::Grammar::Base {
    token TOP {
        [ <house>        \v  ]?
          <street>       \v
          <town>         \v
        [ <county>       \v  ]?
          <postcode>     \v?
        [ <country>      \v? ]?
    }

    token house {
        <plain-words>
    }

    token postcode {
        \w \w? \d \s* \d \w \w
    }
}

class AddressUK {
    has Str $.house;
    has Str $.street;
    has Str $.town;
    has Str $.county;
    has Str $.postcode;
    has Str $.country = 'UK';

    method get-attrs {
        <house street town county postcode country>
    }
}

class AddressUK::Actions {
    method TOP($/) {

        my %a;
        for AddressUK.get-attrs {
            %a{$^key} = $_ with $/{$^key}.made;
        }

        make AddressUK.new: |%a
    }

    method house($/)    { make ~$/ }
    method street($/)   { make ~$/ }
    method town($/)     { make ~$/ }
    method county($/)   { make ~$/ }
    method postcode($/) { make ~$/ }
    method country($/)  { make ~$/ }
}


$address = q:to/END/;
Greenwich Cottage
123 Tokers Green Lane
Kidmore End
Reading
RG4 9AY
END

#Oxon

$address ~~ s:g/','$$//;        # strip eol commas
$address ~~ s:g/<['\-%]>//;     # strip other punct
$address .= chomp;              # strip final \n

$match = AddressUK::Grammar.parse($address, :actions(AddressUK::Actions));
ddt $match.made;
#]

