module TraceLinkEvaluator

import DataSet;
import steps::detection::TraceLinkConstructor;
import steps::detection::RequirementsReader;

import steps::evaluation::ManualTraceLinkReader;
import steps::evaluation::ResultsCalculator;
import steps::evaluation::ResultsWriter;

import IO;
import String;
import ValueIO;
import Set;
import List;
import util::Math;

void evaluateGroup1() = evaluate(group1());
void evaluateGroup9() = evaluate(group9());

void evaluate(DataSet grp) {
  if (!exists(grp.dir + "tracelinks.result")) {
    throw "No trace-links created yet. Please run detector first";
  }

  println("(1/4) Reading requirements");
	Requirement highlevel = readHighlevelRequirements(grp);
	Requirement lowlevel = readLowlevelRequirements(grp);
  
  println("(2/4) Reading manual found trace-links");
	TraceLink manual = readManualTraceLinks(grp);
	
	println("(3/4) Reading trace-links found by automatic detection");
  AllTraceLinks allLinks = readTextValueFile(#AllTraceLinks, grp.dir + "tracelinks.result");
	
	println("(4/4) Evaluating automatic detection methods and writing result to disc");
	for (int i <- [0..size(allLinks)]) {
	  println("  - <i+1> out of <size(allLinks)>");
		result = evaluateMethod(manual, allLinks[i], highlevel, lowlevel);
		writeResultFile(grp, "method<i+1>", allLinks[i], result);
	}
}