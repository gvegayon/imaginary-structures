
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

source_ <- c(1, 2, 3, 1) 
target_ <- c(2, 1, 4, 4)

source_ <- c(source_, source_[-1] + 4)
target_ <- c(target_, target_[-1] + 4)

adjmat <- matrix(0L, nrow = 8, ncol = 8)
adjmat[cbind(source_, target_)] <- 1L

graph <- new_barry_graph(adjmat, n = 4)
graph
#> A barry_graph with 140730137431888 networks of size 10
#> .    .  1.00     .  1.00     .     .     .     . 
#>  1.00     .     .     .     .     .     .     . 
#>     .     .     .  1.00     .     .     .     . 
#>     .     .     .     .     .     .     .     . 
#>     .     .     .     .     .     .     .  1.00 
#>     .     .     .     .  1.00     .     .     . 
#>     .     .     .     .     .     .     .  1.00 
#>     .     .     .     .     .     .     .     .

# These are two attributes that are part of the barry_graph object
attr(graph, "endpoints")
#> [1] 8
attr(graph, "netsize")
#> [1] 4

count_recip_errors(graph)
#>    id                                    name value
#> 1   0    Partially false recip (omission) (0)     1
#> 2   0   Partially false recip (comission) (0)     0
#> 3   0   Completely false recip (omission) (0)     0
#> 4   0  Completely false recip (comission) (0)     0
#> 5   0            Mixed reciprocity errors (0)     0
#> 6   0                  (01) Accurate null (0)     3
#> 7   0  (02) Partial false positive (null) (0)     0
#> 8   0 (03) Complete false positive (null) (0)     0
#> 9   0 (04) Partial false negative (assym) (0)     0
#> 10  0                 (05) Accurate assym (0)     2
#> 11  0                    (06) Mixed assym (0)     0
#> 12  0 (07) Partial false positive (assym) (0)     0
#> 13  0 (08) Complete false negative (full) (0)     0
#> 14  0  (09) Partial false negative (full) (0)     1
#> 15  0                  (10) Accurate full (0)     0
```

``` r
krack_data <- read.csv("data-raw/advice_nets.csv")
krack_data <- as.matrix(krack_data)
n          <- 21

krack_adjmat <- matrix(0L, nrow = n*22, ncol = n*22)
krack_adjmat[krack_data] <- 1L

graph <- new_barry_graph(
  krack_adjmat,
  n = n
  )

