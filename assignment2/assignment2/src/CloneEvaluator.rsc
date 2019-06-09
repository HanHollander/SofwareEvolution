module CloneEvaluator

import DataTypes;
import Set;
import IO;
import String;
import util::Math;

alias EClone = set[set[loc]];
alias MatMetrics = tuple[real p, real r, real f];
alias ConfMatrix = tuple[int tp,int fp,int tn,int fn];

void evaluate(Clone expectedClones, Clone actualClones, set[loc] allMethods) {
	EClone expTOneClones   = {{loc1,loc2} | <loc1,loc2,type1(),sim> <- expectedClones};
	EClone expTTwoClones   = {{loc1,loc2} | <loc1,loc2,type2(),sim> <- expectedClones};
	EClone expTThreeClones = {{loc1,loc2} | <loc1,loc2,type3(),sim> <- expectedClones};
	
	EClone actTOneClones   = {{loc1,loc2} | <loc1,loc2,type1(),sim> <- actualClones};
	EClone actTTwoClones   = {{loc1,loc2} | <loc1,loc2,type2(),sim> <- actualClones};
	EClone actTThreeClones = {{loc1,loc2} | <loc1,loc2,type3(),sim> <- actualClones};
	
	set[set[loc]] allCombs = {{loc1,loc2} | loc1 <- allMethods, loc2 <- allMethods, loc1 != loc2};
	println("\n\n- TYPE 1 Conf Matrix");
	ConfMatrix cm1 = calculateConfMatrix(expTOneClones, actTOneClones, allCombs);
	printConfMatrix(cm1);
	MatMetrics mm1 = printScore(cm1);
	
	println("\n\n- TYPE 2 Conf Matrix");
	ConfMatrix cm2 = calculateConfMatrix(expTTwoClones, actTTwoClones, allCombs);
	printConfMatrix(cm2);
	MatMetrics mm2 = printScore(cm2);
	
	println("\n\n- TYPE 3 Conf Matrix");
	ConfMatrix cm3 = calculateConfMatrix(expTThreeClones, actTThreeClones, allCombs);
	printConfMatrix(cm3);
	MatMetrics mm3 = printScore(cm3);
	
	println("\n\n");
	printBigConfMatrix(expTOneClones, expTTwoClones, expTThreeClones,
					actTOneClones, actTTwoClones, actTThreeClones, allCombs);
	printAverages(mm1, mm2, mm3);
	
}


ConfMatrix calculateConfMatrix(EClone expected, EClone actual, set[set[loc]] allCombs) {
	set[set[loc]] exp = expected;
	set[set[loc]] act = actual;
	int tp = size(exp & act);
	int fp = size(act - exp);
	int tn = size(allCombs - exp - act);
	int fn = size(exp - act);

	ConfMatrix result = <tp,fp,tn,fn>;
	return result;
}

void printConfMatrix(ConfMatrix cm) {
	println(
	"                                  | Clones found  | Clones NOT 
	'                                  | by NiCad5     | predicted by NiCad5
	'---------------------------------------------------------------------------------
	'Clones predicted by the tool      | <left("<cm.tp>",13)> | <cm.fp>
	'Clones NOT predicted by the tool  | <left("<cm.fn>",13)> | <cm.tn>");
}

MatMetrics printScore(ConfMatrix cm) {
	real sub = toReal(cm.tp) + toReal(cm.fp);
	real p = (sub == 0 ? 0. : toReal(cm.tp) / sub);
	real r = toReal(cm.tp) / (toReal(cm.tp) + toReal(cm.fn));
	println("Precision: <p>");
	println("Recall: <r>");
	real f = 0.;
	if (r == 0 && p == 0) {
		println("F-measure: 0");
	} else {
		f = 2 * ((p*r)/(p+r));
		println("F-measure: <f>");
	}
	return <p, r, f>;
}

void printBigConfMatrix(EClone expTOneClones, EClone expTTwoClones, EClone expTThreeClones,
					EClone actTOneClones, EClone actTTwoClones, EClone actTThreeClones, set[set[loc]] allCombs) {
	EClone expNot = allCombs - expTOneClones - expTTwoClones - expTThreeClones;
	EClone actNot = allCombs - actTOneClones - actTTwoClones - actTThreeClones;
	println(
	"                |         Own method predictions     
	'                |   Type 1   |   Type 2   |   Type 3   |   Not
	'---------------------------------------------------------------------
	'       | Type 1 | <center("<size(expTOneClones & actTOneClones)>", 10)> | <center("<size(expTOneClones & actTTwoClones)>", 10)> | <center("<size(expTOneClones & actTThreeClones)>", 10)> | <center("<size(expTOneClones & actNot)>", 10)>
	'NiCad5 | Type 2 | <center("<size(expTTwoClones & actTOneClones)>", 10)> | <center("<size(expTTwoClones & actTTwoClones)>", 10)> | <center("<size(expTTwoClones & actTThreeClones)>", 10)> | <center("<size(expTTwoClones & actNot)>", 10)>
	'       | Type 3 | <center("<size(expTThreeClones & actTOneClones)>", 10)> | <center("<size(expTThreeClones & actTTwoClones)>", 10)> | <center("<size(expTThreeClones & actTThreeClones)>", 10)> | <center("<size(expTThreeClones & actNot)>", 10)>
	'       | Not    | <center("<size(expNot & actTOneClones)>", 10)> | <center("<size(expNot & actTTwoClones)>", 10)> | <center("<size(expNot & actTThreeClones)>", 10)> |
	'
	"
	);
}

void printAverages(MatMetrics t1, MatMetrics t2, MatMetrics t3) {
	println("Overall precision: <(t1.p + t2.p + t3.p)/ 3>");
	println("Overall recall: <(t1.r + t2.r + t3.r)/ 3>");
	println("Overall recall: <(t1.f + t2.f + t3.f)/ 3>");
}


