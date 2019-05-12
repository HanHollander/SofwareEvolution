module steps::detection::SimilarityCalculator

import steps::detection::RequirementsReader;
import steps::detection::Vectorizer;

import util::Math;
import IO;
import Set;
import List;

alias SimilarityMatrix = rel[str highlevel, str lowlevel, real score];

SimilarityMatrix calculateSimilarityMatrix(Requirement highlevel, Requirement lowlevel, Vector vec) {
    result = {<high_name, low_name, cos(high, low)> | <high_name, _> <- highlevel, <low_name, _> <- lowlevel, 
                                                      <high_name, high> <- vec, <low_name, low> <- vec};
  return result;
}

// TODO: Add extra functions if wanted / needed

@doc {
  Calculate the cosinus of two (real) vectors.
}
real cos(list[real] high, list[real] low) {
	real top = (0. | it + high[i] * low[i] | int i <- [0..size(high)]);
	
	real x = sqrt((0. | it + h * h | real h <- high));
	real y = sqrt((0. | it + l * l | real l <- low));
	
	return top / (x * y);
}