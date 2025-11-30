#' Nonparametric Bootstrap Confidence Interval for the Mean
#'
#' Compute a bootstrap distribution for the sample mean.
#'
#' @importFrom stats setNames quantile
#'
#' @param x numeric vector of data.
#' @param R integer number of bootstrap replicates (default 2000).
#' @param conf numeric confidence level between 0 and 1 (default 0.95).
#'
#' @return A list with elements stat (mean), boot (replicates), and ci (interval).
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(50, mean = 5, sd = 2)
#' result <- bs_mean(x, R = 500)
#' result$ci
#'
#' @export
bs_mean <- function(x, R = 2000, conf = 0.95) {
  check_numeric_vector(x)
  n <- length(x)

  # Bootstrap loop
  boots <- numeric(R)
  for(i in 1:R) {
    idx <- sample(n, n, replace = TRUE)
    boots[i] <- mean(x[idx], na.rm = TRUE)
  }

  # CI
  alpha <- 1 - conf
  ci <- quantile(boots, probs = c(alpha/2, 1 - alpha/2))

  list(stat = mean(x, na.rm = TRUE), boot = boots, ci = ci)
}
