#include <Rcpp.h>
#include "barry/barry.hpp"
using namespace Rcpp;

// #include "geese-utils.h"

//' Creates a new network
//' @export
// [[Rcpp::export(rng = false)]]
SEXP new_barry_graph(
    int n,
    std::vector< uint > source,
    std::vector< uint > target
    ) {
  
  // Creating network of size six with five ties
  Rcpp::XPtr< netcounters::Network > dat(
      new netcounters::Network(n, n, source, target)
      );
  
  dat.attr("class") = "barry_graph";
  
  return dat;
  
}

//' @export
// [[Rcpp::export(name = "print.barry_graph", invisible = true, rng = false)]]
int print_barry_graph(SEXP x) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  ptr->print();
  
  return 0;
  
}

//' @export
// [[Rcpp::export(rng = false)]]
std::vector< double > count_recip_errors(
    SEXP x,
    int n,
    std::vector< uint > start
  ) {
  
  Rcpp::XPtr< netcounters::Network >ptr(x);
  netcounters::NetStatsCounter counter(ptr);
  
  netcounters::counter_css_partially_false_recip_omiss(
    counter.get_counters(), n, start
    );
  
  netcounters::counter_css_partially_false_recip_commi(
    counter.get_counters(), n, start
  );
  
  netcounters::counter_css_completely_false_recip_omiss(
    counter.get_counters(), n, start
  );
  
  netcounters::counter_css_completely_false_recip_comiss(
    counter.get_counters(), n, start
  );
  
  return counter.count_all();
  
}

