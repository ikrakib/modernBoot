#' Studentized Bootstrap Confidence Interval for Quantiles
#'
#' Computes a studentized (t-based) bootstrap confidence interval for quantiles.
#' More accurate than percentile intervals, especially for extreme quantiles.
#'
#' @param x numeric vector of data. May contain NAs which are removed.
#'   Minimum 2 observations required. Works well for skewed distributions and
#'   extreme quantiles where percentile bootstrap performs poorly.
#' @param q numeric quantile level between 0 and 1 (default 0.5 for median).
#'   0.25 = first quartile, 0.75 = third quartile, 0.95 = 95th percentile.
#'   Method particularly effective for extreme quantiles (q < 0.1 or q > 0.9).
#' @param R integer number of outer bootstrap replicates (default 1000).
#'   This is primary bootstrap sample for t-distribution estimation.
#'   Recommended: 500-1000 for exploration, 2000+ for publication. Must be >= 1.
#' @param Rinner integer number of inner bootstrap replicates for standard error
#'   estimation of each outer replicate (default 200). Larger values increase
#'   accuracy but also computation time (total iterations = R * Rinner).
#'   Recommended: 100-200. Must be >= 1.
#' @param conf numeric confidence level between 0 and 1 (default 0.95).
#'   Standard: 0.95 or 0.99. Higher values give wider intervals.
#'
#' @return A numeric vector of length 2 with names c("lower", "upper"):
#'   \item{lower}{numeric, lower confidence limit for the q-th quantile}
#'   \item{upper}{numeric, upper confidence limit for the q-th quantile}
#'   Uses studentized bootstrap t-distribution to construct interval,
#'   providing better coverage probability than percentile method,
#'   especially for skewed distributions and extreme quantiles.
#'
#' @details
#' Studentized bootstrap uses the bootstrap t-distribution to construct intervals.
#' This method often provides better coverage than percentile bootstrap, especially
#' for skewed distributions or extreme quantiles.
#'
#' Computation is intensive: O(R * Rinner) bootstrap samples are generated.
#'
#' @examples
#' set.seed(42)
#' x <- rexp(50)  # right-skewed distribution
#' ci <- studentized_ci(x, q = 0.75, R = 500, Rinner = 100)
#' ci
#'
#' @export
studentized_ci <- function(x, q = 0.5, R = 1000, Rinner = 200, conf = 0.95) {
  check_numeric_vector(x, "x")
  stopifnot(
    is.numeric(q), q > 0, q < 1,
    is.numeric(R), R >= 1, R == as.integer(R),
    is.numeric(Rinner), Rinner >= 1, Rinner == as.integer(Rinner),
    is.numeric(conf), conf > 0, conf < 1
  )

  n <- length(x)

  # Original quantile estimate
  theta_hat <- stats::quantile(x, q, na.rm = TRUE)

  # Outer bootstrap: compute t-statistics
  t_stats <- numeric(R)

  for (i in seq_len(R)) {
    # Outer bootstrap sample
    idx <- .safe_sample(seq_len(n), n, replace = TRUE)
    x_boot <- x[idx]
    theta_boot <- stats::quantile(x_boot, q, na.rm = TRUE)

    # Inner bootstrap: estimate standard error of theta_boot
    inner_estimates <- numeric(Rinner)
    for (j in seq_len(Rinner)) {
      idx_inner <- .safe_sample(seq_len(n), n, replace = TRUE)
      inner_estimates[j] <- stats::quantile(x_boot[idx_inner], q, na.rm = TRUE)
    }

    se_boot <- stats::sd(inner_estimates)

    # Avoid division by zero
    if (se_boot > 1e-10 && !is.na(se_boot)) {
      t_stats[i] <- (theta_boot - theta_hat) / se_boot
    } else {
      t_stats[i] <- NA_real_
    }
  }

  # Remove NA values
  t_stats <- stats::na.omit(t_stats)

  if (length(t_stats) == 0) {
    stop("Could not compute studentized CI; try different parameters", call. = FALSE)
  }

  # Compute confidence interval using t-distribution
  alpha <- 1 - conf
  t_alpha_lower <- stats::quantile(t_stats, probs = alpha / 2)
  t_alpha_upper <- stats::quantile(t_stats, probs = 1 - alpha / 2)

  se_hat <- stats::sd(stats::na.omit(
    future.apply::future_sapply(seq_len(min(200, R)), function(i) {
      idx <- .safe_sample(seq_len(n), n, replace = TRUE)
      stats::quantile(x[idx], q, na.rm = TRUE)
    }, future.seed = TRUE)
  ))

  lower <- theta_hat - t_alpha_upper * se_hat
  upper <- theta_hat - t_alpha_lower * se_hat

  c(lower = as.numeric(lower), upper = as.numeric(upper))
}
