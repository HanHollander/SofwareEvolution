module StringBasedCloneDetector

import DataTypes;
import NiCad5ResultReader;
import CloneEvaluator;
import steps::stringbased::FileReader;
import steps::stringbased::LineTransformer;
import steps::stringbased::MatrixConstructor;
import steps::stringbased::CloneDetector;

import IO;
import List;
import Map;
import Relation;
import Set;
import lang::csv::IO;


void detectClonesUsingStringsOnSmallSet() = detectClonesUsingStrings(|project://assignment2/data/small|, true);
void detectClonesUsingStringsOnLargeSet() = detectClonesUsingStrings(|project://assignment2/data/large|, false);

void detectClonesUsingStrings(loc dataDir, bool isSmall) {

	println("STEP (0/9) Reading files");
	MethodContent origMethods = readFiles(dataDir);
	
	
	// ================
	// Type 1 detection
	// ================
	
	// STEP 1: Transform text (Remove whitespace and comments)
	println("STEP (1/9) Transform text");
	MethodContent methods = removeWhitespaceAndComments(origMethods);
	
	// STEP 2: Extract type one clones
	println("STEP (2/9) Extract type one clones");
	Clone typeOneClones = extractTypeOneOrTwoClones(methods, {}, type1());
	set[set[loc]] combsDone = {{loc1,loc2} | <loc1,loc2,_,_> <- typeOneClones};
	
	
	// ================
	// Type 2 detection
	// ================
	
	// STEP 3: Rename variables to X
	println("STEP (3/9) Rename variables to X");
	MethodContent methods2 = renameVariables(origMethods);
	
	// STEP 4: Transform text (Remove whitespace and comments)
	println("STEP (4/9) Transform text");
	methods2 = removeWhitespaceAndComments(methods2);
	
	// STEP 5: Extract type two clones
	println("STEP (5/9) Extract type two clones");
	Clone typeTwoClones = extractTypeOneOrTwoClones(methods2, combsDone, type2());
	combsDone += {{loc1,loc2} | <loc1,loc2,_,_> <- typeTwoClones};
	
	// STEP 6: Extract type three clones
	println("STEP (6/9) Extract type three clones");
	Clone typeThreeClones = {};
	//Clone typeThreeClones = extractTypeThreeClones(methods2, combsDone);
	
	println("======================");
	println("===== EVALUATION =====");
	println("======================");
	println("STEP (7/9) Reading NiCad5 results");
	Clone nicadresults;
	if (isSmall) {
		nicadresults = readNiCad5ResultForSmallSet();
	} else {
		nicadresults = readNiCad5ResultForLargeSet();
	}
	
	println("STEP (8/9) Evaluating Clones");
	nicadresults = {<a,b,c,d> | <a,b,c,d> <- nicadresults, size(methods[a]) > 9, size(methods[b]) > 9};
	set[loc] allMethods = {key | key <- origMethods};
	evaluate(nicadresults, typeOneClones + typeTwoClones + typeThreeClones, allMethods);
	
	println("STEP (9/9) Writing results CSV");
	writeCSV(typeOneClones + typeTwoClones + typeThreeClones, |project://assignment2/data/string_result.csv|);
}

int sizeOfClones(Clone clones) {
	int result = 0;
	for (<a,b,_,_> <- clones)
		result += 1;
	return result;
}


