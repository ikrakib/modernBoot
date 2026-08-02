# modernBoot

**CRAN-Published R Package for Modern Resampling Methods**

## Overview

`modernBoot` is a CRAN-published R package providing modern, efficient, and computationally fast bootstrap resampling techniques for robust statistical inference.

### Key Features

- **Efficient computation:** Uses vectorized R and optional parallel processing through the `future` and `future.apply` packages.
- **Multiple CI Methods:** Supports percentile, BCa (Bias-Corrected and Accelerated), and bootstrap-t confidence intervals.
- **Hypothesis Testing:** Includes functions for bootstrap-based hypothesis tests and p-value calculation.
- **Advanced Sampling:** Implements stratified and block bootstrap for complex data structures.
- **Parallel Processing:** Built-in support for multi-core processing to speed up computations on large datasets.

## Installation

### From CRAN

The stable version of `modernBoot` is available from CRAN:

```r
install.packages("modernBoot")
```

### Development version

The development version can be installed from GitHub:

```r
install.packages("remotes")
remotes::install_github("ikrakib/modernBoot")
```

text

## Quick Example

```r
library(modernBoot)

Generate sample data
set.seed(123)
data <- rnorm(100, mean = 5, sd = 2)

Calculate Bias-Corrected and Accelerated (BCa) bootstrap CI
result_ci <- boot_ci(
              data,
              statistic = mean,
              R = 2000,
              ci = "bca"
             )
             
print(result_ci)

Perform a bootstrap hypothesis test
test_result <- boot_test(data, statistic = mean, null_value = 5.5, R = 2000)
print(test_result)
```
text

## Functions by Category

### Category 1: Confidence Intervals
- `boot_ci()`: The primary function for bootstrap confidence intervals (percentile, BCa, bootstrap-t).
- `boot_ci_quantile()`: Specialized function for quantile-based CIs.

### Category 2: Hypothesis Testing
- `boot_test()`: Performs bootstrap-based hypothesis tests.
- `boot_pvalue()`: Calculates bootstrap p-values.

### Category 3: Advanced Resampling
- `bootstrap_sample()`: Core function for generating bootstrap samples.
- `stratified_boot()`: For stratified sampling designs.
- `block_boot()`: For time-series and clustered data.

## Documentation

For detailed examples and function descriptions, see the package manual and vignettes:
View the main vignette
vignette("modernBoot")

Get help for a specific function
?boot_ci

text

## Citation

## Citation

To cite `modernBoot` in research, run:

```r
citation("modernBoot")
```

Current CRAN version: **0.1.1**

Package DOI: `10.32614/CRAN.package.modernBoot`

text

## License

MIT License. See the `LICENSE` file for details.

## Author

**Ibrahim Kholil Rakib**  
Email: `ikrakib1010@gmail.com`  
GitHub: [@ikrakib](https://github.com/ikrakib)  
LinkedIn: [Ibrahim Kholil Rakib](https://linkedin.com/in/ibrahim-kholil-rakib)

## References

- Efron, B., & Tibshirani, R. J. (1993). *An Introduction to the Bootstrap*. Chapman and Hall/CRC.
- Davison, A. C., & Hinkley, D. V. (1997). *Bootstrap Methods and Their Application*. Cambridge University Press.
