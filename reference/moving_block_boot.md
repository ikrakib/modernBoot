# Moving Block Bootstrap for Time Series

Performs moving block bootstrap resampling for dependent data (time
series). Preserves temporal dependence structure within blocks.

## Usage

``` r
moving_block_boot(x, block_size = 10, R = 1000)
```

## Arguments

- x:

  numeric vector or time series object. Should be univariate time series
  with temporal dependence (autocorrelation). If using ts object,
  inherits frequency information. Length n \>= block_size required.

- block_size:

  integer length of consecutive observations to keep together in
  bootstrap samples (default 10). Rule of thumb: approximately sqrt(n)
  where n is series length. Must be \>= 1 and \<= length(x). Larger
  blocks preserve longer-range dependence; smaller blocks reduce
  distortion but may not capture autocorrelation structure.

- R:

  integer number of bootstrap replicates (default 1000). Each replicate
  is a complete time series of length n obtained by concatenating
  randomly selected blocks. Must be \>= 1.

## Value

A list of length R. Each element is a numeric vector of length n (same
as original series length), representing one bootstrap replicate of the
time series. Replicates preserve block structure and local dependence
within blocks, though global autocorrelation structure may be altered.

## Details

The moving block bootstrap divides the time series into overlapping
blocks of length block_size and resamples these blocks with replacement.
This preserves short-range dependence while allowing the empirical
sampling distribution to reflect dependence.

## Examples

``` r
set.seed(42)
x <- arima.sim(n = 100, list(ar = 0.7))
result <- moving_block_boot(x, block_size = 10, R = 100)
length(result)  # 100 bootstrap replicates
#> [1] 100
```
