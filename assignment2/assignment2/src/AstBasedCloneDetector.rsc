module AstBasedCloneDetector

import lang::java::m3::AST;

import steps::astbased::FileParser;
import steps::stringbased::FileReader;
import steps::astbased::CloneDetector;
import DataTypes;
import Exception;
import Type;
import NiCad5ResultReader;
import CloneEvaluator;
import lang::csv::IO;

import IO;
import Map;
import Set;

void detectClonesUsingAstsOnSmallSet() = detectClonesUsingAsts(|project://assignment2/data/small|, true);
void detectClonesUsingAstsOnLargeSet() = detectClonesUsingAsts(|project://assignment2/data/large|, false);

void detectClonesUsingAsts(loc dataDir, bool isSmall) {
  	println("STEP (0/4) Reading files");
  	map[loc,Declaration] methods = getAllMethods(dataDir);
  	
  	println("STEP (1/4) Detecting Type 1 and Type 2 Clones");
	Clone clones = detectTypeOneAndTypeTwoClones(methods);
	
	println("======================");
	println("===== EVALUATION =====");
	println("======================");
	println("STEP (2/4) Reading NiCad5 results");
	Clone nicadresults;
	if (isSmall) {
		nicadresults = readNiCad5ResultForSmallSet();
	} else {
		nicadresults = readNiCad5ResultForLargeSet();
	}
	
	println("STEP (3/4) Evaluating Clones");
	nicadresults = {<a,b,c,d> | <a,b,c,d> <- nicadresults, couldSubTreeBeAClone(methods[a]), couldSubTreeBeAClone(methods[b])};
	set[loc] allMethods = {key | key <- methods};
	evaluate(nicadresults, clones, allMethods);
	
	println("STEP (4/4) Writing results CSV");
	writeCSV(clones, |project://assignment2/data/ast_result.csv|);
}