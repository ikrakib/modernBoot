# modernBoot

Advanced Bootstrap Resampling Methods for Statistical Inference

## Overview

`modernBoot` provides comprehensive tools for bootstrap resampling and statistical inference, addressing critical gaps in bootstrap methodology with modern, efficient implementations.

### Key Features

- **Prior Sensitivity Analysis** – Assess posterior robustness to prior specification
- **Automated Posterior Predictive Checks** – Comprehensive diagnostic batteries
- **Advanced Model Comparison** – Beyond WAIC/LOO using tracking and cross-validation
- **Convergence Diagnostics** – Advanced MCMC diagnostics with Rank-Normalized Rhats
- **Interactive Prior Elicitation** – Tools for expert knowledge integration

## Installation

### Install from GitHub:
devtools::install_github("ikrakib/modernBoot")

text

### Once available on CRAN:
install.packages("modernBoot")

text

## Quick Example

library(modernBoot)
library(bayesplot)

Fit Bayesian model
data <- mtcars
fit <- stan_glm(mpg ~ hp + wt, data = data, chains = 4)

Run comprehensive diagnostics
result <- prior_sensitivity(fit)
plot(result)

Prior elicitation
result <- prior_elicitation_helper(fit)
print(result)

text

## Functions by Category

### Category 1: Prior Sensitivity
- `prior_sensitivity()` – Comprehensive prior robustness analysis across priors
- `prior_predictive_check()` – Validate prior specifications
- `prior_c_effective()` – Test prior specification strength

### Category 2: Posterior Predictive Checks
- `graphical_ppc()` – Customizable PPC visualizations
- `ppc_intervals()` – E-statistic with PPCs
- `posterior_js()` – Bayesian-based visualizations

### Category 3: Model Comparison
- `bayes_factor_comparison()` – Multi-model comparison suite
- `laplace_factor_comparison()` – Laplace approximation for factors
- `model_waic()` – WAIC with effective sample size tracking

### Category 4: Convergence Diagnostics
- `hierarchical_convergence()` – Hierarchical model diagnostics
- `rhat_rank_normalized()` – Rank-normalized Rhats
- `effective_sample_size_diagnostics()` – ESS measurement tools

### Category 5: Prior Elicitation & Utilities
- `prior_elicitation_helper()` – Interactive prior specification
- `extract_posterior_unified()` – Flexible posterior extraction

## Documentation

For detailed documentation, see the package vignettes:
vignette("bayesDiagnostics")

text

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## Citation

Rakib, I. K. (2025). modernBoot: Advanced Bootstrap Resampling Methods.
R package version 1.0. https://github.com/ikrakib/modernBoot

text

## License

MIT License

## Author

Ibrahim Kholil Rakib  
Email: ikrakib1010@gmail.com  
GitHub: [@ikrakib](https://github.com/ikrakib)  
LinkedIn: [Profile](https://linkedin.com/in/ibrahim-kholil-rakib)

## References

- Efron, B., & Tibshirani, R. J. (1993). *An Introduction to the Bootstrap*. Chapman and Hall/CRC.
- Davison, A. C., & Hinkley, D. V. (1997). *Bootstrap Methods and Their Application*. Cambridge University Press.

See [Releases](https://github.com/ikrakib/modernBoot/releases) for changelog and version history.
