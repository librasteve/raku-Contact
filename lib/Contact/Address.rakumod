role Contact::Address is export {
    method parse(Str $) {...}
    method Str {...}
}

role Contact::AddressFactory[Str $country='USA'] is export {
    method new {
        Contact::Address::{$country}.new
    }
}

class Contact::Address::USA does Contact::Address {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zip;
    has Str $.country = 'USA';

    method parse($address is rw) {
        #load lib/Contact/Address/USA/Parse.rakumod
        use Contact::Address::USA::Parse;

        my %a = Contact::Address::USA::Parse.new: $address;
        self.new: |%a
    }

    method Str {
        my @lines = (
            self.street,
            self.city,
            self.state ~ " " ~ self.zip,
            self.country,
        );

        @lines.join(",\n")
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
        use Contact::Address::UK::Parse;

        my %a = Contact::Address::UK::Parse.new: $address;
        self.new: |%a
    }

    method Str {
        my @lines = (
            self.house,
            self.street,
            self.town,
            self.county,
            self.postcode,
            self.country,
        );

        @lines.join(",\n")
    }
}
