#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;
use Grammar::Tracer;

#use Contact;
#
#ddt my $contact = Contact::Parse.new($text);

my ($address, $match);

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

#[
grammar AddressUSA::Grammar does Address::Grammar::Base {
    token TOP {
          <street>    \v
          <city>      \v
          <state> <.ws> <zip> \v?    #<.ws> is [\h* | \v]
        [ <country>   \v? ]?
    }

    token state {
        \w \w
    }

    token zip {
        \d ** 5
    }
}

class AddressUSA {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zip;
    has Str $.country = 'USA';

    method get-attrs {
        <street city state zip country>
    }
}

class AddressUSA::Actions {
    method TOP($/) {

        my %a;
        for AddressUSA.get-attrs {
            %a{$^key} = $_ with $/{$^key}.made;
        }

        make AddressUSA.new: |%a
    }

    method street($/)   { make ~$/ }
    method city($/)     { make ~$/ }
    method state($/)    { make ~$/ }
    method zip($/)      { make ~$/ }
    method country($/)  { make ~$/ }
}


$address = q:to/END/;
123, Main St.,
Springfield,
IL 62704
USA
END

$address ~~ s:g/','$$//;
$address ~~ s:g/<['\-%]>//;
$address .= chomp;

#$match = AddressUSA::Grammar.parse($address);
$match = AddressUSA::Grammar.parse($address, :actions(AddressUSA::Actions));

#say ~$match;
#say $match;
ddt $match.made;
#]

#`[
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
#$match = AddressUK::Grammar.parse($address);

#say ~$match;
#say $match;
ddt $match.made;
#]



