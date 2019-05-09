module steps::detection::Stemmer

import analysis::text::stemming::Snowball;

import steps::detection::RequirementsReader;

import IO;
import ValueIO;

Requirement stemWords(Requirement reqs) {
    

  result_reqs = {<name, stemAll(words)> | <name, words> <- reqs};
    
  
    
    return result_reqs;
}

// TODO: Add extra functions if wanted / needed

@doc {
  Returns the passed in list of words in a stemmed form
}
list[str] stemAll(list[str] orig) = [porterStemmer(w) | w <- orig];

test bool shouldStemWeakness() = stemWords({<"A1",["weakness"]>}) == {<"A1", ["weak"]>};
test bool shouldStemRunningAndWalking() = stemWords({<"A1",["running","walking"]>}) == {<"A1", ["run","walk"]>};
