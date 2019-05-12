module steps::detection::RequirementsReader

import IO;
import String;
import List;

import DataSet;

alias Requirement = rel[str name, list[str] words]; 

bool extra_filter = true;

// You can use this file 'as-is'. You do not have to read and parse the requirement files yourself.
// If you want more sofisticated methods of parsing the words and lines of the requirement files 
// you could implement the functions: 'applyHighlevelFiltering', 'applyLowlevelLineFiltering' and 'applyLowlevelWordFiltering'

Requirement readHighlevelRequirements(DataSet grp) {
	list[str] requirements = readRequirements(grp.dir, "high_level.txt");
    
	Requirement result = {};

  for (str req <- requirements, /^<id:F[0-9]+>/ := trim(req)) {
    list[str] reqWords = [];
    
    for (str line <- split("\n", trim(req))) {
      reqWords += [applyLowlevelWordFiltering(toLowerCase(word)) | str fLine := applyLowlevelLineFiltering(line), /<word:\S+>/ := fLine];
    }
    
    result += {<id, reqWords>}; 
  }
  
	return result;
}

Requirement readLowlevelRequirements(DataSet grp) {
  list[str] requirements = readRequirements(grp.dir, "low_level.txt");

  Requirement result = {};

  for (str req <- requirements, /^<id:UC[0-9]+>/ := trim(req)) {
    list[str] reqWords = [];
    
    for (str line <- split("\n", trim(req))) {
      reqWords += [applyLowlevelWordFiltering(toLowerCase(word)) | str fLine := applyLowlevelLineFiltering(line), /<word:\S+>/ := fLine];
    }
    
    result += {<id, reqWords>}; 
  }
  return result;
}

private str applyHighlevelFiltering(str orig) {
	if (extra_filter) {
	    orig = removeTokens(orig);
	}
	return orig;
}

private list[str] rem_lab = ["authors","number","id"];

private str applyLowlevelLineFiltering(str origLine) {
	if (extra_filter) {
	    for (int pos <- [0..size(origLine)-1]) {
	    	if (stringChar(charAt(origLine, pos)) == ":") {
	    		label = substring(origLine, 0, pos);
	    		rest = substring(origLine, pos+1, size(origLine));
	    		if (toLowerCase(label) in rem_lab) {
	    			origLine = "";	
	    		} else {
	    			origLine = rest;
	    		}
	    		break;
	    	}
	    }
	    origLine = removeTokens(origLine);
    }
	return origLine;
}

private list[str] rem_tok = [".", ",", "?", "!", ":", ";", "(", ")"];

private str removeTokens(str string) {
	for (tok <- rem_tok) {
		string = replaceAll(string, tok, "");
	}
	return string;
}

private str applyLowlevelWordFiltering(str origWord) {
	// TODO: This is the spot to implement some extra filtering if wanted while reading in the lowlevel requirements
	// This function gets called for EVERY word in the lowlevel requirements text
	return origWord;
}

private list[str] readRequirements(loc dir, str fileName) =
	split("~", readFile(dir + "/<fileName>"));
