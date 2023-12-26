class X::Contact::Address::UK::CannotParse is Exception {
    has $.invalid-str;
    method message() { "Unable to parse...\n{$!invalid-str}" }
}

#use Grammar::Tracer;
class Contact::Address::UK::Parse {
    use Contact::Address::GrammarBase;

    grammar Grammar does Contact::Address::GrammarBase {
        token TOP {
              [ <house>        \v  ]?
                <street>       \v
                <town>         \v
              [ <county>       \v  ]?
                <postcode>     \v?
              [ <country>      \v? ]?
        }

        token house  { <plain-words> }
        token town   { <whole-line>  }
        token county { <whole-line>  }

        token postcode {
                \w [\w? | \d?]**2 <.ws>? \d \w \w
        }
    }

    class Actions {
        method TOP($/) {
            my @attrs = <house street town county postcode country>;

            my %a;
            for @attrs {
                %a{$^key} = $_ with $/{$^key}.made
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
        Grammar.parse(prep($address), :$rule, :actions(Actions))
            or X::Contact::Address::UK::CannotParse.new( invalid-str => $address ).throw;
        $/.made
    }
}

