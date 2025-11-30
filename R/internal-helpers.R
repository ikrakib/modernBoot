#' Input validation: check for numeric vector
#'
#' Throws an error if input is not a numeric vector with at least 2 elements.
#'
#' @param x The object to check.
#' @param name The name of the object to use in the error message.
#'
#' @keywords internal
#' @noRd
check_numeric_vector <- function(x, name = deparse(substitute(x))) {
  # Allow time series objects (convert internally if needed for validation)
  x_check <- x
  if (inherits(x, "ts") || inherits(x, "xts") || inherits(x, "zoo")) {
    x_check <- as.numeric(x)
  }

  if (!is.numeric(x_check) || length(x_check) < 2) {
    stop(paste0("`", name, "` must be a numeric vector with at least 2 elements."), call. = FALSE)
  }
}

#' Safe sample function
#'
#' Wrapper around sample() that behaves consistently even when x has length 1.
#'
#' @param x A vector to sample from
#' @param size Sample size
#' @param replace Logical, sample with replacement?
#' @param prob Probability weights
#'
#' @keywords internal
#' @noRd
.safe_sample <- function(x, size = length(x), replace = FALSE, prob = NULL) {
  if (length(x) == 1 && is.numeric(x) && x >= 1) {
    # Standard sample(n) behavior when x is a single integer
    sample.int(x, size, replace, prob)
  } else {
    # Normal vector sampling
    sample(x, size, replace, prob)
  }
}

#' Helper for sampling integers
#'
#' @keywords internal
#' @noRd
.safe_sample.int <- function(n, size, ...) {
  sample.int(n, size, ...)
}
