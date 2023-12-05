use Contact::Address;

role Contact {
    has Str      $.text;
    has Str      $.country where * eq <USA UK>.any;
    has Str      $.name;
    has Address  $.address;
#    has Bool     $.is-company;
#    has Company  $.company;
#    has Email    @.email;
#    has Phone    @.phone;

    submethod TWEAK {
        my @lines = $!text.lines;

        $!name = @lines.shift;
        $!name ~~ s:g/','$$//;

        my $address = @lines.join("\n");
        $!address = AddressFactory[$!country].new.parse: $address;
    }
}