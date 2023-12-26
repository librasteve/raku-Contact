class X::Contact::Address::USA::CannotParse is Exception {
    has $.invalid-str;
    method message() { "Unable to parse...\n{$!invalid-str}" }
}

#use Grammar::Tracer;
class Contact::Address::USA::Parse {
    use Contact::Address::GrammarBase;

    grammar Grammar does Contact::Address::GrammarBase {
        #<.ws> is [\h | \v] (allows city-state-zip on single line)
        token TOP {
                <street>  \v
                <city>  <.ws> ','? <.ws>
                <state> <.ws>
                <zip> \v?
              [ <country> \v? ]?
        }
        token city  { <plain-words> }
        token state { \w ** 2 }
        token zip   { \d ** 5 }
    }

    class Actions {
        method TOP($/) {
            my @attrs = <street city state zip country>;

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
        Grammar.parse(prep($address), :$rule, :actions(Actions))
            or X::Contact::Address::USA::CannotParse.new( invalid-str => $address ).throw;
        $/.made
    }
}

