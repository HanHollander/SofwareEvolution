module steps::detection::VocabularyBuilder

import steps::detection::RequirementsReader;

import IO;
import ValueIO;
import List;
import List::splice;

list[str] extractVocabulary(Requirement reqs) {
  
  list_of_lists = [words | <_, words> <- reqs];
  list_of_words = abc(list_of_lists);
  
  result_vocabulary = [word | word <- {word | word <- list_of_words}];
  
  return result_vocabulary; 
}

list[str] abc(list[list[str]] list_of_lists) {
    result_list = [];
    for (l <- list_of_lists) {
        result_list = result_list + l;
    }
    return result_list;
}
