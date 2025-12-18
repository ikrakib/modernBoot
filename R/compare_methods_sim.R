#' Simulation Study: Compare Bootstrap Methods
#'
#' Runs a simulation study comparing different bootstrap and permutation methods.
#' Useful for empirical evaluation of method performance and coverage.
#'
#' @param data_generator function taking no arguments and returning numeric vector
#'   of data. Called Rsim times to generate independent datasets.
#'   Example: \code{function() rnorm(50, mean=5, sd=2)} generates normal data.
#'   Function must not have side effects; should be deterministic given seed.
#' @param Rsim integer number of simulated datasets to generate (default 100).
#'   Larger values (500+) provide more stable coverage rate estimates but increase
#'   computation time. Each simulation applies both bs_mean and bca_ci methods
#'   independently. Must be >= 1.
#' @param Rboot integer number of bootstrap replicates used within each method
#'   per dataset (default 1000). Matches R parameter passed to bs_mean and bca_ci.
#'   Larger values (2000-5000) improve interval accuracy but increase total
#'   computation (total bootstrap samples = Rsim * Rboot). Must be >= 1.
#' @param parallel logical enable parallel computation across simulations
#'   (default TRUE). Uses \code{\link[future]{multisession}} plan to distribute
#'   simulations across available cores. User can override with
#'   \code{\link[future]{plan}(future::sequential)} before calling for sequential
#'   execution.
#'
#' @return A list of length Rsim. Each element is a list with two components:
#'   \item{bs}{result from \code{\link{bs_mean}} applied to simulated dataset.
#'     Is NA if generation or computation failed.}
#'   \item{bca}{result from \code{\link{bca_ci}} applied to same dataset.
#'     Is NA if generation or computation failed.}
#'   Use to assess coverage rates: did true parameter fall within returned CIs?
#'   Interval width variation indicates method stability.
#'
#' @details
#' This function repeatedly generates data from data_generator and applies
#' bs_mean and bca_ci methods. Results can be used to study coverage rates,
#' interval width, and method robustness.
#'
#' @examples
#' # Fast example (runs in < 5 sec) - UNWRAPPED
#' set.seed(42)
#' generator <- function() rnorm(20)
#' # Very small simulation for demonstration
#' results_fast <- compare_methods_sim(generator, Rsim = 5, Rboot = 100)
#'
#' \donttest{
#' # Realistic simulation (takes > 5 sec) - WRAPPED in \donttest
#' set.seed(42)
#' generator <- function() rnorm(50, mean = 5, sd = 2)
#' sim_results <- compare_methods_sim(generator, Rsim = 50, Rboot = 500)
#'
#' # Analyze coverage: does true mean (5) fall in each CI?
#' coverage_bs <- mean(sapply(sim_results, function(res) {
#'   res$bs$ci[1] <= 5 && 5 <= res$bs$ci[2]
#' }))
#' coverage_bs
#' }
#'
#' @export
compare_methods_sim <- function(data_generator, Rsim = 100, Rboot = 1000, parallel = TRUE) {
  if (!is.function(data_generator)) {
    stop("data_generator must be a function", call. = FALSE)
  }

  stopifnot(
    is.numeric(Rsim), Rsim >= 1, Rsim == as.integer(Rsim),
    is.numeric(Rboot), Rboot >= 1, Rboot == as.integer(Rboot),
    is.logical(parallel)
  )

  # Set parallelization
  old_plan <- future::plan()
  on.exit(future::plan(old_plan))

  if (parallel) {
    future::plan(future::multisession, workers = future::availableCores() - 1)
  } else {
    future::plan(future::sequential)
  }

  # Run simulation
  results <- future.apply::future_lapply(seq_len(Rsim), function(i) {
    # Generate data
    dat <- tryCatch(data_generator(), error = function(e) {
      warning("data_generator failed for iteration ", i)
      return(NULL)
    })

    if (is.null(dat)) {
      return(list(bs = NA, bca = NA))
    }

    # Apply methods with error handling
    list(
      bs = tryCatch(
        bs_mean(dat, R = Rboot),
        error = function(e) {
          warning("bs_mean failed: ", e$message)
          NA
        }
      ),
      bca = tryCatch(
        bca_ci(dat, R = Rboot),
        error = function(e) {
          warning("bca_ci failed: ", e$message)
          NA
        }
      )
    )
  }, future.seed = TRUE)

  results
}
