#!/usr/bin/env raku
use v6.d;

use lib '../lib';
use Data::Dump::Tree;
use Grammar::Tracer;

#use Contact;
#
#ddt my $contact = Contact::Parse.new($text);

my ($address,$match);

my @street-types = <Street St Avenue Ave Av Road Rd Lane Ln Boulevard Blvd>;

role Address::Grammar::Base {
    token number {
        \d*
    }

    token street-type {
        @street-types
    }

    token plain-word {
        \w+  <?{ "$/" !~~ /@street-types/ }>
    }

    token plain-words {
        <plain-word>+ % \h
    }

    token street {
        ^^ [<number> ','? <.ws>]? <plain-words> <.ws> <street-type> '.'? $$
    }

    token whole-line {
        ^^ \V* $$
    }
    token house   { <whole-line> }
    token town    { <whole-line> }
    token city    { <whole-line> }
    token county  { <whole-line> }
    token country { <whole-line> }
}

#`[
grammar AddressUSA::Grammar does Address::Grammar::Base {
    token TOP {
          <street>    \v
          <city>      \v
          <state-zip> \v?
        [ <country>   \v? ]?
    }

    token state-zip {
        ^^  <state> <.ws>? <zipcode> $$    #<.ws> is [\h* | \v]
    }

    token state {
        \w \w
    }

    token zipcode {
        \d ** 5
    }
}

class AddressUSA {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zipcode;
    has Str $.country = 'USA';
}

class AddressUSA::Actions {
    method TOP($/) {
        my %a;

        %a<street>   = $<street>.made;
        %a<city>     = $<city>.made;
        %a<state>    = $<state-zip><state>.made;
        %a<zipcode>  = $<state-zip><zipcode>.made;
        %a<country>  = $<country>.made;

        make AddressUSA.new: |%a
    }

    method street($/)   { make ~$/ }
    method city($/)     { make ~$/ }
    method state($/)    { make ~$/ }
    method zipcode($/)  { make ~$/ }
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

say ~$match;
#say $match;
ddt $match.made;

#]


grammar AddressUK::Grammar does Address::Grammar::Base {
    token TOP {
          <house-street> \v
          <town>         \v
        [ <county>       \v  ]?
          <postcode>     \v?
        [ <country>      \v? ]?
    }

    token house-street {
      ^^[ <house>        \v  ]?
          <street>              $$
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
}

class AddressUK::Actions {
    method TOP($/) {
        my %a;
        %a<house>    = $<house-street><house>.made;
        %a<street>   = $<house-street><street>.made;
        %a<town>     = $<town>.made;
        %a<county>   = $<county>.made;
        %a<postcode> = $<postcode>.made;
        %a<country>  = $<country>.made;

        make AddressUK.new: |%a
    }

    method house($/)    { make ~$/ }   #iamerejh what if drop house / country
    method street($/)   { make ~$/ }
    method town($/)     { make ~$/ }
    method county($/)   { make ~$/ }
    method postcode($/) { make ~$/ }
    method country($/)  { make ~$/ }
}

#Greenwich Cottage
$address = q:to/END/;
123 Tokers Green Lane
Kidmore End
Reading
RG4 9AY
UK
END

#Oxon

$address ~~ s:g/','$$//;        # strip eol commas
$address ~~ s:g/<['\-%]>//;     # strip other punct
$address .= chomp;              # strip final \n

$match = AddressUK::Grammar.parse($address, :actions(AddressUK::Actions));

#say ~$match;
#say $match;
ddt $match.made;




