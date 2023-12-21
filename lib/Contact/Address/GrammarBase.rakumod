sub prep($address is rw) is export {
    $address ~~ s:g/','$$//;
    $address ~~ s:g/<['\%]>//;
    $address .= chomp;
    $address
}

role Contact::Address::GrammarBase {
    ### Anglophile
    my @street-types = <Street St Avenue Ave Av Road Rd Lane Ln Boulevard Blvd>;

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

    token city    { <whole-line> }   #iamerejh

    token town    { <whole-line> }
    token county  { <whole-line> }
    token country { <whole-line> }

    token whole-line {
        ^^ \V* $$
    }
}