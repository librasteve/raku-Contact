use Contact::Address::GrammarBase;


#role Contact::Address::GrammarBase {
#    token street {
#        ^^ [<number> ','? <.ws>]? <plain-words> <.ws> <street-type> '.'? $$
#    }
#
#    token number {
#        \d ** 1..5
#    }
#
#    token plain-words {
#        <plain-word>+ % \h
#    }
#
#    token plain-word {
#        \w+  <?{ $/ ne @street-types.any }>
#    }
#
#    token street-type {
#        @street-types
#    }
#
#    token town    { <whole-line> }
#    token city    { <whole-line> }
#    token county  { <whole-line> }
#    token country { <whole-line> }
#
#    token whole-line {
#        ^^ \V* $$
#    }
#}

#use Grammar::Tracer;
class Contact::Address::USA::Parse {
    grammar Contact::Address::USA::Parse::Grammar does Contact::Address::GrammarBase {
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

    class Contact::Address::USA::Parse::Actions {
        method TOP($/) {

            my %a;
            for <street city state zip country> {
#            for Contact::Address::USA.get-attrs {
                %a{$^key} = $_ with $/{$^key}.made;
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

        Contact::Address::USA::Parse::Grammar.parse($address, :$rule,
                :actions(Contact::Address::USA::Parse::Actions));
#            or X::Contact::Address::CannotParse.new( invalid-str => $address ).throw;
        $/.made
    }
}