ans <- count_recip_errors(graph)
ans
#>     id                                     name value
#> 1    0     Partially false recip (omission) (0)    25
#> 2    1     Partially false recip (omission) (1)    78
#> 3    2     Partially false recip (omission) (2)    52
#> 4    3     Partially false recip (omission) (3)    63
#> 5    4     Partially false recip (omission) (4)    56
#> 6    5     Partially false recip (omission) (5)    56
#> 7    6     Partially false recip (omission) (6)    72
#> 8    7     Partially false recip (omission) (7)    77
#> 9    8     Partially false recip (omission) (8)    60
#> 10   9     Partially false recip (omission) (9)    86
#> 11  10    Partially false recip (omission) (10)    53
#> 12  11    Partially false recip (omission) (11)    79
#> 13  12    Partially false recip (omission) (12)    90
#> 14  13    Partially false recip (omission) (13)    86
#> 15  14    Partially false recip (omission) (14)    58
#> 16  15    Partially false recip (omission) (15)    72
#> 17  16    Partially false recip (omission) (16)    68
#> 18  17    Partially false recip (omission) (17)    36
#> 19  18    Partially false recip (omission) (18)    43
#> 20  19    Partially false recip (omission) (19)    47
#> 21  20    Partially false recip (omission) (20)     0
#> 22   0    Partially false recip (comission) (0)    92
#> 23   1    Partially false recip (comission) (1)     4
#> 24   2    Partially false recip (comission) (2)    43
#> 25   3    Partially false recip (comission) (3)    25
#> 26   4    Partially false recip (comission) (4)    32
#> 27   5    Partially false recip (comission) (5)    38
#> 28   6    Partially false recip (comission) (6)    16
#> 29   7    Partially false recip (comission) (7)    10
#> 30   8    Partially false recip (comission) (8)    27
#> 31   9    Partially false recip (comission) (9)     3
#> 32  10   Partially false recip (comission) (10)    27
#> 33  11   Partially false recip (comission) (11)    22
#> 34  12   Partially false recip (comission) (12)     1
#> 35  13   Partially false recip (comission) (13)     3
#> 36  14   Partially false recip (comission) (14)    32
#> 37  15   Partially false recip (comission) (15)    11
#> 38  16   Partially false recip (comission) (16)    18
#> 39  17   Partially false recip (comission) (17)    45
#> 40  18   Partially false recip (comission) (18)    61
#> 41  19   Partially false recip (comission) (19)    52
#> 42  20   Partially false recip (comission) (20)     0
#> 43   0    Completely false recip (omission) (0)     1
#> 44   1    Completely false recip (omission) (1)    32
#> 45   2    Completely false recip (omission) (2)    13
#> 46   3    Completely false recip (omission) (3)    10
#> 47   4    Completely false recip (omission) (4)     9
#> 48   5    Completely false recip (omission) (5)    15
#> 49   6    Completely false recip (omission) (6)    13
#> 50   7    Completely false recip (omission) (7)    23
#> 51   8    Completely false recip (omission) (8)    13
#> 52   9    Completely false recip (omission) (9)    29
#> 53  10   Completely false recip (omission) (10)    14
#> 54  11   Completely false recip (omission) (11)    19
#> 55  12   Completely false recip (omission) (12)    26
#> 56  13   Completely false recip (omission) (13)    32
#> 57  14   Completely false recip (omission) (14)    11
#> 58  15   Completely false recip (omission) (15)    12
#> 59  16   Completely false recip (omission) (16)    29
#> 60  17   Completely false recip (omission) (17)     9
#> 61  18   Completely false recip (omission) (18)     9
#> 62  19   Completely false recip (omission) (19)     4
#> 63  20   Completely false recip (omission) (20)     0
#> 64   0   Completely false recip (comission) (0)    11
#> 65   1   Completely false recip (comission) (1)     0
#> 66   2   Completely false recip (comission) (2)     1
#> 67   3   Completely false recip (comission) (3)     1
#> 68   4   Completely false recip (comission) (4)     3
#> 69   5   Completely false recip (comission) (5)     4
#> 70   6   Completely false recip (comission) (6)     1
#> 71   7   Completely false recip (comission) (7)     0
#> 72   8   Completely false recip (comission) (8)     0
#> 73   9   Completely false recip (comission) (9)     0
#> 74  10  Completely false recip (comission) (10)     1
#> 75  11  Completely false recip (comission) (11)     3
#> 76  12  Completely false recip (comission) (12)     0
#> 77  13  Completely false recip (comission) (13)     0
#> 78  14  Completely false recip (comission) (14)     1
#> 79  15  Completely false recip (comission) (15)     0
#> 80  16  Completely false recip (comission) (16)     2
#> 81  17  Completely false recip (comission) (17)     5
#> 82  18  Completely false recip (comission) (18)     4
#> 83  19  Completely false recip (comission) (19)     6
#> 84  20  Completely false recip (comission) (20)     0
#> 85   0             Mixed reciprocity errors (0)    41
#> 86   1             Mixed reciprocity errors (1)     4
#> 87   2             Mixed reciprocity errors (2)    23
#> 88   3             Mixed reciprocity errors (3)    10
#> 89   4             Mixed reciprocity errors (4)    18
#> 90   5             Mixed reciprocity errors (5)    17
#> 91   6             Mixed reciprocity errors (6)     9
#> 92   7             Mixed reciprocity errors (7)    10
#> 93   8             Mixed reciprocity errors (8)    23
#> 94   9             Mixed reciprocity errors (9)     1
#> 95  10            Mixed reciprocity errors (10)     7
#> 96  11            Mixed reciprocity errors (11)    10
#> 97  12            Mixed reciprocity errors (12)     3
#> 98  13            Mixed reciprocity errors (13)     3
#> 99  14            Mixed reciprocity errors (14)    23
#> 100 15            Mixed reciprocity errors (15)     8
#> 101 16            Mixed reciprocity errors (16)    12
#> 102 17            Mixed reciprocity errors (17)    21
#> 103 18            Mixed reciprocity errors (18)    24
#> 104 19            Mixed reciprocity errors (19)    26
#> 105 20            Mixed reciprocity errors (20)     0
#> 106  0                   (01) Accurate null (0)    22
#> 107  1                   (01) Accurate null (1)    66
#> 108  2                   (01) Accurate null (2)    48
#> 109  3                   (01) Accurate null (3)    58
#> 110  4                   (01) Accurate null (4)    57
#> 111  5                   (01) Accurate null (5)    58
#> 112  6                   (01) Accurate null (6)    58
#> 113  7                   (01) Accurate null (7)    64
#> 114  8                   (01) Accurate null (8)    56
#> 115  9                   (01) Accurate null (9)    67
#> 116 10                  (01) Accurate null (10)    51
#> 117 11                  (01) Accurate null (11)    58
#> 118 12                  (01) Accurate null (12)    69
#> 119 13                  (01) Accurate null (13)    67
#> 120 14                  (01) Accurate null (14)    64
#> 121 15                  (01) Accurate null (15)    67
#> 122 16                  (01) Accurate null (16)    64
#> 123 17                  (01) Accurate null (17)    56
#> 124 18                  (01) Accurate null (18)    38
#> 125 19                  (01) Accurate null (19)    48
#> 126 20                  (01) Accurate null (20)    69
#> 127  0   (02) Partial false positive (null) (0)    36
#> 128  1   (02) Partial false positive (null) (1)     3
#> 129  2   (02) Partial false positive (null) (2)    20
#> 130  3   (02) Partial false positive (null) (3)    10
#> 131  4   (02) Partial false positive (null) (4)     9
#> 132  5   (02) Partial false positive (null) (5)     7
#> 133  6   (02) Partial false positive (null) (6)    10
#> 134  7   (02) Partial false positive (null) (7)     5
#> 135  8   (02) Partial false positive (null) (8)    13
#> 136  9   (02) Partial false positive (null) (9)     2
#> 137 10  (02) Partial false positive (null) (10)    17
#> 138 11  (02) Partial false positive (null) (11)     8
#> 139 12  (02) Partial false positive (null) (12)     0
#> 140 13  (02) Partial false positive (null) (13)     2
#> 141 14  (02) Partial false positive (null) (14)     4
#> 142 15  (02) Partial false positive (null) (15)     2
#> 143 16  (02) Partial false positive (null) (16)     3
#> 144 17  (02) Partial false positive (null) (17)     8
#> 145 18  (02) Partial false positive (null) (18)    27
#> 146 19  (02) Partial false positive (null) (19)    15
#> 147 20  (02) Partial false positive (null) (20)     0
#> 148  0  (03) Complete false positive (null) (0)    11
#> 149  1  (03) Complete false positive (null) (1)     0
#> 150  2  (03) Complete false positive (null) (2)     1
#> 151  3  (03) Complete false positive (null) (3)     1
#> 152  4  (03) Complete false positive (null) (4)     3
#> 153  5  (03) Complete false positive (null) (5)     4
#> 154  6  (03) Complete false positive (null) (6)     1
#> 155  7  (03) Complete false positive (null) (7)     0
#> 156  8  (03) Complete false positive (null) (8)     0
#> 157  9  (03) Complete false positive (null) (9)     0
#> 158 10 (03) Complete false positive (null) (10)     1
#> 159 11 (03) Complete false positive (null) (11)     3
#> 160 12 (03) Complete false positive (null) (12)     0
#> 161 13 (03) Complete false positive (null) (13)     0
#> 162 14 (03) Complete false positive (null) (14)     1
#> 163 15 (03) Complete false positive (null) (15)     0
#> 164 16 (03) Complete false positive (null) (16)     2
#> 165 17 (03) Complete false positive (null) (17)     5
#> 166 18 (03) Complete false positive (null) (18)     4
#> 167 19 (03) Complete false positive (null) (19)     6
#> 168 20 (03) Complete false positive (null) (20)     0
#> 169  0  (04) Partial false negative (assym) (0)    11
#> 170  1  (04) Partial false negative (assym) (1)    64
#> 171  2  (04) Partial false negative (assym) (2)    36
#> 172  3  (04) Partial false negative (assym) (3)    37
#> 173  4  (04) Partial false negative (assym) (4)    41
#> 174  5  (04) Partial false negative (assym) (5)    40
#> 175  6  (04) Partial false negative (assym) (6)    44
#> 176  7  (04) Partial false negative (assym) (7)    57
#> 177  8  (04) Partial false negative (assym) (8)    37
#> 178  9  (04) Partial false negative (assym) (9)    68
#> 179 10 (04) Partial false negative (assym) (10)    33
#> 180 11 (04) Partial false negative (assym) (11)    61
#> 181 12 (04) Partial false negative (assym) (12)    68
#> 182 13 (04) Partial false negative (assym) (13)    73
#> 183 14 (04) Partial false negative (assym) (14)    39
#> 184 15 (04) Partial false negative (assym) (15)    49
#> 185 16 (04) Partial false negative (assym) (16)    53
#> 186 17 (04) Partial false negative (assym) (17)    31
#> 187 18 (04) Partial false negative (assym) (18)    26
#> 188 19 (04) Partial false negative (assym) (19)    30
#> 189 20 (04) Partial false negative (assym) (20)     0
#> 190  0                  (05) Accurate assym (0)    13
#> 191  1                  (05) Accurate assym (1)    23
#> 192  2                  (05) Accurate assym (2)    19
#> 193  3                  (05) Accurate assym (3)    34
#> 194  4                  (05) Accurate assym (4)    21
#> 195  5                  (05) Accurate assym (5)    15
#> 196  6                  (05) Accurate assym (6)    35
#> 197  7                  (05) Accurate assym (7)    23
#> 198  8                  (05) Accurate assym (8)    29
#> 199  9                  (05) Accurate assym (9)    22
#> 200 10                 (05) Accurate assym (10)    44
#> 201 11                 (05) Accurate assym (11)    13
#> 202 12                 (05) Accurate assym (12)    20
#> 203 13                 (05) Accurate assym (13)    15
#> 204 14                 (05) Accurate assym (14)    13
#> 205 15                 (05) Accurate assym (15)    28
#> 206 16                 (05) Accurate assym (16)    18
#> 207 17                 (05) Accurate assym (17)    18
#> 208 18                 (05) Accurate assym (18)    25
#> 209 19                 (05) Accurate assym (19)    17
#> 210 20                 (05) Accurate assym (20)    92
#> 211  0                     (06) Mixed assym (0)    12
#> 212  1                     (06) Mixed assym (1)     4
#> 213  2                     (06) Mixed assym (2)    14
#> 214  3                     (06) Mixed assym (3)     6
#> 215  4                     (06) Mixed assym (4)     7
#> 216  5                     (06) Mixed assym (5)     6
#> 217  6                     (06) Mixed assym (6)     7
#> 218  7                     (06) Mixed assym (7)     7
#> 219  8                     (06) Mixed assym (8)    12
#> 220  9                     (06) Mixed assym (9)     1
#> 221 10                    (06) Mixed assym (10)     5
#> 222 11                    (06) Mixed assym (11)     4
#> 223 12                    (06) Mixed assym (12)     3
#> 224 13                    (06) Mixed assym (13)     3
#> 225 14                    (06) Mixed assym (14)    12
#> 226 15                    (06) Mixed assym (15)     6
#> 227 16                    (06) Mixed assym (16)     6
#> 228 17                    (06) Mixed assym (17)     6
#> 229 18                    (06) Mixed assym (18)     7
#> 230 19                    (06) Mixed assym (19)     8
#> 231 20                    (06) Mixed assym (20)     0
#> 232  0  (07) Partial false positive (assym) (0)    56
#> 233  1  (07) Partial false positive (assym) (1)     1
#> 234  2  (07) Partial false positive (assym) (2)    23
#> 235  3  (07) Partial false positive (assym) (3)    15
#> 236  4  (07) Partial false positive (assym) (4)    23
#> 237  5  (07) Partial false positive (assym) (5)    31
#> 238  6  (07) Partial false positive (assym) (6)     6
#> 239  7  (07) Partial false positive (assym) (7)     5
#> 240  8  (07) Partial false positive (assym) (8)    14
#> 241  9  (07) Partial false positive (assym) (9)     1
#> 242 10 (07) Partial false positive (assym) (10)    10
#> 243 11 (07) Partial false positive (assym) (11)    14
#> 244 12 (07) Partial false positive (assym) (12)     1
#> 245 13 (07) Partial false positive (assym) (13)     1
#> 246 14 (07) Partial false positive (assym) (14)    28
#> 247 15 (07) Partial false positive (assym) (15)     9
#> 248 16 (07) Partial false positive (assym) (16)    15
#> 249 17 (07) Partial false positive (assym) (17)    37
#> 250 18 (07) Partial false positive (assym) (18)    34
#> 251 19 (07) Partial false positive (assym) (19)    37
#> 252 20 (07) Partial false positive (assym) (20)     0
#> 253  0  (08) Complete false negative (full) (0)     1
#> 254  1  (08) Complete false negative (full) (1)    32
#> 255  2  (08) Complete false negative (full) (2)    13
#> 256  3  (08) Complete false negative (full) (3)    10
#> 257  4  (08) Complete false negative (full) (4)     9
#> 258  5  (08) Complete false negative (full) (5)    15
#> 259  6  (08) Complete false negative (full) (6)    13
#> 260  7  (08) Complete false negative (full) (7)    23
#> 261  8  (08) Complete false negative (full) (8)    13
#> 262  9  (08) Complete false negative (full) (9)    29
#> 263 10 (08) Complete false negative (full) (10)    14
#> 264 11 (08) Complete false negative (full) (11)    19
#> 265 12 (08) Complete false negative (full) (12)    26
#> 266 13 (08) Complete false negative (full) (13)    32
#> 267 14 (08) Complete false negative (full) (14)    11
#> 268 15 (08) Complete false negative (full) (15)    12
#> 269 16 (08) Complete false negative (full) (16)    29
#> 270 17 (08) Complete false negative (full) (17)     9
#> 271 18 (08) Complete false negative (full) (18)     9
#> 272 19 (08) Complete false negative (full) (19)     4
#> 273 20 (08) Complete false negative (full) (20)     0
#> 274  0   (09) Partial false negative (full) (0)    14
#> 275  1   (09) Partial false negative (full) (1)    14
#> 276  2   (09) Partial false negative (full) (2)    16
#> 277  3   (09) Partial false negative (full) (3)    26
#> 278  4   (09) Partial false negative (full) (4)    15
#> 279  5   (09) Partial false negative (full) (5)    16
#> 280  6   (09) Partial false negative (full) (6)    28
#> 281  7   (09) Partial false negative (full) (7)    20
#> 282  8   (09) Partial false negative (full) (8)    23
#> 283  9   (09) Partial false negative (full) (9)    18
#> 284 10  (09) Partial false negative (full) (10)    20
#> 285 11  (09) Partial false negative (full) (11)    18
#> 286 12  (09) Partial false negative (full) (12)    22
#> 287 13  (09) Partial false negative (full) (13)    13
#> 288 14  (09) Partial false negative (full) (14)    19
#> 289 15  (09) Partial false negative (full) (15)    23
#> 290 16  (09) Partial false negative (full) (16)    15
#> 291 17  (09) Partial false negative (full) (17)     5
#> 292 18  (09) Partial false negative (full) (18)    17
#> 293 19  (09) Partial false negative (full) (19)    17
#> 294 20  (09) Partial false negative (full) (20)     0
#> 295  0                   (10) Accurate full (0)    34
#> 296  1                   (10) Accurate full (1)     3
#> 297  2                   (10) Accurate full (2)    20
#> 298  3                   (10) Accurate full (3)    13
#> 299  4                   (10) Accurate full (4)    25
#> 300  5                   (10) Accurate full (5)    18
#> 301  6                   (10) Accurate full (6)     8
#> 302  7                   (10) Accurate full (7)     6
#> 303  8                   (10) Accurate full (8)    13
#> 304  9                   (10) Accurate full (9)     2
#> 305 10                  (10) Accurate full (10)    15
#> 306 11                  (10) Accurate full (11)    12
#> 307 12                  (10) Accurate full (12)     1
#> 308 13                  (10) Accurate full (13)     4
#> 309 14                  (10) Accurate full (14)    19
#> 310 15                  (10) Accurate full (15)    14
#> 311 16                  (10) Accurate full (16)     5
#> 312 17                  (10) Accurate full (17)    35
#> 313 18                  (10) Accurate full (18)    23
#> 314 19                  (10) Accurate full (19)    28
#> 315 20                  (10) Accurate full (20)    49
```

Now checking that none of these coincide completely

``` r
# Removing the network id
ans$name <- gsub("\\([0-9]+\\)$", "", ans$name)
```

Checking out the distribution

``` r
library(ggplot2)

# keeping the onces from the census only
ans <- subset(ans, grepl("^\\([0-9]", name))

ggplot(data = ans, aes(y = value)) +
  geom_histogram() + 
  facet_wrap(vars(name)) +
  coord_flip() +
  labs(title = "Distribution of type of errors")
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="man/figures/README-dist-1.png" width="100%" />
