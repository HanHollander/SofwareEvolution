module steps::evaluation::ResultsWriter

import DataSet;
import steps::detection::TraceLinkConstructor;
import steps::evaluation::ResultsCalculator;

import IO;
import String;
import List;
import Set;
import util::Math;

// NOTHING TO DO HERE, YOU CAN USE THIS MODULE 'AS IS'

void writeResultFile(DataSet grp, str methodName, TraceLink foundLinks, EvaluationResult result) {
	str output = "RESULTS FOR \"<methodName>\"
	             '-------------------------------
	             'Confusion matrix:
	             '<confusionMatrixToStr(result.cm)>
	             '
	             'Precision: <precision(result.precision * 100, 2)>%
	             'Recall:    <precision(result.recall * 100, 2)>%
               'F-Measure: <precision(result.fMeasure, 2)>	             
	             '
	             'Found links by method:
	             '  <linksToStr(foundLinks)>";

  writeFile(grp.dir + "/result-<methodName>.txt", output);
}
	
private str linksToStr(TraceLink links) =
	"<for (str hl <- sortHighLevelCodes(links)) {>
	'<left(hl,8)><intercalate(",", sortLowLevelCodes([ll | <hl, str ll> <- links]))><}>
	'";
	
private str confusionMatrixToStr(ConfusionMatrix cm) =
	"                                       | Trace-links   | Trace-links 
	'                                       | identified    | NOT identified
	'                                       | manually      | manually
	'---------------------------------------------------------------------------------
	'Trace-links predicted by the tool      | <left("<cm.truePositives>",13)> | <cm.falsePositives>
	'Trace-links NOT predicted by the tool  | <left("<cm.falseNegatives>",13)> | <cm.trueNegatives>";
	
private list[str] sortHighLevelCodes(TraceLink links) 
	= sort(toList(links<0>), bool (/F<i:[0-9]+>/, /F<j:[0-9]+>/) { return toInt(i) < toInt(j); });

private list[str] sortLowLevelCodes(list[str] llc) 
  = sort(llc, bool (/UC<i:[0-9]+>/, /UC<j:[0-9]+>/) { return toInt(i) < toInt(j);});	