module steps::evaluation::ResultsCalculator

import steps::detection::RequirementsReader;
import steps::detection::TraceLinkConstructor;

import Set;
import util::Math;
import IO;

alias ConfusionMatrix = tuple[int truePositives, int falsePositives, int trueNegatives, int falseNegatives];
alias EvaluationResult = tuple[ConfusionMatrix cm, real precision, real recall, real fMeasure];

EvaluationResult evaluateMethod(TraceLink manual, TraceLink fromMethod, Requirement highlevel, Requirement lowlevel) {
	// TODO: Evaluate the different methods by calculating the confuction matrix and recall and precision for each one.
	
	// REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
	return <<0,0,0,0>,0.,0.,0.>;
}

private real calculatePrecision(ConfusionMatrix cm) {
  // TODO

  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return 0.;
}

private real calculateRecall(ConfusionMatrix cm) { 
  // TODO
  
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return 0.;
}

private real calculateFMeasure(real precision, real recall) {
  // TODO
  
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return 0.;
}

private ConfusionMatrix calculateConfusionMatrix(TraceLink manual, TraceLink automatic, Requirement highlevel, Requirement lowlevel) {
	// TODO: Construct the confusion matrix.
	// True positives: Nr of trace-link predicted by the tool AND identified manually  
  // False positives: Nr of trace-link predicted by the tool BUT NOT identified manually
  // True negatives: Nr of trace-link NOT predicted by the tool AND NOT identified manually
  // False negatives: Nr of trace-link NOT predicted by the tool BUT identified manually

  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
	return <0,0,0,0>;
}