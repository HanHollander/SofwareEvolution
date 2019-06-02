module steps::stringbased::LineTransformer

import steps::stringbased::FileReader;
import IO;
import String;
import List;
import Map;
import util::Math;
import util::ProgressBar;

set[str] reservedWords = {"abstract","assert","boolean","break","byte","case","catch","char","class","const",
						"continue","default","double","do","else","enum","extends","false","final","finally",
						"float","for","goto","if","implements","import","instanceof","int","interface","long",
						"native","new","null","package","private","protected","public","return","short","static",
						"strictfp","super","switch","synchronized","this","throw","throws","transient","true",
						"try","void","volatile","while"};

MethodContent removeWhitespaceAndComments(MethodContent methods) {
	real progTotal = toReal(size(methods));
	real progCur = 0.;
	progress(progTotal, progCur);
	
	MethodContent result = ();
	// For each method
	for (loc fname <- methods) {
		Content content = [];
		commentOpened = false;
		// For each line
		for (<loc nr, line> <- methods[fname]) {
			line = visit(line) {
				case /[\n\t\r ]/ => "" // Remove whitespace
			}
			
			if (commentOpened) {
				if (containsBlockCommentClose(line)) {
					commentOpened = false;
					
					line = removeAnnotations(removeComments(line));
					if (size(line) > 0)
						content += [<nr, line>];
				}
			} else {
				if (containsBlockCommentOpen(line)) {
					commentOpened = true;
				}
				
				line = removeAnnotations(removeComments(line));
				if (size(line) > 0)
					content += [<nr, line>];
			}
		}
		result[fname] = content;
		
		progCur += 1;
		progress(progTotal, progCur);
	}
	println("");
	
	return result;
}

str removeComments(str string) {
	items = [item | /<item:\/\/.*>/ := string];			// Single line comments
	items += [item | /<item:\/\*.*\*\/>/ := string];    // Block comments on a single line.
	for (item <- items) {
		string = replaceFirst(string, item, "");
	}
	
	items = [item | /<item:\/\*.*>/ := string];    	// Start of block comments spanning muliple lines
	items += [item | /<item:.*\*\/>/ := string];    // End of block comments spanning muliple lines
	for (item <- items) {
		string = replaceFirst(string, item, "");
	}
	
	return string;
}

str removeAnnotations(str string) {
	items = [item | /<item:^@[a-zA-Z]+>/ := string];
	
	for (item <- items)
		if (startsWith(string, item))
			string = replaceFirst(string, item, "");
	
	return string;
}

// Checks if the string contains ONLY the start of a block comment
bool containsBlockCommentOpen(str string) {
	return size([item | /<item:\/\*.*\*\/>/ := string]) == 0 && size([item | /<item:\/\*.*>/ := string]) == 1;
}

// Checks if the string contains ONLY the end of a block comment
bool containsBlockCommentClose(str string) {
	return size([item | /<item:\/\*.*\*\/>/ := string]) == 0 && size([item | /<item:.*\*\/>/ := string]) == 1;
}

MethodContent renameVariables(MethodContent methods) {
	
	MethodContent result = ();
	// For each method
	for (loc fname <- methods) {
		Content content = [];
		for (<loc nr, line> <- methods[fname]) {
			content += <nr, renameWordsInString(line)>;
		}
		result[fname] = content;
	}
	
	return result;
}

str renameWordsInString(str string) {
	list[str] words = [word | /<word:\w+>/ := string];
	
	for (word <- words) {
		if (!(word in reservedWords)) {
			string = replaceFirst(string, word, "X");
		}
	}
	
	return string;
}