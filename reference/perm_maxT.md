# Permutation maxT for Multiple Testing

Performs permutation-based multiple testing correction using the maxT
method. Controls family-wise error rate (FWER) while testing multiple
hypotheses.

## Usage

``` r
perm_maxT(data_matrix, groups, R = 2000)
```

## Arguments

- data_matrix:

  numeric matrix of dimensions (n x p) where n = number of observations
  (samples), p = number of variables (features/genes/voxels). Rows are
  observations, columns are variables. No NAs allowed; remove or impute
  before calling. Example: gene expression matrix with n = 50 samples, p
  = 10000 genes.

- groups:

  factor or vector of group labels (length n). Should have exactly 2
  unique levels representing group membership. Numeric (0/1) or
  character ("control"/"treatment") both acceptable. Order corresponds
  to data_matrix rows.

- R:

  integer number of permutation replicates (default 2000). Larger values
  (5000-10000) recommended for stable p-values. Computational cost
  scales linearly with R. Must be \>= 1.

## Value

A list with two elements:

- obs:

  numeric vector of length p, observed t-statistics for each variable.
  Positive/negative values indicate direction of difference. Names
  preserved from column names of data_matrix if present.

- p.values:

  numeric vector of length p, FWER-adjusted p-values. Computed as
  proportion of permutation replicates where max(\|t_permuted\|) \>=
  \|t_observed\|. Controls family-wise error rate at level approximately
  R/(R+1). Values automatically sorted to match obs vector.

## Details

The maxT method conducts individual t-tests for each variable, then
corrects for multiple comparisons using the distribution of the maximum
absolute t-statistic under permutation. This maintains FWER at the
specified level while preserving power.

## Examples

``` r
set.seed(42)
data <- matrix(rnorm(200), nrow = 50, ncol = 4)
groups <- rep(0:1, each = 25)
result <- perm_maxT(data, groups, R = 500)
result$p.values
#> [1] 1 1 1 1
```
