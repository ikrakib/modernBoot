#' Wild Bootstrap for Linear Model Coefficients
#'
#' Performs wild bootstrap resampling for linear regression models to handle heteroscedasticity.
#' Supports Rademacher and Mammen weight schemes.
#'
#' @param fit an object of class 'lm' from \code{\link[stats]{lm}}.
#'   Should be fitted linear regression model. Heteroscedasticity is allowed and
#'   expected - this method is specifically designed to handle non-constant variance
#'   in residuals. Model should have at least 1 predictor.
#' @param R integer number of bootstrap replicates (default 2000).
#'   Larger values (5000-10000) recommended for confidence intervals in publications.
#'   Must be >= 1 and a whole number.
#' @param type character string specifying weight distribution scheme.
#'   Options: "rademacher" (default, faster, robust) generates weights as +1/-1
#'   with equal probability. "mammen" (asymptotically optimal) uses empirically
#'   calibrated Mammen distribution with golden ratio. Choice has minimal practical
#'   impact on results.
#'
#' @return A list with two elements:
#'   \item{coef}{numeric vector of original fitted model coefficients,
#'     including intercept if present. Names preserved from original model.}
#'   \item{boot}{numeric matrix of dimensions (p x R) where p is number of
#'     coefficients. Each column contains one bootstrap replicate of coefficients.
#'     Row names are coefficient names; column names are bootstrap iteration numbers.}
#'
#' @details
#' The wild bootstrap works by resampling residuals with random signs/weights while keeping
#' predictors fixed. This is particularly useful for heteroscedastic data.
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(50)
#' y <- 2 + 1.5 * x + rnorm(50, sd = abs(x))  # heteroscedastic
#' fit <- lm(y ~ x)
#' result <- wild_boot_lm(fit, R = 500, type = "rademacher")
#' head(result$boot, 3)
#'
#' @export
wild_boot_lm <- function(fit, R = 2000, type = c("rademacher", "mammen")) {
  type <- match.arg(type)

  if (!inherits(fit, "lm")) {
    stop("fit must be an object of class 'lm'", call. = FALSE)
  }

  stopifnot(
    is.numeric(R), R >= 1, R == as.integer(R)
  )

  X <- stats::model.matrix(fit)
  resid <- stats::residuals(fit)
  fitted_vals <- stats::fitted(fit)
  n <- length(resid)
  p <- ncol(X)

  # Initialize bootstrap matrix
  boots <- matrix(NA_real_, nrow = p, ncol = R)

  for (r in seq_len(R)) {
    # Generate weights
    if (type == "rademacher") {
      # Rademacher: +1 or -1 with equal probability
      v <- .safe_sample(c(-1, 1), n, replace = TRUE)
    } else {
      # Mammen distribution
      # P(v = (1-sqrt(5))/2) = (sqrt(5)+1)/(2*sqrt(5))
      # P(v = (1+sqrt(5))/2) = 1 - above
      phi <- (1 + sqrt(5)) / 2  # golden ratio
      a <- (1 - phi) / phi       # approximately -0.618
      b <- (phi - 1)             # approximately 0.618
      prob_b <- (phi) / (2 * sqrt(5))
      v <- .safe_sample(c(a, b), n, replace = TRUE, prob = c(1 - prob_b, prob_b))
    }

    # Generate resampled response
    y_star <- fitted_vals + resid * v

    # Fit model to resampled data
    fit_star <- stats::lm(y_star ~ X - 1)
    boots[, r] <- stats::coef(fit_star)
  }

  list(
    coef = stats::coef(fit),
    boot = boots
  )
}
