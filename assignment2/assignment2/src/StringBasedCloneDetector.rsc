module StringBasedCloneDetector

import DataTypes;
import steps::stringbased::FileReader;
import steps::stringbased::LineTransformer;

import IO;

void detectClonesUsingStringsOnSmallSet() = detectClonesUsingStrings(|project://assignment2/data/small|);
void detectClonesUsingStringsOnLargeSet() = detectClonesUsingStrings(|project://assignment2/data/large|);

void detectClonesUsingStrings(loc dataDir) {

	println("STEP (0/9) Reading files");
	MethodContent origMethods = readFiles(dataDir);
	
	
	// ================
	// Type 1 detection
	// ================
	
	// STEP 1: Transform text (Remove whitespace and comments)
	println("STEP (1/9) Trasforming text");
	MethodContent methods = removeWhitespaceAndComments(origMethods);
	
	// STEP 2: Build line by line matrices
	
	// STEP 3: Extract duplication sequences (Type 1)
	
	
	// ================
	// Type 2 detection
	// ================
	
	// STEP 4: Rename variables to X
	
	// STEP 5: Transform text (Remove whitespace and comments)
	
	// STEP 6: Build line by line matrices
	
	// STEP 7: Extract duplication sequences (Type 2)
	
	// STEP 8: Construct result
	
	// STEP 9: Evaluate result
	
}