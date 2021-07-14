
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

source_ <- c(source_, source_[-1] + 4)
target_ <- c(target_, target_[-1] + 4)

graph <- new_barry_graph(8, source_, target_)
graph
#> [  0,]     .  1.00     .  1.00     .     .     .     . 
#> [  1,]  1.00     .     .     .     .     .     .     . 
#> [  2,]     .     .     .  1.00     .     .     .     . 
#> [  3,]     .     .     .     .     .     .     .     . 
#> [  4,]     .     .     .     .     .     .     .  1.00 
#> [  5,]     .     .     .     .  1.00     .     .     . 
#> [  6,]     .     .     .     .     .     .     .  1.00 
#> [  7,]     .     .     .     .     .     .     .     .

count_recip_errors(graph, 4, 4)
#> [1] 1 0 1 0
```

``` r
krack_data <- read.csv("data-raw/advice_nets.csv")
n            <- 21
start_points <- cumsum(rep(21, 21))

graph <- new_barry_graph(n*22, krack_data[,1] - 1, krack_data[,2] - 1)
count_recip_errors(graph, 21, 42+21)
#> [1]  49   0 -56   0
```
