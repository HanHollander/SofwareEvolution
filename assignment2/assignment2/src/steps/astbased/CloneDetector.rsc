module steps::astbased::CloneDetector

import lang::java::m3::AST;
import DataTypes;
import IO;
import steps::astbased::FileParser;
import util::ProgressBar;
import util::Math;
import Map;
import List;


Clone detectTypeOneAndTypeTwoClones(map[loc,Declaration] methods) {
	real progTotal = toReal(size(methods));
	real progCur = 0.;
	progress(progTotal, progCur);
	
	Clone result = {};
	
	set[set[loc]] combinationsDone = {};
	
	for (loc floc1 <- methods) {
		Declaration method1 = methods[floc1];
		if (couldSubTreeBeAClone(method1)) {
			for (loc floc2 <- methods) {
				Declaration method2 = methods[floc2];
				if (couldSubTreeBeAClone(method2) && floc1 != floc2 && !({floc1,floc2} in combinationsDone)) {
					//try {
						CloneType cloneType = isClone(method1, method2);
						if (cloneType != type3()) {
							result += <floc1, floc2, cloneType, 100>;
							result += <floc2, floc1, cloneType, 100>;
						}
						combinationsDone += {{floc1,floc2}};
					//}
					//catch: combinationsDone += {{floc1,floc2}};
				}
			}
		}
		progCur += 1;
		progress(progTotal, progCur);
	}
	println("");
	return result;
}

CloneType prioritize(type1(), type1()) = type1();
CloneType prioritize(type2(), type2()) = type2();
CloneType prioritize(type1(), type2()) = type2();
CloneType prioritize(type2(), type1()) = type2();
CloneType prioritize(_, type3()) 	   = type3();
CloneType prioritize(type3(), _) 	   = type3();

// ===========
// Declaration
// ===========
CloneType isClone(	\method(Type retType1, str name1, list[Declaration] par1, list[Expression] exc1, Statement impl1),
					\method(Type retType2, str name2, list[Declaration] par2, list[Expression] exc2, Statement impl2)) {
	CloneType result = isClone(retType1, retType2);
	result = prioritize(result, name1 == name2 ? type1() : type2());
	if (size(par1) == size(par2)) {
		for (i <- [0..size(par1)]) {
			result = prioritize(result, isClone(par1[i], par2[i]));
		}
	} else {
		return type3();
	}
	if (size(exc1) == size(exc2)) {
		for (i <- [0..size(exc1)]) {
			result = prioritize(result, isClone(exc1[i], exc2[i]));
		}
	} else {
		return type3();
	}
	result = prioritize(result, isClone(impl1, impl2));
	return result;
}

CloneType isClone(	\constructor(str name1, list[Declaration] par1, list[Expression] exc1, Statement impl1),
					\constructor(str name2, list[Declaration] par2, list[Expression] exc2, Statement impl2)) {
	CloneType result = name1 == name2 ? type1() : type2();
	if (size(par1) == size(par2)) {
		for (i <- [0..size(par1)]) {
			result = prioritize(result, isClone(par1[i], par2[i]));
		}
	} else {
		return type3();
	}
	if (size(exc1) == size(exc2)) {
		for (i <- [0..size(exc1)]) {
			result = prioritize(result, isClone(exc1[i], exc2[i]));
		}
	} else {
		return type3();
	}
	result = prioritize(result, isClone(impl1, impl2));
	return result;
}

CloneType isClone(	\variables(Type type1, list[Expression] frags1),
					\variables(Type type2, list[Expression] frags2)) {
	CloneType result = isClone(type1, type2);
	if (size(frags1) == size(frags2)) {
		for (i <- [0..size(frags1)]) {
			result = prioritize(result, isClone(frags1[i], frags2[i]));
		}
	} else {
		return type3();
	}
	return result;
}

CloneType isClone(	\parameter(Type atype1, str name1, int dim1),
					\parameter(Type atype2, str name2, int dim2))
	= prioritize(prioritize(isClone(atype1, atype2), name1 == name2 ? type1() : type2()), dim1 == dim2 ? type1() : type2());
CloneType isClone(	\vararg(Type atype1, str name1, int dim1),
					\vararg(Type atype2, str name2, int dim2))
	= prioritize(isClone(atype1, atype2), name1 == name2 ? type1() : type2());
