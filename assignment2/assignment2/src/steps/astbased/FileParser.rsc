module steps::astbased::FileParser

import lang::java::m3::AST;
import IO;
import Set;
import List;
import Node;

map[loc,Declaration] parseFiles(loc dir) 
  = (file : createAstFromFile(file, false) | file <- dir.ls) when exists(dir), isDirectory(dir);

map[loc,Declaration] getAllMethods(loc dir) {
	p = parseFiles(dir);
	
	map[loc,Declaration] methods = ();
	for (fileLoc <- p) {
		methods += (m.src : removeAnnotations(m) | /m:method(_,_,_,_,impl) := p[fileLoc]);
		methods += (c.src : removeAnnotations(c) | /c:constructor(_,_,_,impl) := p[fileLoc]);
	}
	return methods;
}

void findPrivateMethods() {
  p = parseFiles(|project://assignment2/data/small|);
  
  for (decl <- p<1>, /m:method(_, str name, _, _, impl) := decl, \private() in m.modifiers, \static() in m.modifiers) {
    println("<name>: <impl.src>");
  }
}

bool couldSubTreeBeAClone(\m:method(_,_,_,_, Statement impl)) = (m.src.end.line - impl.src.begin.line) >= minCloneLineSize();
bool couldSubTreeBeAClone(\c:constructor(_,_,_, Statement impl)) = (c.src.end.line - impl.src.begin.line) >= minCloneLineSize();
default bool couldSubTreeBeAClone(Declaration d) = d.src.end.line - d.src.begin.line >= minCloneLineSize();

@memo
private int minCloneLineSize() = 10;

@doc {
  Remove the annotations from a declaration
}
Declaration removeAnnotations(Declaration decl) { 
  if (decl has modifiers, a:annotation(_) <- decl.modifiers) {
    decl.modifiers -= [a]; 
  }
  
  return decl;
}

@doc {
  Recursively reset all the attached src locations to their original values (|unknown:///|)
}
Declaration removeSourceLocations(Declaration decl) = unsetRec(decl, "src");