#use Grammar::Tracer;  #uncomment for debug
use Contact::Address::GrammarBase;

class X::Contact::Address::USA::CannotParse is Exception {
    has $.address;
    method message() { "Unable to parse...\n" ~ $!address }
}

class Contact::Address::USA::Parse {
    has $.address is rw;
    has @.attrs;
    my  @battrs;   #binds to @.attrs

    grammar Grammar does GrammarBase {
        #<.ws> is [\h | \v] (allows single & multi line layouts)
        token TOP {
                <street>    \v
                <city> ','? <.ws>
                <state>     <.ws>
                <zip>       \v?
              [ <country>   \v? ]?
        }

        token city    { <nost-words> }
        token state   { \w ** 2 }
        token zip     { \d ** 5 }
        token country { <whole-line> }
    }

    class Actions {
        method TOP($/) {
            make-attrs($/, @battrs)
        }

        method street($/)   { make ~$/ }
        method city($/)     { make ~$/ }
        method state($/)    { make ~$/ }
        method zip($/)      { make ~$/ }
        method country($/)  { make ~$/ }
    }

    method TWEAK {
        @battrs := @!attrs;
    }

    method parse {
        Grammar.parse($!address.&prep, :actions(Actions))
                or X::Contact::Address::USA::CannotParse.new(:$!address).throw;
        $/.made
    }
}
