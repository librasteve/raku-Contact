#use Grammar::Tracer;  #uncomment for debug
use Contact::Address::GrammarBase;

class X::Contact::Address::UK::CannotParse is Exception {
    has $.address;
    method message() { "Unable to parse...\n" ~ $!address }
}

class Contact::Address::UK::Parse {
    has $.address is rw;
    has @.attrs;
    my  @battrs;   #will bind to @.attrs

    grammar Grammar does GrammarBase {
        token TOP {
              [ <house>        \v  ]?
                <street>       \v
                <town>         <.ws>
              [ <county>       <.ws>]?
                <postcode>     \v?
              [ <country>      \v? ]?
        }

        token house   { <nodt-words> }
        token town    { <nodt-words> }
        token county  { <nodt-words> }
        token country { <whole-line> }

        token postcode {
                \w [\w? | \d?]**2 \d? <.ws>? \d \w \w
        }

        token nodt-word {
            \S+ <?{ $/ !~~ /\d/ }>
        }

        token nodt-words {
            <nodt-word>+ %% \h
        }
    }

    class Actions {
        method TOP($/) {
            make-attrs($/, @battrs)
        }

        method house($/)    { make ~$/ }
        method street($/)   { make ~$/ }
        method town($/)     { make ~$/ }
        method county($/)   { make ~$/ }
        method postcode($/) { make ~$/ }
        method country($/)  { make ~$/ }
    }

    method TWEAK {
        @battrs := @!attrs;
    }

    method parse {
        Grammar.parse($!address.&prep, :actions(Actions))
                or X::Contact::Address::UK::CannotParse.new(:$!address).throw;
        $/.made
    }
}
