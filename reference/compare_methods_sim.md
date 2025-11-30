# Simulation Study: Compare Bootstrap Methods

Runs a simulation study comparing different bootstrap and permutation
methods. Useful for empirical evaluation of method performance and
coverage.

## Usage

``` r
compare_methods_sim(data_generator, Rsim = 100, Rboot = 1000, parallel = TRUE)
```

## Arguments

- data_generator:

  function taking no arguments and returning numeric vector of data.
  Called Rsim times to generate independent datasets. Example:
  `function() rnorm(50, mean=5, sd=2)` generates normal data. Function
  must not have side effects; should be deterministic given seed.

- Rsim:

  integer number of simulated datasets to generate (default 100). Larger
  values (500+) provide more stable coverage rate estimates but increase
  computation time. Each simulation applies both bs_mean and bca_ci
  methods independently. Must be \>= 1.

- Rboot:

  integer number of bootstrap replicates used within each method per
  dataset (default 1000). Matches R parameter passed to bs_mean and
  bca_ci. Larger values (2000-5000) improve interval accuracy but
  increase total computation (total bootstrap samples = Rsim \* Rboot).
  Must be \>= 1.

- parallel:

  logical enable parallel computation across simulations (default TRUE).
  Uses
  [`multisession`](https://future.futureverse.org/reference/multisession.html)
  plan to distribute simulations across available cores. User can
  override with
  [`plan`](https://future.futureverse.org/reference/plan.html)`(future::sequential)`
  before calling for sequential execution.

## Value

A list of length Rsim. Each element is a list with two components:

- bs:

  result from
  [`bs_mean`](https://github.com/ikrakib/modernBoot/reference/bs_mean.md)
  applied to simulated dataset. Is NA if generation or computation
  failed.

- bca:

  result from
  [`bca_ci`](https://github.com/ikrakib/modernBoot/reference/bca_ci.md)
  applied to same dataset. Is NA if generation or computation failed.

Use to assess coverage rates: did true parameter fall within returned
CIs? Interval width variation indicates method stability.

## Details

This function repeatedly generates data from data_generator and applies
bs_mean and bca_ci methods. Results can be used to study coverage rates,
interval width, and method robustness.

## Examples

``` r
# \donttest{
set.seed(42)
# Simulate from normal distribution
generator <- function() rnorm(50, mean = 5, sd = 2)
sim_results <- compare_methods_sim(generator, Rsim = 50, Rboot = 500)

# Analyze coverage: does true mean (5) fall in each CI?
coverage_bs <- mean(sapply(sim_results, function(res) {
  res$bs$ci[1] <= 5 && 5 <= res$bs$ci[2]
}))
coverage_bs
#> [1] 0.94
# }
```
