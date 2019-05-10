module steps::detection::Vectorizer

import steps::detection::RequirementsReader;

import List;
import util::Math;
import IO;
import Set;

alias Vector = rel[str name, list[real] freq];

Vector calculateVector(Requirement reqs, list[str] vocabulary) {
    
    map[str, int] occurences = ();
    for (word <- vocabulary) {
        counter = 0;
        for (<_, words> <- reqs) {
            if (word in words) {
                counter = counter + 1;
            }
        }
        occurences += (word: counter);
    }
    
     
    idfs = calculateInverseDocumentFrequency(occurences, vocabulary, reqs);
    
    
    Vector result = {};
    for (<name, words> <- reqs) {
        list[real] req_vec = [];
        for (word <- vocabulary) {
            req_vec += caculateTermFrequency(word, words) * idfs[word];
            true;
        }
        result += <name, req_vec>;
    }
    
    return result;
}

@doc {
  Calculates the Inverse Document Frequency (IDF) of the different words in the vocabulary
  The 'occurences' map should map the number of requirements that contain a certain word from the vocabulary.
  The 'occurences' map should have entries for all the words in the vocabulary, otherwise an exception will be thrown.
}
private map[str,real] calculateInverseDocumentFrequency(map[str,int] occurences, list[str] vocabulary, Requirement reqs) {
  num nrOfReqs = size(reqs);
  map[str,real] idfs = (w : log2(nrOfReqs / occurences[w]) | str w <- vocabulary); 

  return idfs;
}

private int caculateTermFrequency(str term, list[str] words) {
    counter = 0;
    for (word <- words) {
        if (word == term) {
            counter = counter + 1;
        }
    }
    return counter;
}
