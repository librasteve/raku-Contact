use v6.d;
role Contact::Address::Loose {
    has Str @.lines;

    has Str @.meta = <
        Street
        TownOrCity
        County
        Postcode
        CountryOrRegion
    >;
}
