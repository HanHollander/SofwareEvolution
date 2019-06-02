module steps::stringbased::CloneDetector

import steps::stringbased::FileReader;
import steps::stringbased::MatrixConstructor;
import DataTypes;
import util::ProgressBar;
import IO;
import String;
import List;
import Map;
import util::Math;

Clone extractTypeOneOrTwoClones(MethodContent methods, set[set[loc]] skips, CloneType cloneType) {
	real progTotal = toReal(size(methods));
	real progCur = 0.;
	progress(progTotal, progCur);
	
	Clone result = {};
	
	set[set[loc]] combinationsDone = {};
	
	for (loc floc1 <- methods) {
		Content method1 = methods[floc1];
		if (size(method1) > 9) {
			for (loc floc2 <- methods) {
				Content method2 = methods[floc2];
				if (size(method2) > 9 && floc1 != floc2 && size(method1) == size(method2) 
					&& !({floc1,floc2} in combinationsDone) && !({floc1,floc2} in skips)) {
					
					bool isCopy = true;
					for (i <- [0..size(method1)]) {
						if (method1[i][1] != method2[i][1]) {
							isCopy = false;
							break;
						}
					}
					
					if (isCopy) {
						result += <floc1, floc2, cloneType, 100>;
						result += <floc2, floc1, cloneType, 100>;
					}
					
					combinationsDone += {{floc1,floc2}};
				}
			}
		}
		progCur += 1;
		progress(progTotal, progCur);
	}
	println("");
	return result;
}

Clone extractTypeThreeClones(MethodContent methods, set[set[loc]] skips) {
	real progTotal = toReal(size(methods));
	real progCur = 0.;
	progress(progTotal, progCur);
	
	Clone result = {};
	
	set[set[loc]] combinationsDone = {};
	
	for (loc floc1 <- methods) {
		Content method1 = methods[floc1];
		if (size(method1) > 9) {
			for (loc floc2 <- methods) {
				Content method2 = methods[floc2];
				if (size(method2) > 9 && floc1 != floc2 && size(method1) == size(method2) 
					&& !({floc1,floc2} in combinationsDone) && !({floc1,floc2} in skips)) {
					
					int linesSimilar = getLinesSimilar(method1, method2, 0, 0, 0);
					int totalLines = max(size(method1), size(method2));
					int similarity = toInt(toReal(linesSimilar) / toReal(totalLines) * 100);
					if (linesSimilar > 9 && similarity >= 70) {
						result += <floc1, floc2, type3(), similarity>;
						result += <floc2, floc1, type3(), similarity>;
					}
					
					combinationsDone += {{floc1,floc2}};
				}
			}
		}
		progCur += 1;
		progress(progTotal, progCur);
		print(progCur);
	}
	println("");
	return result;
}

int getLinesSimilar(Content method1, Content method2, int i1, int i2, int sim) {
	if (i1 == size(method1) || i2 == size(method2))
		return sim;
	if (method1[i1][1] == method2[i2][1]) {
		return getLinesSimilar(method1, method2, i1 + 1, i2 + 1, sim + 1);
	} else {
		if (!isCloneStillPossible(method1, method2, i1, i2, sim)) {
			return 0;
		} else {
			return max(getLinesSimilar(method1, method2, i1, i2 + 1, sim), getLinesSimilar(method1, method2, i1 + 1, i2, sim));
		}
	}
}

bool isCloneStillPossible(Content method1, Content method2, int i1, int i2, int sim) {
	int sizeM1 = size(method1);
	int sizeM2 = size(method2);
	int possibleLines = min(sizeM1 - 1 - i1, sizeM2 - 1 - i2);
	return (sim + possibleLines > 9) && (toReal(sim + possibleLines) / toReal(max(sizeM1,sizeM2)) > 0.7);
}
