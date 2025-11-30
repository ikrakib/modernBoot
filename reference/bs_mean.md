# Nonparametric Bootstrap Confidence Interval for the Mean

Compute a bootstrap distribution for the sample mean.

## Usage

``` r
bs_mean(x, R = 2000, conf = 0.95)
```

## Arguments

- x:

  numeric vector of data.

- R:

  integer number of bootstrap replicates (default 2000).

- conf:

  numeric confidence level between 0 and 1 (default 0.95).

## Value

A list with elements stat (mean), boot (replicates), and ci (interval).

## Examples

``` r
set.seed(42)
x <- rnorm(50, mean = 5, sd = 2)
result <- bs_mean(x, R = 500)
result$ci
#>     2.5%    97.5% 
#> 4.290905 5.527923 
```
