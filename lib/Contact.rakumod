use Contact::Address;

role Contact {
    has Str     $.text is required;
    has Str     $.country is required where * eq <USA UK>.any;

    has Str     $.name;
    has Address $.address;
    has Bool    $.is-company;
    has Str     $.company;
    has Str     @.email;
    has Str     @.phone;

    submethod TWEAK {
        my @lines = $!text.lines;

        $!name = @lines.shift;
        $!name ~~ s:g/','$$//;

        my $address = @lines.join("\n");
        $!address = AddressFactory[$!country].new.parse: $address;
    }

    method Str {
        my @blocks = (
            self.name,
            self.address,
        );

        @blocks.join(",\n")
    }
}