# Automatic Resampling Method Selection

Inspects data structure and recommends an appropriate resampling method.

## Usage

``` r
auto_select_method(data, cluster = NULL)
```

## Arguments

- data:

  numeric vector, matrix, or time series object representing data to
  analyze. For vectors: univariate sample. For matrices/data.frames:
  multivariate data with rows=observations, columns=variables. For ts
  objects: automatically detected as time series.

- cluster:

  optional vector of cluster IDs (integer or factor). Length must equal
  nrow(data) for matrices or length(data) for vectors. Identifies
  hierarchical grouping (e.g., repeated measures within subjects,
  multiple samples from same source). If NULL (default), clustering is
  not considered. If provided, triggers clustered bootstrap
  recommendation.

## Value

A list with two character string elements:

- method:

  recommended resampling method name. Values: "clustered_boot" (if
  cluster provided), "block_boot" (if time series detected), "perm_maxT"
  (if multivariate matrix detected), "nonparametric_boot" (default for
  IID univariate data)

- rationale:

  human-readable explanation of recommendation. Describes why chosen
  method is appropriate and what structure the data exhibits.

## Details

Decision logic: - If clusters provided: use clustered bootstrap - If
time series detected: use block or stationary bootstrap - If
multivariate matrix: use permutation maxT - Otherwise (IID data): use
standard nonparametric bootstrap

## Examples

``` r
# IID data
x <- rnorm(50)
auto_select_method(x)
#> $method
#> [1] "nonparametric_boot"
#> 
#> $rationale
#> [1] "IID univariate data detected; use standard nonparametric bootstrap (bs_mean, bca_ci, etc.)."
#> 

# Time series
ts_data <- arima.sim(n = 100, list(ar = 0.7))
auto_select_method(ts_data)
#> $method
#> [1] "block_boot"
#> 
#> $rationale
#> [1] "Time series structure detected; use block or stationary bootstrap to preserve temporal dependence."
#> 
```
