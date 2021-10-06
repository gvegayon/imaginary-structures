#include <Rcpp.h>
#include "barry/barry.hpp"
using namespace Rcpp;

// #include "geese-utils.h"

//' Creates a new network
//' @export
// [[Rcpp::export(rng = false, name = "new_barry_graph_cpp")]]
SEXP new_barry_graph(
    int n,
    std::vector< unsigned int > source,
    std::vector< unsigned int > target,
    int                         netsize,
    std::vector< unsigned int > endpoints
    ) {
  
  // Creating network of size six with five ties
  Rcpp::XPtr< netcounters::Network > dat(
      new netcounters::Network(n, n, source, target)
      );
  
  dat.attr("class")     = "barry_graph";
  dat.attr("netsize")   = netsize;
  dat.attr("endpoints") = Rcpp::wrap(endpoints);
  
  return dat;
  
}

//' @export
// [[Rcpp::export(name = "print.barry_graph", invisible = true, rng = false)]]
int print_barry_graph(SEXP x) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  
  std::vector< unsigned int > end = ptr.attr("endpoints");
  int                           n = ptr.attr("netsize");
  
  ptr->print("A barry_graph with %i networks of size %i\n.", end.size() + 1, n);
  
  return 0;
  
}

//' Add a counter for reciprocity errors
//' @param x An object of class [barry_graph].
//' @export
// [[Rcpp::export(rng = false)]]
DataFrame count_recip_errors(
    SEXP x
  ) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  netcounters::NetStatsCounter counter(ptr);
  
  std::vector< unsigned int > end = ptr.attr("endpoints");
  int                           n = ptr.attr("netsize");
  
  netcounters::counter_css_partially_false_recip_omiss(
    counter.get_counters(), n, end
    );
  
  netcounters::counter_css_partially_false_recip_commi(
    counter.get_counters(), n, end
  );
  
  netcounters::counter_css_completely_false_recip_omiss(
    counter.get_counters(), n, end
  );
  
  netcounters::counter_css_completely_false_recip_comiss(
    counter.get_counters(), n, end
  );
  
  netcounters::counter_css_mixed_recip(
    counter.get_counters(), n, end
  );
  
  IntegerVector id(end.size());
  for (int i = 0; i < static_cast<int>(id.size()); ++i)
    id[i] = i;
  
  // print(Rcpp::wrap(counter.get_names()));
  
  return DataFrame::create(
    _["id"]    = id,
    _["name"]  = wrap(counter.get_names()),
    _["value"] = counter.count_all()
  );
  
}

