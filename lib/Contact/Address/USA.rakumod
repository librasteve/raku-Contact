use Contact::Address::GrammarBase;

#use Grammar::Tracer;
class Contact::Address::USA::Parse {
    my @attrs = <street city state zip country>;

    grammar Grammar does Contact::Address::GrammarBase {
        token TOP {
            <street>  \v
            <city>    \v
            <state> <.ws> <zip> \v?    #<.ws> is [\h* | \v]
          [ <country> \v? ]?
        }

        token state {
            \w \w
        }

        token zip {
            \d ** 5
        }
    }

    class Actions {
        method TOP($/) {
            my %a;

            for @attrs {
                %a{$^key} = $_ with $/{$^key}.made
            }

            make %a
        }

        method street($/)   { make ~$/ }
        method city($/)     { make ~$/ }
        method state($/)    { make ~$/ }
        method zip($/)      { make ~$/ }
        method country($/)  { make ~$/ }
    }

    method new(Str $address is rw, :$rule = 'TOP') {
        prep $address;

        Grammar.parse($address, :$rule, :actions(Actions));
#            or X::Contact::Address::CannotParse.new( invalid-str => $address ).throw;
        $/.made
    }
}

