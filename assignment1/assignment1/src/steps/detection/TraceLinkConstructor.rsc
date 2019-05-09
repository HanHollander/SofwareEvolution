module steps::detection::TraceLinkConstructor

import steps::detection::SimilarityCalculator;
import List;
import IO;

alias TraceLink = rel[str,str];
alias AllTraceLinks = list[TraceLink];

AllTraceLinks constructLinks(SimilarityMatrix sm) =
	[constructMethod1(sm), constructMethod2(sm), constructMethod3(sm)]; // You can add more constructed trace-links to the list if wanted

TraceLink constructMethod1(SimilarityMatrix sm) {
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return {}; 
}

TraceLink constructMethod2(SimilarityMatrix sm) {
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return {};
} 

TraceLink constructMethod3(SimilarityMatrix sm) {
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return {};
}
