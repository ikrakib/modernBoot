#' Permutation maxT for Multiple Testing
#'
#' Performs permutation-based multiple testing correction using the maxT method.
#' Controls family-wise error rate (FWER) while testing multiple hypotheses.
#'
#' @param data_matrix numeric matrix of dimensions (n x p) where n = number of
#'   observations (samples), p = number of variables (features/genes/voxels).
#'   Rows are observations, columns are variables. No NAs allowed; remove or
#'   impute before calling. Example: gene expression matrix with n = 50 samples,
#'   p = 10000 genes.
#' @param groups factor or vector of group labels (length n). Should have exactly
#'   2 unique levels representing group membership. Numeric (0/1) or character
#'   ("control"/"treatment") both acceptable. Order corresponds to data_matrix rows.
#' @param R integer number of permutation replicates (default 2000).
#'   Larger values (5000-10000) recommended for stable p-values.
#'   Computational cost scales linearly with R. Must be >= 1.
#'
#' @return A list with two elements:
#'   \item{obs}{numeric vector of length p, observed t-statistics for each variable.
#'     Positive/negative values indicate direction of difference. Names preserved
#'     from column names of data_matrix if present.}
#'   \item{p.values}{numeric vector of length p, FWER-adjusted p-values.
#'     Computed as proportion of permutation replicates where
#'     max(|t_permuted|) >= |t_observed|. Controls family-wise error rate at level
#'     approximately R/(R+1). Values automatically sorted to match obs vector.}
#'
#' @details
#' The maxT method conducts individual t-tests for each variable, then corrects
#' for multiple comparisons using the distribution of the maximum absolute t-statistic
#' under permutation. This maintains FWER at the specified level while preserving power.
#'
#' @examples
#' set.seed(42)
#' data <- matrix(rnorm(200), nrow = 50, ncol = 4)
#' groups <- rep(0:1, each = 25)
#' result <- perm_maxT(data, groups, R = 500)
#' result$p.values
#'
#' @export
perm_maxT <- function(data_matrix, groups, R = 2000) {
  if (!is.matrix(data_matrix)) {
    stop("data_matrix must be a numeric matrix", call. = FALSE)
  }

  n <- nrow(data_matrix)
  p <- ncol(data_matrix)

  if (length(groups) != n) {
    stop(sprintf("groups length (%d) must equal nrow(data_matrix) (%d)", length(groups), n),
         call. = FALSE)
  }

  stopifnot(
    is.numeric(R), R >= 1, R == as.integer(R)
  )

  # Compute observed t-statistics
  obs_stats <- apply(data_matrix, 2, function(col) {
    tryCatch(
      stats::t.test(col ~ groups)$statistic,
      error = function(e) 0
    )
  })

  # Permutation replicates
  reps <- future.apply::future_sapply(seq_len(R), function(i) {
    # Permute group labels
    groups_perm <- .safe_sample(groups)
    # Compute t-statistics for permuted data
    apply(data_matrix, 2, function(col) {
      tryCatch(
        stats::t.test(col ~ groups_perm)$statistic,
        error = function(e) 0
      )
    })
  }, future.seed = TRUE)

  # Dimension: p x R (variables x permutations)
  if (R == 1) {
    reps <- matrix(reps, nrow = p, ncol = 1)
  } else {
    reps <- t(reps)
  }

  # Compute max absolute t-stat for each permutation
  max_abs_t <- apply(abs(reps), 2, max)

  # FWER-adjusted p-value: Pr(max|T| >= |T_obs|)
  pvals <- sapply(seq_len(p), function(j) {
    mean(max_abs_t >= abs(obs_stats[j]))
  })

  list(
    obs = obs_stats,
    p.values = pvals
  )
}
