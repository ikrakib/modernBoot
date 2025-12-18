# Studentized Bootstrap Confidence Interval for Quantiles

Computes a studentized (t-based) bootstrap confidence interval for
quantiles. More accurate than percentile intervals, especially for
extreme quantiles.

## Usage

``` r
studentized_ci(x, q = 0.5, R = 1000, Rinner = 200, conf = 0.95)
```

## Arguments

- x:

  numeric vector of data. May contain NAs which are removed. Minimum 2
  observations required. Works well for skewed distributions and extreme
  quantiles where percentile bootstrap performs poorly.

- q:

  numeric quantile level between 0 and 1 (default 0.5 for median). 0.25
  = first quartile, 0.75 = third quartile, 0.95 = 95th percentile.
  Method particularly effective for extreme quantiles (q \< 0.1 or q \>
  0.9).

- R:

  integer number of outer bootstrap replicates (default 1000). This is
  primary bootstrap sample for t-distribution estimation. Recommended:
  500-1000 for exploration, 2000+ for publication. Must be \>= 1.

- Rinner:

  integer number of inner bootstrap replicates for standard error
  estimation of each outer replicate (default 200). Larger values
  increase accuracy but also computation time (total iterations = R \*
  Rinner). Recommended: 100-200. Must be \>= 1.

- conf:

  numeric confidence level between 0 and 1 (default 0.95). Standard:
  0.95 or 0.99. Higher values give wider intervals.

## Value

A numeric vector of length 2 with names c("lower", "upper"):

- lower:

  numeric, lower confidence limit for the q-th quantile

- upper:

  numeric, upper confidence limit for the q-th quantile

Uses studentized bootstrap t-distribution to construct interval,
providing better coverage probability than percentile method, especially
for skewed distributions and extreme quantiles.

## Details

Studentized bootstrap uses the bootstrap t-distribution to construct
intervals. This method often provides better coverage than percentile
bootstrap, especially for skewed distributions or extreme quantiles.

Computation is intensive: O(R \* Rinner) bootstrap samples are
generated.

## Examples

``` r
set.seed(42)
x <- rexp(30)  # Smaller sample: 30 instead of 50

# Fast example with reduced replications (< 5 sec) - UNWRAPPED
studentized_ci(x, q = 0.75, R = 100, Rinner = 20)
#>     lower     upper 
#> 0.9810471 1.6335035 

# \donttest{
# Larger, more accurate example (takes > 5 sec) - WRAPPED in \donttest
set.seed(42)
x <- rexp(50)
studentized_ci(x, q = 0.75, R = 1000, Rinner = 200)
#>    lower    upper 
#> 1.095099 1.504651 
# }
```
