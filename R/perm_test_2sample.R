#' Two-Sample Permutation Test
#'
#' Performs exact or approximate permutation test for comparing two independent samples.
#' Tests null hypothesis that two groups have equal distributions.
#'
#' @param x numeric vector, first sample (group A). May contain NAs which are
#'   removed. Minimum 2 observations required. Length need not equal length(y).
#' @param y numeric vector, second sample (group B). May contain NAs which are
#'   removed. Minimum 2 observations required. Compared against x for differences.
#' @param R integer number of permutation replicates (default 5000).
#'   Larger values (e.g., 10000) improve p-value accuracy. Must be >= 1.
#'   Exact test feasible when R = C(n1+n2, n1) (factorial complexity),
#'   otherwise uses approximate permutation distribution.
#' @param stat function taking two arguments (a, b) and returning numeric scalar
#'   test statistic. Default: \code{function(a, b) mean(a) - mean(b)}
#'   tests difference of means. Alternative: \code{function(a, b) median(a) - median(b)}
#'   for medians, or custom statistics. Function must handle NAs gracefully.
#'
#' @return A list with three elements:
#'   \item{obs}{numeric scalar, the observed test statistic computed on original data}
#'   \item{reps}{numeric vector of length R, test statistics under random
#'     permutations of group labels. Represents null distribution assuming
#'     equal distributions between groups.}
#'   \item{p.value}{numeric scalar between 0 and 1, two-sided p-value computed as
#'     proportion of permutation replicates with |stat| >= |obs|. Value 1/R is
#'     smallest achievable p-value.}
#'
#' @details
#' Under the null hypothesis of equal distributions, exchanging group labels
#' should be equally likely. The p-value is the proportion of permutations
#' with test statistic at least as extreme as observed (in absolute value).
#'
#' @examples
#' set.seed(42)
#' group1 <- rnorm(20, mean = 0)
#' group2 <- rnorm(20, mean = 0.5)
#' result <- perm_test_2sample(group1, group2, R = 1000)
#' result$p.value
#'
#' @export
perm_test_2sample <- function(x, y, R = 5000,
                              stat = function(a, b) mean(a) - mean(b)) {
  check_numeric_vector(x, "x")
  check_numeric_vector(y, "y")
  stopifnot(
    is.numeric(R), R >= 1, R == as.integer(R),
    is.function(stat)
  )

  # Observed statistic
  obs <- stat(x, y)

  # Pooled data
  pooled <- c(x, y)
  nx <- length(x)
  n_total <- length(pooled)

  # Permutation replicates
  reps <- future.apply::future_sapply(seq_len(R), function(i) {
    # Randomly permute indices
    perm_idx <- .safe_sample(seq_len(n_total), n_total, replace = FALSE)
    # Split into two groups of same sizes
    stat(pooled[perm_idx[1:nx]], pooled[perm_idx[-(1:nx)]])
  }, future.seed = TRUE)

  # Two-sided p-value: proportion >= observed in absolute value
  pval <- mean(abs(reps) >= abs(obs))

  list(
    obs = obs,
    reps = reps,
    p.value = pval
  )
}
