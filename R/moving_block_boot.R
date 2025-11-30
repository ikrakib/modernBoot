#' Moving Block Bootstrap for Time Series
#'
#' Performs moving block bootstrap resampling for dependent data (time series).
#' Preserves temporal dependence structure within blocks.
#'
#' @param x numeric vector or time series object. Should be univariate time series
#'   with temporal dependence (autocorrelation). If using ts object, inherits
#'   frequency information. Length n >= block_size required.
#' @param block_size integer length of consecutive observations to keep together
#'   in bootstrap samples (default 10). Rule of thumb: approximately sqrt(n) where
#'   n is series length. Must be >= 1 and <= length(x). Larger blocks preserve
#'   longer-range dependence; smaller blocks reduce distortion but may not capture
#'   autocorrelation structure.
#' @param R integer number of bootstrap replicates (default 1000).
#'   Each replicate is a complete time series of length n obtained by
#'   concatenating randomly selected blocks. Must be >= 1.
#'
#' @return A list of length R. Each element is a numeric vector of length n
#'   (same as original series length), representing one bootstrap replicate
#'   of the time series. Replicates preserve block structure and local dependence
#'   within blocks, though global autocorrelation structure may be altered.
#'
#' @details
#' The moving block bootstrap divides the time series into overlapping blocks of length
#' block_size and resamples these blocks with replacement. This preserves short-range
#' dependence while allowing the empirical sampling distribution to reflect dependence.
#'
#' @examples
#' set.seed(42)
#' x <- arima.sim(n = 100, list(ar = 0.7))
#' result <- moving_block_boot(x, block_size = 10, R = 100)
#' length(result)  # 100 bootstrap replicates
#'
#' @export
moving_block_boot <- function(x, block_size = 10, R = 1000) {
  check_numeric_vector(x, "x")
  stopifnot(
    is.numeric(block_size), block_size >= 1, block_size == as.integer(block_size),
    is.numeric(R), R >= 1, R == as.integer(R)
  )

  n <- length(x)

  if (block_size > n) {
    stop(sprintf("block_size (%d) cannot exceed length of x (%d)", block_size, n), call. = FALSE)
  }

  # Create all possible blocks
  nb_total <- n - block_size + 1
  block_starts <- seq_len(nb_total)
  blocks <- lapply(block_starts, function(i) {
    x[i:(i + block_size - 1)]
  })

  # Number of blocks needed per replicate
  nb_needed <- ceiling(n / block_size)

  # Generate bootstrap replicates
  out <- vector("list", R)
  for (r in seq_len(R)) {
    # Randomly select blocks with replacement
    selected_idx <- .safe_sample(seq_along(blocks), nb_needed, replace = TRUE)
    # Concatenate selected blocks and trim to original length
    boot_series <- unlist(blocks[selected_idx])[seq_len(n)]
    out[[r]] <- boot_series
  }

  out
}
