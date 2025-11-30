# Stationary Bootstrap (Politis & Romano)

Performs stationary bootstrap for dependent data with random block
lengths. More flexible than fixed-block bootstrap for time series with
variable dependence.

## Usage

``` r
stationary_boot(x, p = 0.1, R = 1000)
```

## Arguments

- x:

  numeric vector or time series object. Should be univariate time series
  with temporal dependence. Length n \>= 2 required. If ts object,
  frequency information is not preserved in output.

- p:

  numeric probability parameter controlling average block length
  (default 0.1). Must satisfy 0 \< p \<= 1. Average block length
  approximately 1/p: set p = 0.1 for average blocks of ~10 observations,
  p = 0.05 for ~20 observations. Smaller p values preserve longer-range
  dependence; larger p values reduce distortion.

- R:

  integer number of bootstrap replicates (default 1000). Each replicate
  is complete time series of length n with random block structure. Must
  be \>= 1.

## Value

A list of length R. Each element is a numeric vector of length n
(matching original series). Unlike moving block bootstrap, block lengths
vary randomly following geometric distribution, avoiding artificial
periodicity. Replicates preserve local dependence structure more
flexibly than fixed-block methods.

## Details

The stationary bootstrap uses random block lengths drawn from a
geometric distribution. This avoids artificial periodicity inherent in
fixed-block methods. Set p = 1/m to have average block length
approximately m.

## Examples

``` r
set.seed(42)
x <- arima.sim(n = 100, list(ar = 0.7))
# Average block length of 10: p = 0.1
result <- stationary_boot(x, p = 0.1, R = 100)
length(result)  # 100 bootstrap replicates
#> [1] 100
```
