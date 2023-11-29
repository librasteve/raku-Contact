use v6.d;

role Address {
    has Str      $.street;
    has Str      $.town;
    has Str      $.county;
    has Str      $.postcode;
    has Str      $.country = 'UK';
}

role Contact {
#    has Bool     $.is-company;
#    has Name     $.name;
#    has Company  $.company;
    has Address  $.address;
#    has Email    $.email;
#    has Phone    $.phone;
}


use Grammar::Tracer;

my class X::Contact::CannotParse is Exception {
    has $.invalid-str;
    method message() { "Unable to parse {$!invalid-str}" }
}

class Contact::Parse is Contact does Address {
    grammar Contact::Parse::Grammar {
        token TOP {
            <ct=uk-contact>
        }

        token uk-contact {
            <postcode>
        }

        token postcode {
            \w \w? \d \s* \d \w \w
        }


    }

    class Contact::Parse::Actions {
        method TOP($/) {
            make $<ct>.made
        }

        method uk-contact($/) {
            make Contact.new(|$<address>.made,);
        }


    }

    method new(Str $text, :$rule = 'TOP') {
        Contact::Parse::Grammar.parse($text, :$rule, :actions(Contact::Parse::Actions))
                or X::Contact::CannotParse.new( invalid-str => $text ).throw;
        $/.made
    }
}


#`[
grammar Address {
    rule TOP {
        <line>+ %% \n
    }

    rule line {
        <address_line> \n?
    }

    rule address_line {
        [ <street> | <city> | <postcode> ]+
    }

    rule street {
        \S+ \s \d+ \s* [ <street_type> ]?
    }

    rule street_type {
        'Street' | 'Avenue' | 'Road' | 'Lane' | 'Boulevard'
    }

    rule city {
        \S+
    }

    rule postcode {
        \d{5}
    }
}

my $address = q:to/END/;
    123 Main Street
    Springfield, IL 62704

    456 Oak Avenue
    Shelbyville, KY 40065
END

my $match = Address.parse($address);

if $match {
    say "Address is valid!";
    say "Postcodes found:";
    for $match<postcode> {
        say $_<postcode>;
    }
} else {
    say "Invalid address!";
}

]