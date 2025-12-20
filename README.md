# modernBoot

**CRAN-Approved R Package for Advanced Bootstrap Resampling**

## Overview

`modernBoot` is a CRAN-published R package providing modern, efficient, and computationally fast bootstrap resampling techniques for robust statistical inference.

### Key Features

- **Fast & Efficient:** Optimized with vectorized R and a C++ backend for high performance.
- **Multiple CI Methods:** Supports percentile, BCa (Bias-Corrected and Accelerated), and bootstrap-t confidence intervals.
- **Hypothesis Testing:** Includes functions for bootstrap-based hypothesis tests and p-value calculation.
- **Advanced Sampling:** Implements stratified and block bootstrap for complex data structures.
- **Parallel Processing:** Built-in support for multi-core processing to speed up computations on large datasets.

## Installation

### From CRAN (Recommended)
install.packages("modernBoot")

text

### From GitHub (Development Version)
install.packages("devtools")
devtools::install_github("ikrakib/modernBoot")

text

## Quick Example

library(modernBoot)

Generate sample data
set.seed(123)
data <- rnorm(100, mean = 5, sd = 2)

Calculate Bias-Corrected and Accelerated (BCa) bootstrap CI
result_ci <- boot_ci(data, statistic = mean, R = 2000, ci = "bca")
print(result_ci)

Perform a bootstrap hypothesis test
test_result <- boot_test(data, statistic = mean, null_value = 5.5, R = 2000)
print(test_result)

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

If you use `modernBoot` in your research, please cite it as:
Rakib, I. K. (2025). modernBoot: Advanced Bootstrap Resampling Methods.
R package version 1.0.0. https://CRAN.R-project.org/package=modernBoot

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
