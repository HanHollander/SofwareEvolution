module TraceLinkDetector

import DataSet;
import steps::detection::RequirementsReader;
import steps::detection::StopWordRemover;
import steps::detection::Stemmer;
import steps::detection::VocabularyBuilder;
import steps::detection::Vectorizer;
import steps::detection::SimilarityCalculator;
import steps::detection::TraceLinkConstructor;

import IO;
import ValueIO;
import List;

void gatherLinksGroup1() = gatherLinks(group1());
void gatherLinksGroup9() = gatherLinks(group9());

void gatherLinks(DataSet grp) {
	println("(1/7) Reading highlevel requirements");
	Requirement highlevel = readHighlevelRequirements(grp);
	println("(2/7) Reading lowlevel requirements");
	Requirement lowlevel = readLowlevelRequirements(grp);
	
	println("(3/7) Removing stop words and apply stemming");
	highlevel = stemWords(removeStopWords(highlevel));
	lowlevel = stemWords(removeStopWords(lowlevel));
	
	println("(4/7) Building master vocabulary");
	list[str] vocabulary = extractVocabulary(highlevel + lowlevel);
	
	println("(5/7) Calculating vectors");
	Vector vectors = calculateVector(highlevel + lowlevel, vocabulary);

	println("(6/7) Calculating similarity matrix");
	SimilarityMatrix sm = calculateSimilarityMatrix(highlevel, lowlevel, vectors);
	
	println("(7/7) Gathering trace links for different methods");
	AllTraceLinks allLinks = constructLinks(sm);
	
    writeTextValueFile(grp.dir + "tracelinks.result", allLinks);  
	
	println("Done");
	
	for (int i <- [0..size(allLinks)]) {
		printLinks(allLinks[i], i);
	}
}

void printLinks(TraceLink links, int i) {
	println();
	println("Results for method <i>:");
	println("=======================");
	
	for (str high <- links<0>) {
		println("<high> : <links[high]>");
	}
}
