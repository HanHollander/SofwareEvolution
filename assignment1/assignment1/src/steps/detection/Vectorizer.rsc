module steps::detection::Vectorizer

import steps::detection::RequirementsReader;

import List;
import util::Math;
import IO;
import Set;

alias Vector = rel[str name, list[real] freq];

Vector calculateVector(Requirement reqs, list[str] vocabulary) {
	// REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
	return {};
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