CloneType isClone(	\class(list[Declaration] body1), \class(list[Declaration] body2)) {
	CloneType result = type1();
	if (size(body1) == size(body2)) {
		for (i <- [0..size(body1)]) {
			result = prioritize(result, isClone(body1[i], body2[i]));
		}
	} else {
		return type3();
	}
	return result;
}

// ==========
// Expression
// ==========
CloneType isClone(\arrayAccess(Expression array1, Expression index1), \arrayAccess(Expression array2, Expression index2))
	= prioritize(isClone(array1, array2), isClone(index1, index2));
CloneType isClone(	\newArray(Type type1, list[Expression] dim1, Expression init1),
					\newArray(Type type2, list[Expression] dim2, Expression init2)) {
	CloneType result = isClone(type1, type2);
	if (size(dim1) == size(dim2)) {
		for (i <- [0..size(dim1)]) {
			result = prioritize(result, isClone(dim1[i], dim2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(init1, init2));
}
CloneType isClone(	\newArray(Type type1, list[Expression] dim1),
					\newArray(Type type2, list[Expression] dim2)) {
	CloneType result = isClone(type1, type2);
	if (size(dim1) == size(dim2)) {
		for (i <- [0..size(dim1)]) {
			result = prioritize(result, isClone(dim1[i], dim2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\arrayInitializer(list[Expression] elem1), \arrayInitializer(list[Expression] elem2)) {
	CloneType result = type1();
	if (size(elem1) == size(elem2)) {
		for (i <- [0..size(elem1)]) {
			result = prioritize(result, isClone(elem1[i], elem2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\assignment(Expression lhs1, str op1, Expression rhs1), \assignment(Expression lhs2, str op2, Expression rhs2)) {
	if (op1 != op2)
		return type3();
	return prioritize(isClone(lhs1, lhs2), isClone(rhs1, rhs2));
}
CloneType isClone(\cast(Type type1, Expression expr1), \cast(Type type2, Expression expr2))
	= prioritize(isClone(type1, type2), isClone(expr1, expr2));
CloneType isClone(\characterLiteral(str char1), \characterLiteral(str char2)) {
	if (char1 != char2)
		return type3();
	return type1();
}
CloneType isClone(	\newObject(Expression expr1, Type type1, list[Expression] args1, Declaration class1),
					\newObject(Expression expr2, Type type2, list[Expression] args2, Declaration class2)) {
	CloneType result = prioritize(isClone(expr1, expr2), isClone(type1, type2));
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(class1, class2));
}
CloneType isClone(	\newObject(Expression expr1, Type type1, list[Expression] args1),
					\newObject(Expression expr2, Type type2, list[Expression] args2)) {
	CloneType result = prioritize(isClone(expr1, expr2), isClone(type1, type2));
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(	\newObject(Type type1, list[Expression] args1, Declaration class1),
					\newObject(Type type2, list[Expression] args2, Declaration class2)) {
	CloneType result = isClone(type1, type2);
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(class1, class2));
}
CloneType isClone(	\newObject(Type type1, list[Expression] args1),
					\newObject(Type type2, list[Expression] args2)) {
	CloneType result = isClone(type1, type2);
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(	\qualifiedName(Expression qua1, Expression expr1),
					\qualifiedName(Expression qua2, Expression expr2))
	= prioritize(isClone(qua1, qua2), isClone(expr1, expr2));
CloneType isClone(	\conditional(Expression expr1, Expression then1, Expression else1),
					\conditional(Expression expr2, Expression then2, Expression else2))
	= prioritize(prioritize(isClone(expr1, expr2), isClone(then1, then2)), isClone(else1, else2));
CloneType isClone(	\fieldAccess(bool isSuper1, Expression expr1, str name1),
					\fieldAccess(bool isSuper2, Expression expr2, str name2)) {
	if (isSuper1 != isSuper2)
		return type3();
	return prioritize(isClone(expr1, expr2), name1 == name2 ? type1() : type2());
}
CloneType isClone(	\fieldAccess(bool isSuper1, str name1),
					\fieldAccess(bool isSuper2, str name2)) {
	if (isSuper1 != isSuper2)
		return type3();
	return name1 == name2 ? type1() : type2();
}
CloneType isClone(\instanceof(Expression left1, Type right1), \instanceof(Expression left2, Type right2))
	= prioritize(isClone(left1, left2), isClone(right1, right2));
CloneType isClone(	\methodCall(bool isSuper1, Expression rec1, str name1, list[Expression] args1),
					\methodCall(bool isSuper2, Expression rec2, str name2, list[Expression] args2)) {
	if (isSuper1 != isSuper2)
		return type3();
	CloneType result = isClone(rec1, rec2);
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, name1 == name2 ? type1() : type2());
}
CloneType isClone(	\methodCall(bool isSuper1, str name1, list[Expression] args1),
					\methodCall(bool isSuper2, str name2, list[Expression] args2)) {
	if (isSuper1 != isSuper2)
		return type3();
	CloneType result = name1 == name2 ? type1() : type2();
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\null(), \null()) = type1();
CloneType isClone(\number(str num1), \number(str num2)) {
	if (num1 != num2)
		return type3();
	return type1();
}
CloneType isClone(\booleanLiteral(bool boolVal1), \booleanLiteral(bool boolVal2)) {
	if (boolVal1 != boolVal2)
		return type3();
	return type1();
}
CloneType isClone(\stringLiteral(str string1), \stringLiteral(str string2)) {
	if (string1 != string2)
		return type3();
	return type1();
}
CloneType isClone(\type(Type type1), \type(Type type2)) = isClone(type1, type2);
CloneType isClone(\variable(str name1, int dim1), \variable(str name2, int dim2))
	= prioritize(name1 == name2 ? type1() : type2(), dim1 == dim2 ? type1() : type2());
CloneType isClone(\variable(str name1, int dim1, Expression init1), \variable(str name2, int dim2, Expression init2))
	= prioritize(prioritize(name1 == name2 ? type1() : type2(), dim1 == dim2 ? type1() : type2()), isClone(init1, init2));
CloneType isClone(\bracket(Expression expr1), \bracket(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\this(), \this()) = type1();
CloneType isClone(\this(Expression expr1), \this(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\super(), \super()) = type1();
CloneType isClone(\declarationExpression(Declaration decl1), \declarationExpression(Declaration decl2)) = isClone(decl1, decl2);
CloneType isClone(\infix(Expression lhs1, str op1, Expression rhs1), \infix(Expression lhs2, str op2, Expression rhs2)) {
	if (op1 != op2)
		return type3();
	return prioritize(isClone(lhs1, lhs2), isClone(rhs1, rhs2));
}
CloneType isClone(\postfix(Expression ope1, str opa1), \postfix(Expression ope2, str opa2)) {
	if (opa1 != opa2)
		return type3();
	return isClone(ope1, ope2);
}
CloneType isClone(\prefix(str operator1, Expression operand1), \prefix(str operator2, Expression operand2)) {
	if (operator1 != operator2)
		return type3();
	return isClone(operand1, operand2);
}
CloneType isClone(\simpleName(str name1), \simpleName(str name2)) = name1 == name2 ? type1() : type2();
CloneType isClone(\markerAnnotation(str name1), \markerAnnotation(str name2)) = name1 == name2 ? type1() : type2();
CloneType isClone(\normalAnnotation(str name1, list[Expression] pairs1), \normalAnnotation(str name2, list[Expression] pairs2)) {
	CloneType result = name1 == name2 ? type1() : type2();
	if (size(pairs1) == size(pairs2)) {
		for (i <- [0..size(pairs1)]) {
			result = prioritize(result, isClone(pairs1[i], pairs2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\memberValuePair(str name1, Expression val1), \memberValuePair(str name2, Expression val2))
	= prioritize(isClone(val1, val2), name1 == name2 ? type1() : type2());
CloneType isClone(\singleMemberAnnotation(str name1, Expression val1), \singleMemberAnnotation(str name2, Expression val2))
	= prioritize(isClone(val1, val2), name1 == name2 ? type1() : type2());


// =========
// Statement
// =========
CloneType isClone(\assert(Expression expr1), \assert(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\assert(Expression expr1, Expression mes1), \assert(Expression expr2, Expression mes2)) 
	= prioritize(isClone(expr1, expr2), isClone(mes1, mes2));
CloneType isClone(\block(list[Statement] stat1), \block(list[Statement] stat2)) {
	CloneType result = type1();
	if (size(stat1) == size(stat2)) {
		for (i <- [0..size(stat1)]) {
			result = prioritize(result, isClone(stat1[i], stat2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\break(), \break()) = type1();
CloneType isClone(\break(str label1), \break(str label2)) = label1 == label2 ? type1() : type2();
CloneType isClone(\continue(), \continue()) = type1();
CloneType isClone(\continue(str label1), \continue(str label2)) = label1 == label2 ? type1() : type2();
CloneType isClone(\do(Statement body1, Expression cond1), \do(Statement body2, Expression cond2)) 
	= prioritize(isClone(body1, body2), isClone(cond1, cond2));
CloneType isClone(	\foreach(Declaration par1, Expression col1, Statement body1), 
					\foreach(Declaration par2, Expression col2, Statement body2))
	= prioritize(prioritize(isClone(par1, par2), isClone(col1, col2)), isClone(body1, body2));
CloneType isClone(	\for(list[Expression] init1, Expression cond1, list[Expression] upd1, Statement body1),
					\for(list[Expression] init2, Expression cond2, list[Expression] upd2, Statement body2)) {
	CloneType result = isClone(cond1, cond2);
	if (size(init1) == size(init2)) {
		for (i <- [0..size(init1)]) {
			result = prioritize(result, isClone(init1[i], init2[i]));
		}
	} else {
		return type3();
	}
	if (size(upd1) == size(upd2)) {
		for (i <- [0..size(upd1)]) {
			result = prioritize(result, isClone(upd1[i], upd2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(body1, body2));
}
CloneType isClone(	\for(list[Expression] init1, list[Expression] upd1, Statement body1),
					\for(list[Expression] init2, list[Expression] upd2, Statement body2)) {
	CloneType result = type1();
	if (size(init1) == size(init2)) {
		for (i <- [0..size(init1)]) {
			result = prioritize(result, isClone(init1[i], init2[i]));
		}
	} else {
		return type3();
	}
	if (size(upd1) == size(upd2)) {
		for (i <- [0..size(upd1)]) {
			result = prioritize(result, isClone(upd1[i], upd2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(body1, body2));
}
CloneType isClone(\if(Expression cond1, Statement then1), \if(Expression cond2, Statement then2))
	= prioritize(isClone(cond1, cond2), isClone(then1, then2));
CloneType isClone(\if(Expression cond1, Statement then1, Statement else1), \if(Expression cond2, Statement then2, Statement else2))
	= prioritize(prioritize(isClone(cond1, cond2), isClone(then1, then2)), isClone(else1, else2));
CloneType isClone(\label(str name1, Statement body1), \label(str name2, Statement body2)) 
	= prioritize(name1 == name2 ? type1() : type2(), isClone(body1, body2));
CloneType isClone(\return(Expression expr1), \return(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\return(), \return()) = type1();
CloneType isClone(\switch(Expression expr1, list[Statement] stats1), \switch(Expression expr2, list[Statement] stats2)) {
	CloneType result = isClone(expr1, expr2);
	if (size(stats1) == size(stats2)) {
		for (i <- [0..size(stats1)]) {
			result = prioritize(result, isClone(stats1[i], stats2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(\case(Expression expr1), \case(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\defaultCase(), \defaultCase()) = type1();
CloneType isClone(\synchronizedStatement(Expression lock1, Statement body1), \synchronizedStatement(Expression lock2, Statement body2))
	= prioritize(isClone(lock1, lock2), isClone(body1, body2));
CloneType isClone(\throw(Expression expr1), \throw(Expression expr2)) = isClone(expr1, expr2);
CloneType isClone(\try(Statement body1, list[Statement] catch1), \try(Statement body2, list[Statement] catch2)) {
	CloneType result = isClone(body1, body2);
	if (size(catch1) == size(catch2)) {
		for (i <- [0..size(catch1)]) {
			result = prioritize(result, isClone(catch1[i], catch2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(	\try(Statement body1, list[Statement] catch1, Statement fin1),
					\try(Statement body2, list[Statement] catch2, Statement fin2)) {
	CloneType result = isClone(body1, body2);
	if (size(catch1) == size(catch2)) {
		for (i <- [0..size(catch1)]) {
			result = prioritize(result, isClone(catch1[i], catch2[i]));
		}
	} else {
		return type3();
	}
	return prioritize(result, isClone(fin1, fin2));
}
CloneType isClone(\catch(Declaration exc1, Statement body1), \catch(Declaration exc2, Statement body2)) 
	= prioritize(isClone(exc1, exc2), isClone(body1, body2));
CloneType isClone(\declarationStatement(Declaration decl1), \declarationStatement(Declaration decl2))
	= isClone(decl1, decl2);
CloneType isClone(\while(Expression cond1, Statement body1), \while(Expression cond2, Statement body2))
	= prioritize(isClone(cond1, cond2), isClone(body1, body2));
CloneType isClone(\expressionStatement(Expression stmt1), \expressionStatement(Expression stmt2))
	= isClone(stmt1, stmt2);
CloneType isClone(	\constructorCall(bool isSuper1, Expression expr1, list[Expression] args1),
					\constructorCall(bool isSuper2, Expression expr2, list[Expression] args2)) {
	CloneType result = prioritize(isSuper1 == isSuper2 ? type1() : type2(), isClone(expr1, expr2));
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(	\constructorCall(bool isSuper1, list[Expression] args1),
					\constructorCall(bool isSuper2, list[Expression] args2)) {
	CloneType result = isSuper1 == isSuper2 ? type1() : type2();
	if (size(args1) == size(args2)) {
		for (i <- [0..size(args1)]) {
			result = prioritize(result, isClone(args1[i], args2[i]));
		}
	} else {
		return type3();
	}
	return result;
}


// ====
// Type
// ====
CloneType isClone(arrayType(Type t1), arrayType(Type t2)) = isClone(t1, t2);
CloneType isClone(parameterizedType(Type t1), parameterizedType(Type t2)) = isClone(t1, t2);
CloneType isClone(qualifiedType(Type qua1, Expression name1), qualifiedType(Type qua2, Expression name2)) 
	= prioritize(isClone(qua1, qua2), isClone(name1, name2));
CloneType isClone(simpleType(Expression name1), simpleType(Expression name2)) = isClone(name1, name2);
CloneType isClone(unionType(list[Type] types1), unionType(list[Type] types2)) {
	CloneType result = type1();
	if (size(types1) == size(types2)) {
		for (i <- [0..size(types1)]) {
			result = prioritize(result, isClone(types1[i], types2[i]));
		}
	} else {
		return type3();
	}
	return result;
}
CloneType isClone(wildcard(), wildcard()) = type1();
CloneType isClone(upperbound(Type t1), upperbound(Type t2)) = isClone(t1, t2);
CloneType isClone(lowerbound(Type t1), lowerbound(Type t2)) = isClone(t1, t2);
CloneType isClone(\int(), \int()) = type1();
CloneType isClone(short(), short()) = type1();
CloneType isClone(long(), long()) = type1();
CloneType isClone(float(), float()) = type1();
CloneType isClone(double(), double()) = type1();
CloneType isClone(char(), char()) = type1();
CloneType isClone(string(), string()) = type1();
CloneType isClone(byte(), byte()) = type1();
CloneType isClone(\void(), \void()) = type1();
CloneType isClone(\boolean(), \boolean()) = type1();

// ========
// Modifier
// ========
CloneType isClone(\private(), \private()) = type1();
CloneType isClone(\public(), \public()) = type1();
CloneType isClone(\protected(), \protected()) = type1();
CloneType isClone(\static(), \static()) = type1();
CloneType isClone(\final(), \final()) = type1();
CloneType isClone(\synchronized(), \synchronized()) = type1();
CloneType isClone(\transient(), \transient()) = type1();
CloneType isClone(\abstract(), \abstract()) = type1();
CloneType isClone(\native(), \native()) = type1();
CloneType isClone(\volatile(), \volatile()) = type1();
CloneType isClone(\strictfp(), \strictfp()) = type1();
CloneType isClone(\onDemand(), \onDemand()) = type1();
CloneType isClone(\annotation(Expression a1), \annotation(Expression a2)) = isClone(a1,a2);

CloneType isClone(_,_) {
	return type3();
}




