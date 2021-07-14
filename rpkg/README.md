
<!-- README.md is generated from README.Rmd. Please edit that file -->

# imaginarycss

<!-- badges: start -->
<!-- badges: end -->

The goal of imaginarycss is to …

## Installation

You can install the released version of imaginarycss from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("imaginarycss")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("gvegayon/imaginary-structures")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(imaginarycss)

source_ <- c(1, 2, 3, 1) - 1
target_ <- c(2, 1, 4, 4) - 1

graph <- new_barry_graph(4, source_, target_)
graph
#> [  0,]     .  1.00     .  1.00 
#> [  1,]  1.00     .     .     . 
#> [  2,]     .     .     .  1.00 
#> [  3,]     .     .     .     .
```
