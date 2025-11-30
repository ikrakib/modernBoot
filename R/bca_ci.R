#' Bias-Corrected and Accelerated (BCa) Bootstrap Confidence Interval
#'
#' Computes BCa confidence interval for the mean using the boot package.
#'
#' @param x numeric vector of data.
#' @param R integer number of bootstrap replicates (default 2000).
#' @param conf numeric confidence level between 0 and 1 (default 0.95).
#'
#' @return A list with elements boot (object) and ci (matrix).
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(50, mean = 5, sd = 2)
#' result <- bca_ci(x, R = 500)
#' result$ci
#'
#' @export
bca_ci <- function(x, R = 2000, conf = 0.95) {
  # Validation
  check_numeric_vector(x)

  # Define statistic
  stat_func <- function(data, i) mean(data[i], na.rm = TRUE)

  # Run bootstrap
  b <- boot::boot(x, statistic = stat_func, R = R)

  # Compute Interval
  ci_res <- boot::boot.ci(b, type = "bca", conf = conf)

  list(boot = b, ci = ci_res$bca)
}
