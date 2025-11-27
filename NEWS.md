# modernBoot 0.1.0

## New Features

- Initial release of **modernBoot** package with core resampling methods
- **Bootstrap methods**: `bs_mean()`, `bca_ci()`, `studentized_ci()` for confidence intervals
- **Wild bootstrap**: `wild_boot_lm()` for heteroscedastic linear models with Rademacher and Mammen weights
- **Block bootstrap**: `moving_block_boot()` and `stationary_boot()` for dependent time series data
- **Permutation tests**: `perm_test_2sample()` for two-sample inference
- **Multiple testing correction**: `perm_maxT()` for controlling family-wise error rate
- **Automated method selection**: `auto_select_method()` intelligently recommends resampling approach based on data structure
- **Simulation tools**: `compare_methods_sim()` for benchmarking different resampling methods
- **Parallel computation**: Full support for `future` package parallelization (user-controlled)

## Functions

### Bootstrap Functions
- `bs_mean()` — Nonparametric bootstrap confidence interval for the mean (percentile method)
- `bca_ci()` — Bias-corrected and accelerated (BCa) bootstrap confidence interval
- `studentized_ci()` — Studentized bootstrap confidence interval for quantiles

### Dependent Data Bootstrap
- `moving_block_boot()` — Moving block bootstrap for time series
- `stationary_boot()` — Stationary bootstrap (Politis & Romano, 1994)

### Model-Based Bootstrap
- `wild_boot_lm()` — Wild bootstrap for linear regression with heteroscedasticity

### Permutation Tests
- `perm_test_2sample()` — Two-sample permutation test
- `perm_maxT()` — Permutation maxT for multiple hypothesis testing with FWER control

### Utilities
- `auto_select_method()` — Automatic resampling method selection
- `compare_methods_sim()` — Simulation comparison of bootstrap methods
- Internal helpers: `check_numeric_vector()`, `.safe_sample()`

## Documentation

- Comprehensive package vignette: `vignette("method-selection")`
- Full function documentation with examples
- README with quick-start guide and installation instructions
- CI/CD workflows (R-CMD-check on macOS, Linux, Windows; pkgdown deployment)

## Dependencies

- **Imports**: `stats`, `utils`, `boot`, `future`, `future.apply`
- **Suggests**: `testthat`, `covr`, `pkgdown`, `knitr`, `rmarkdown`, `rhub`
- **Requires**: R ≥ 4.0

## Testing

- Initial test suite included in `tests/testthat/`
- Tests for `bs_mean()` and `perm_test_2sample()`
- Comprehensive test expansion planned for future releases

## References

- Efron, B., & Tibshirani, R. J. (1993). *An introduction to the bootstrap*. Chapman and Hall/CRC.
- Politis, D. N., & Romano, J. P. (1994). The stationary bootstrap. *Journal of the American Statistical Association*, 89(428), 1303-1313.
- Wu, C. F. (1986). Jackknife, bootstrap and other resampling methods in regression analysis. *Annals of Statistics*, 14(4), 1261-1295.

## Future Enhancements

- Cluster bootstrap for clustered data
- Bayesian bootstrap methods
- Rcpp implementations for speed optimization
- Extended vignettes with real-world examples
- Performance benchmarking suite
