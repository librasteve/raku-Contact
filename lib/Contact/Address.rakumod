role Contact::Address is export {
    method parse(Str $) {...}
}

class Contact::Address::USA does Contact::Address is export {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zip;
    has Str $.country = 'USA';

    method parse($address is rw) {
        use Contact::Address::USA;

        my %a = Contact::Address::USA::Parse.new: $address;
        self.new: |%a
    }
}

class Contact::Address::UK does Contact::Address is export {
    has Str $.house;
    has Str $.street;
    has Str $.town;
    has Str $.county;
    has Str $.postcode;
    has Str $.country = 'UK';

    method parse($address is rw) {
        use Contact::Address::UK;

        my %a = Contact::Address::UK::Parse.new: $address;
        self.new: |%a
    }
}

role Contact::AddressFactory[Str $country='USA'] is export {
    method new {
        Contact::Address::{$country}.new
    }
}
