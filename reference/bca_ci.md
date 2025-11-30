# Bias-Corrected and Accelerated (BCa) Bootstrap Confidence Interval

Computes BCa confidence interval for the mean using the boot package.

## Usage

``` r
bca_ci(x, R = 2000, conf = 0.95)
```

## Arguments

- x:

  numeric vector of data.

- R:

  integer number of bootstrap replicates (default 2000).

- conf:

  numeric confidence level between 0 and 1 (default 0.95).

## Value

A list with elements boot (object) and ci (matrix).

## Examples

``` r
set.seed(42)
x <- rnorm(50, mean = 5, sd = 2)
result <- bca_ci(x, R = 500)
result$ci
#>      conf                               
#> [1,] 0.95 12.42 488.37 4.265958 5.489188
```
