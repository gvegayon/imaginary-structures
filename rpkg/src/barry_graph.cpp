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
  ptr->print("This is a graph!\n");
  
  return 0;
  
}
