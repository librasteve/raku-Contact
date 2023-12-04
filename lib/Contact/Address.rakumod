role Contact::Address is export {
    method get-attrs {...}

    method parse(Str $) {...}
}

class Contact::Address::USA does Contact::Address is export {
    has Str $.street;
    has Str $.city;
    has Str $.state;
    has Str $.zip;
    has Str $.country = 'USA';

    method get-attrs {
        <street city state zip country>
    }

    method parse($address is rw) {
        use Contact::Address::USA;
        say 'yo';

        Contact::Address::USA::Parse.new: $address
    }
}

class Contact::Address::UK does Contact::Address is export {
    has Str $.house;
    has Str $.street;
    has Str $.town;
    has Str $.county;
    has Str $.postcode;
    has Str $.country = 'UK';

    method get-attrs {
        <house street town county postcode country>
    }

    method parse($address) {
        say 'yo'
    }
}

role Contact::AddressFactory[Str $country='USA'] is export {
    method new {
        Contact::Address::{$country}.new
    }
}
