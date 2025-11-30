#' Automatic Resampling Method Selection
#'
#' Inspects data structure and recommends an appropriate resampling method.
#'
#' @importFrom stats is.ts
#'
#' @param data numeric vector, matrix, or time series object representing data
#'   to analyze. For vectors: univariate sample. For matrices/data.frames:
#'   multivariate data with rows=observations, columns=variables.
#'   For ts objects: automatically detected as time series.
#' @param cluster optional vector of cluster IDs (integer or factor).
#'   Length must equal nrow(data) for matrices or length(data) for vectors.
#'   Identifies hierarchical grouping (e.g., repeated measures within subjects,
#'   multiple samples from same source). If NULL (default), clustering is not
#'   considered. If provided, triggers clustered bootstrap recommendation.
#'
#' @return A list with two character string elements:
#'   \item{method}{recommended resampling method name. Values:
#'     "clustered_boot" (if cluster provided),
#'     "block_boot" (if time series detected),
#'     "perm_maxT" (if multivariate matrix detected),
#'     "nonparametric_boot" (default for IID univariate data)}
#'   \item{rationale}{human-readable explanation of recommendation.
#'     Describes why chosen method is appropriate and what structure
#'     the data exhibits.}
#'
#' @details
#' Decision logic:
#' - If clusters provided: use clustered bootstrap
#' - If time series detected: use block or stationary bootstrap
#' - If multivariate matrix: use permutation maxT
#' - Otherwise (IID data): use standard nonparametric bootstrap
#'
#' @examples
#' # IID data
#' x <- rnorm(50)
#' auto_select_method(x)
#'
#' # Time series
#' ts_data <- arima.sim(n = 100, list(ar = 0.7))
#' auto_select_method(ts_data)
#'
#' @export
auto_select_method <- function(data, cluster = NULL) {
  # Check for clustering
  if (!is.null(cluster)) {
    if (length(cluster) != length(data) && length(cluster) != nrow(data)) {
      stop("cluster length must match data length/rows", call. = FALSE)
    }
    return(list(
      method = "clustered_boot",
      rationale = "Clusters detected; use cluster-aware resampling to preserve cluster structure."
    ))
  }

  # Check for time series
  is_ts <- is.ts(data) || inherits(data, "xts") || inherits(data, "zoo")

  if (is_ts) {
    return(list(
      method = "block_boot",
      rationale = "Time series structure detected; use block or stationary bootstrap to preserve temporal dependence."
    ))
  }

  # Check for multivariate data
  if (is.matrix(data) || is.data.frame(data)) {
    return(list(
      method = "perm_maxT",
      rationale = "Multivariate data detected; use permutation maxT for multiple hypothesis testing with FWER control."
    ))
  }

  # Default: IID univariate data
  list(
    method = "nonparametric_boot",
    rationale = "IID univariate data detected; use standard nonparametric bootstrap (bs_mean, bca_ci, etc.)."
  )
}
