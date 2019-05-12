module steps::evaluation::ResultsCalculator

import steps::detection::RequirementsReader;
import steps::detection::TraceLinkConstructor;

import Set;
import List;
import util::Math;
import IO;

alias ConfusionMatrix = tuple[int truePositives, int falsePositives, int trueNegatives, int falseNegatives];
alias EvaluationResult = tuple[ConfusionMatrix cm, real precision, real recall, real fMeasure];

EvaluationResult evaluateMethod(TraceLink manual, TraceLink fromMethod, Requirement highlevel, Requirement lowlevel) {
	cm = calculateConfusionMatrix(manual, fromMethod, highlevel, lowlevel);	
	p = calculatePrecision(cm);
	r = calculateRecall(cm);
	return <cm, p, r, calculateFMeasure(p, r)>;
}

private real calculatePrecision(ConfusionMatrix cm) {
    <tp, fp, _, _> = cm;
    return toReal(tp) / (toReal(tp) + toReal(fp));
}

private real calculateRecall(ConfusionMatrix cm) {
    <tp, _, _, fn> = cm;
    return toReal(tp) / (toReal(tp) + toReal(fn));
}

private real calculateFMeasure(real p, real r) {
	if (p == 0 && r == 0) {
		return 0.;
	}
    return 2 * ((p*r)/(p+r));
}

private ConfusionMatrix calculateConfusionMatrix(TraceLink manual, TraceLink automatic, Requirement highlevel, Requirement lowlevel) {
	// TODO: Construct the confusion matrix.
	// True positives: Nr of trace-link predicted by the tool AND identified manually  
    // False positives: Nr of trace-link predicted by the tool BUT NOT identified manually
    // True negatives: Nr of trace-link NOT predicted by the tool AND NOT identified manually
    // False negatives: Nr of trace-link NOT predicted by the tool BUT identified manually
      
    all_traces = {<high, low> | <high, _> <- highlevel, <low, _> <- lowlevel};
    
    tp = size(manual & automatic);
    fp = size(automatic - manual);
    tn = size(all_traces - manual - automatic);
    fn = size(manual - automatic);
    
    return <tp, fp, tn, fn>;
}