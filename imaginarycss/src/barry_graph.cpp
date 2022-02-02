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

#define APPEND_COUNTER(a) netcounters:: a <netcounters::Network>(\
  counter.get_counters(), n, end );

//' Add a counter for reciprocity errors
//' @param x An object of class [barry_graph].
//' @export
// [[Rcpp::export(rng = false)]]
DataFrame count_recip_errors(
    SEXP x
  ) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  netcounters::NetStatsCounter< netcounters::Network> counter(ptr);
  
  std::vector< unsigned int > end = ptr.attr("endpoints");
  int                           n = ptr.attr("netsize");
  
  APPEND_COUNTER(counter_css_partially_false_recip_omiss)
  APPEND_COUNTER(counter_css_partially_false_recip_commi)
  APPEND_COUNTER(counter_css_completely_false_recip_omiss)
  APPEND_COUNTER(counter_css_completely_false_recip_comiss)
  APPEND_COUNTER(counter_css_mixed_recip)
    
  APPEND_COUNTER(counter_css_census01)
  APPEND_COUNTER(counter_css_census02)
  APPEND_COUNTER(counter_css_census03)
  APPEND_COUNTER(counter_css_census04)
  APPEND_COUNTER(counter_css_census05)
  APPEND_COUNTER(counter_css_census06)
  APPEND_COUNTER(counter_css_census07)
  APPEND_COUNTER(counter_css_census08)
  APPEND_COUNTER(counter_css_census09)
  APPEND_COUNTER(counter_css_census10)
  
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

//' Computes census of imaginary errors
//' @param x An object of class [barry_graph].
//' @details
//' There are ten (10) values:
//' - (01) Accurate null
//' - (02) Partial false positive (null)
//' - (03) Complete false positive (null)
//' - (04) Partial false negative (assym)
//' - (05) Accurate assym
//' - (06) Mixed assym
//' - (07) Partial false positive (assym)
//' - (08) Complete false negative (full)
//' - (09) Partial false negative (full)
//' - (10) Accurate full
//' @export
// [[Rcpp::export(rng = false)]]
DataFrame count_imaginary_census(
    SEXP x
) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  netcounters::NetStatsCounter< netcounters::Network> counter(ptr);
  
  std::vector< unsigned int > end = ptr.attr("endpoints");
  int                           n = ptr.attr("netsize");
  
  APPEND_COUNTER(counter_css_census01)
  APPEND_COUNTER(counter_css_census02)
  APPEND_COUNTER(counter_css_census03)
  APPEND_COUNTER(counter_css_census04)
  APPEND_COUNTER(counter_css_census05)
  APPEND_COUNTER(counter_css_census06)
  APPEND_COUNTER(counter_css_census07)
  APPEND_COUNTER(counter_css_census08)
  APPEND_COUNTER(counter_css_census09)
  APPEND_COUNTER(counter_css_census10)
    
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

#undef APPEND_COUNTER

