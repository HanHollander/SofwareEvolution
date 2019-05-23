module steps::stringbased::LineTransformer

import steps::stringbased::FileReader;
import IO;
import String;
import List;

MethodContent removeWhitespaceAndComments(MethodContent methods) {
	
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
					
					line = removeComments(line);
					if (size(line) > 0)
						content += [<nr, line>];
				}
			} else {
				if (containsBlockCommentOpen(line)) {
					commentOpened = true;
				}
				
				line = removeComments(line);
				if (size(line) > 0)
					content += [<nr, line>];
			}
		}
		result += (fname: content);
	}
	return result;
}

str removeComments(str string) {
	items = [item | /<item:\/\/.*>/ := string];			// Single line comments
	items += [item | /<item:\/\*.*\*\/>/ := string];    // Block comments on a single line.
	for (item <- items) {
		string = replaceAll(string, item, "");
	}
	
	items = [item | /<item:\/\*.*>/ := string];    	// Start of block comments spanning muliple lines
	items += [item | /<item:.*\*\/>/ := string];    // End of block comments spanning muliple lines
	for (item <- items) {
		string = replaceAll(string, item, "");
	}
	
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