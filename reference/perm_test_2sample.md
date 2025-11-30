# Two-Sample Permutation Test

Performs exact or approximate permutation test for comparing two
independent samples. Tests null hypothesis that two groups have equal
distributions.

## Usage

``` r
perm_test_2sample(x, y, R = 5000, stat = function(a, b) mean(a) - mean(b))
```

## Arguments

- x:

  numeric vector, first sample (group A). May contain NAs which are
  removed. Minimum 2 observations required. Length need not equal
  length(y).

- y:

  numeric vector, second sample (group B). May contain NAs which are
  removed. Minimum 2 observations required. Compared against x for
  differences.

- R:

  integer number of permutation replicates (default 5000). Larger values
  (e.g., 10000) improve p-value accuracy. Must be \>= 1. Exact test
  feasible when R = C(n1+n2, n1) (factorial complexity), otherwise uses
  approximate permutation distribution.

- stat:

  function taking two arguments (a, b) and returning numeric scalar test
  statistic. Default: `function(a, b) mean(a) - mean(b)` tests
  difference of means. Alternative:
  `function(a, b) median(a) - median(b)` for medians, or custom
  statistics. Function must handle NAs gracefully.

## Value

A list with three elements:

- obs:

  numeric scalar, the observed test statistic computed on original data

- reps:

  numeric vector of length R, test statistics under random permutations
  of group labels. Represents null distribution assuming equal
  distributions between groups.

- p.value:

  numeric scalar between 0 and 1, two-sided p-value computed as
  proportion of permutation replicates with \|stat\| \>= \|obs\|. Value
  1/R is smallest achievable p-value.

## Details

Under the null hypothesis of equal distributions, exchanging group
labels should be equally likely. The p-value is the proportion of
permutations with test statistic at least as extreme as observed (in
absolute value).

## Examples

``` r
set.seed(42)
group1 <- rnorm(20, mean = 0)
group2 <- rnorm(20, mean = 0.5)
result <- perm_test_2sample(group1, group2, R = 1000)
result$p.value
#> [1] 0.932
```
