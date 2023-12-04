#use Grammar::Tracer;

#FIXME USA back in

use Contact::Address;

my class X::Contact::Address::CannotParse is Exception {
    has $.invalid-str;
    method message() { "Unable to parse {$!invalid-str}" }
}

my @street-types = <Street St Avenue Ave Av Road Rd Lane Ln Boulevard Blvd>;

role Contact::Address::Grammar::Base {
    token street {
        ^^ [<number> ','? <.ws>]? <plain-words> <.ws> <street-type> '.'? $$
    }

    token number {
        \d ** 1..5
    }

    token plain-words {
        <plain-word>+ % \h
    }

    token plain-word {
        \w+  <?{ $/ ne @street-types.any }>
    }

    token street-type {
        @street-types
    }

    token town    { <whole-line> }
    token city    { <whole-line> }
    token county  { <whole-line> }
    token country { <whole-line> }

    token whole-line {
        ^^ \V* $$
    }
}

class Contact::Address::Parse is Contact::Address {
    grammar Contact::Address::Parse::Grammar does Contact::Address::Grammar::Base {
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

    class Contact::Address::Parse::Actions {
        method TOP($/) {

            my %a;
            for Address.get-attrs {
                %a{$^key} = $_ with $/{$^key}.made;
            }

            make Address.new: |%a
        }

        method street($/)   { make ~$/ }
        method city($/)     { make ~$/ }
        method state($/)    { make ~$/ }
        method zip($/)      { make ~$/ }
        method country($/)  { make ~$/ }
    }

    method new(Str $text is rw, :$rule = 'TOP') {
        $text ~~ s:g/','$$//;
        $text ~~ s:g/<['\-%]>//;
        $text .= chomp;
        
        Contact::Address::Parse::Grammar.parse($text, :$rule, :actions(Contact::Address::Parse::Actions))
            or X::Contact::Address::CannotParse.new( invalid-str => $text ).throw;
        $/.made
    }
}

