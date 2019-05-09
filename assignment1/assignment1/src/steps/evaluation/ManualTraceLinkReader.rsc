module steps::evaluation::ManualTraceLinkReader

import DataSet;
import steps::detection::TraceLinkConstructor;

import String;
import IO;

// YOU DO NOT NEED TO DO ANYTHING IN THIS MODULE; JUST USE 'AS IS'

TraceLink readManualTraceLinks(DataSet grp) {
	list[str] answers = split("\n",readFile(grp.dir + "/answers.txt"));
	
	TraceLink result = {};	
	for (str line <- answers, /^<highlevel:F[0-9]+>\s<links:.*>$/ := trim(line), /<lowlevel:UC[0-9]+>/ := links) {
		result += {<highlevel,lowlevel>};
	}
	
	return result;
}