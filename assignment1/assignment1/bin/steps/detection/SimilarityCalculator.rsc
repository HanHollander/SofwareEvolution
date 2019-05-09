module steps::detection::SimilarityCalculator

import steps::detection::RequirementsReader;
import steps::detection::Vectorizer;

import util::Math;
import IO;
import Set;
import List;

alias SimilarityMatrix = rel[str highlevel, str lowlevel, real score];

SimilarityMatrix calculateSimilarityMatrix(Requirement highlevel, Requirement lowlevel, Vector vec) {
	// TODO: Calculate the similarity matrix of the high- and lowlevel requirements using the passed in vectors
	// You can use the given function 'cos(list[real] high, list[real] low)' to calculate the similarity score of two requirements

  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return {};
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