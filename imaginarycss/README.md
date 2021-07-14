
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

count_recip_errors(graph, 4, 8)
#>   id                                   name value
#> 1  0   Partially false recip (omission) (0)     1
#> 2  0  Partially false recip (comission) (0)     0
#> 3  0  Completely false recip (omission) (0)     0
#> 4  0 Completely false recip (comission) (0)     0
```

``` r
krack_data <- read.csv("data-raw/advice_nets.csv")
n          <- 21
end_points <- cumsum(rep(21, 22))[-1]

graph <- new_barry_graph(n*22, krack_data[,1] - 1, krack_data[,2] - 1)
ans   <- count_recip_errors(graph, 21, end_points)

ans$name <- gsub("[(][0-9]+[)]", "", ans$name)
ans
#>    id                                name value
#> 1   0   Partially false recip (omission)     14
#> 2   1   Partially false recip (omission)     14
#> 3   2   Partially false recip (omission)     16
#> 4   3   Partially false recip (omission)     26
#> 5   4   Partially false recip (omission)     15
#> 6   5   Partially false recip (omission)     16
#> 7   6   Partially false recip (omission)     28
#> 8   7   Partially false recip (omission)     20
#> 9   8   Partially false recip (omission)     23
#> 10  9   Partially false recip (omission)     18
#> 11 10   Partially false recip (omission)     20
#> 12 11   Partially false recip (omission)     18
#> 13 12   Partially false recip (omission)     22
#> 14 13   Partially false recip (omission)     13
#> 15 14   Partially false recip (omission)     19
#> 16 15   Partially false recip (omission)     23
#> 17 16   Partially false recip (omission)     15
#> 18 17   Partially false recip (omission)      5
#> 19 18   Partially false recip (omission)     17
#> 20 19   Partially false recip (omission)     17
#> 21 20   Partially false recip (omission)      0
#> 22  0  Partially false recip (comission)      0
#> 23  1  Partially false recip (comission)      0
#> 24  2  Partially false recip (comission)      0
#> 25  3  Partially false recip (comission)      0
#> 26  4  Partially false recip (comission)      0
#> 27  5  Partially false recip (comission)      0
#> 28  6  Partially false recip (comission)      0
#> 29  7  Partially false recip (comission)      0
#> 30  8  Partially false recip (comission)      0
#> 31  9  Partially false recip (comission)      0
#> 32 10  Partially false recip (comission)      0
#> 33 11  Partially false recip (comission)      0
#> 34 12  Partially false recip (comission)      0
#> 35 13  Partially false recip (comission)      0
#> 36 14  Partially false recip (comission)      0
#> 37 15  Partially false recip (comission)      0
#> 38 16  Partially false recip (comission)      0
#> 39 17  Partially false recip (comission)      0
#> 40 18  Partially false recip (comission)      0
#> 41 19  Partially false recip (comission)      0
#> 42 20  Partially false recip (comission)      0
#> 43  0  Completely false recip (omission)      1
#> 44  1  Completely false recip (omission)     32
#> 45  2  Completely false recip (omission)     13
#> 46  3  Completely false recip (omission)     10
#> 47  4  Completely false recip (omission)      9
#> 48  5  Completely false recip (omission)     15
#> 49  6  Completely false recip (omission)     13
#> 50  7  Completely false recip (omission)     23
#> 51  8  Completely false recip (omission)     13
#> 52  9  Completely false recip (omission)     29
#> 53 10  Completely false recip (omission)     14
#> 54 11  Completely false recip (omission)     19
#> 55 12  Completely false recip (omission)     26
#> 56 13  Completely false recip (omission)     32
#> 57 14  Completely false recip (omission)     11
#> 58 15  Completely false recip (omission)     12
#> 59 16  Completely false recip (omission)     29
#> 60 17  Completely false recip (omission)      9
#> 61 18  Completely false recip (omission)      9
#> 62 19  Completely false recip (omission)      4
#> 63 20  Completely false recip (omission)      0
#> 64  0 Completely false recip (comission)     11
#> 65  1 Completely false recip (comission)      0
#> 66  2 Completely false recip (comission)      1
#> 67  3 Completely false recip (comission)      1
#> 68  4 Completely false recip (comission)      3
#> 69  5 Completely false recip (comission)      4
#> 70  6 Completely false recip (comission)      1
#> 71  7 Completely false recip (comission)      0
#> 72  8 Completely false recip (comission)      0
#> 73  9 Completely false recip (comission)      0
#> 74 10 Completely false recip (comission)      1
#> 75 11 Completely false recip (comission)      3
#> 76 12 Completely false recip (comission)      0
#> 77 13 Completely false recip (comission)      0
#> 78 14 Completely false recip (comission)      1
#> 79 15 Completely false recip (comission)      0
#> 80 16 Completely false recip (comission)      2
#> 81 17 Completely false recip (comission)      5
#> 82 18 Completely false recip (comission)      4
#> 83 19 Completely false recip (comission)      6
#> 84 20 Completely false recip (comission)      0
```
