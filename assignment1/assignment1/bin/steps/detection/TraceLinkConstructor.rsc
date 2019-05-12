module steps::detection::TraceLinkConstructor

import steps::detection::SimilarityCalculator;
import List;
import IO;

alias TraceLink = rel[str,str];
alias AllTraceLinks = list[TraceLink];

AllTraceLinks constructLinks(SimilarityMatrix sm) =
	[constructMethod1(sm), constructMethod2(sm), constructMethod3(sm), constructMethod4(sm)]; // You can add more constructed trace-links to the list if wanted

TraceLink constructMethod1(SimilarityMatrix sm) {
  return {<high, low> | <high, low, score> <- sm, score > 0};
}

TraceLink constructMethod2(SimilarityMatrix sm) {
  return {<high, low> | <high, low, score> <- sm, score >= 0.25};
} 

TraceLink constructMethod3(SimilarityMatrix sm) {
  return {<high, low> | <high, low, score> <- sm, score >= 0.67*max_l(high, sm)};
}

TraceLink constructMethod4(SimilarityMatrix sm) {
  return {<high, low> | <high, low, score> <- sm, score == max_l(high, sm), score > 0.1};
}

real max_l(str high, SimilarityMatrix sm) {
    return max([score | <high_sm, low, score> <- sm, high_sm == high]);
}