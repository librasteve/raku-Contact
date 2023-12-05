use Contact::Address::GrammarBase;

#use Grammar::Tracer;
class Contact::Address::UK::Parse {
    my @street-types = <Street St Avenue Ave Av Road Rd Lane Ln Boulevard Blvd>;

    grammar Contact::Address::UK::Parse::Grammar does Contact::Address::GrammarBase {
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

    class Contact::Address::UK::Parse::Actions {
        method TOP($/) {

            my %a;

            for <house street town county postcode country> {
#            for Contact::Address::UK.get-attrs {
                %a{$^key} = $_ with $/{$^key}.made;
            }
            make %a
        }

        method house($/)    { make ~$/ }
        method street($/)   { make ~$/ }
        method town($/)     { make ~$/ }
        method county($/)   { make ~$/ }
        method postcode($/) { make ~$/ }
        method country($/)  { make ~$/ }

    }

    method new(Str $address is rw, :$rule = 'TOP') {
        prep $address;

        Contact::Address::UK::Parse::Grammar.parse($address, :$rule,
                :actions(Contact::Address::UK::Parse::Actions));
#                or X::Contact::Address::CannotParse.new( invalid-str => $address ).throw;
        $/.made
    }
}

