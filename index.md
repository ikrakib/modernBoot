# modernBoot

Advanced Bootstrap Resampling Methods for Statistical Inference

## Overview

`modernBoot` provides modern and efficient bootstrap resampling
techniques for:

- **Confidence Interval Estimation** – Multiple bootstrap CI methods
- **Hypothesis Testing** – Bootstrap-based statistical tests
- **Model Validation** – Cross-validation with bootstrap
- **Robust Statistics** – Bootstrap for robust estimators

## Features

✨ **Fast Bootstrap Algorithms** - Vectorized operations for speed -
Efficient resampling procedures

🎯 **Multiple CI Methods** - Percentile method - BCa (Bias-Corrected and
Accelerated) - Bootstrap-t method - Studentized bootstrap

## Installation

### From CRAN

install.packages(“modernBoot”)

text

### From GitHub

devtools::install_github(“ikrakib/modernBoot”)

text

## Quick Start

library(modernBoot) data \<- rnorm(100, mean = 5, sd = 2) result \<-
boot_ci(data, mean, R = 1000, ci = “bca”) print(result)

text

## License

MIT License

## Author

Ibrahim Kholil Rakib <ikrakib1010@gmail.com>
