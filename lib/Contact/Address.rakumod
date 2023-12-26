### common roles for Contact::Address classes ###

role Contact::Address is export {
    method parse(Str $) {...}

    method list-attrs {
        self.^attributes.grep({
            .has_accessor  &&
            .package.^name eq self.^name
        }).map({
            .name.subst(/^'$!'/, '')
        })
    }

    method Str {
        gather {
            for |self.list-attrs {
                my $attr := self."$_"();
                take $attr with $attr
            }
        }.join(",\n")
    }
}

role Contact::AddressFactory[Str $country='USA'] is export {
    method new {
        Contact::Address::{$country}.new
    }
}

### vestigal plugin model -  tbd autoscan lib files for all languages ###

class Contact::Address::USA does Contact::Address {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zip;
    has Str $.country = 'USA';

    method parse($address is rw) {
        #load lib/Contact/Address/USA/Parse.rakumod
        require Contact::Address::USA::Parse;

        my %a = Contact::Address::USA::Parse.new(:$address, attrs => self.list-attrs).parse;
        self.new: |%a
    }
}

class Contact::Address::UK does Contact::Address {
    has Str $.house;
    has Str $.street;
    has Str $.town;
    has Str $.county;
    has Str $.postcode;
    has Str $.country = 'UK';

    method parse($address is rw) {
        #load lib/Contact/Address/UK/Parse.rakumod
        require Contact::Address::UK::Parse;

        my %a = Contact::Address::UK::Parse.new(:$address, attrs => self.list-attrs).parse;
        self.new: |%a
    }
}
