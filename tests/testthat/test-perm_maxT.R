test_that("perm_maxT returns list with correct structure", {
  set.seed(42)
  data <- matrix(rnorm(200), nrow = 50, ncol = 4)
  groups <- rep(0:1, each = 25)

  result <- perm_maxT(data, groups, R = 100)

  expect_type(result, "list")
  expect_named(result, c("obs", "p.values"))
  expect_length(result$obs, 4)
  expect_length(result$p.values, 4)
})

test_that("perm_maxT p-values are valid", {
  set.seed(42)
  data <- matrix(rnorm(200), nrow = 50, ncol = 4)
  groups <- rep(0:1, each = 25)

  result <- perm_maxT(data, groups, R = 200)

  expect_true(all(result$p.values >= 0 & result$p.values <= 1))
})

test_that("perm_maxT detects difference in variables", {
  set.seed(42)
  # Create data with difference in variable 2
  data <- matrix(rnorm(200), nrow = 50, ncol = 4)
  data[1:25, 2] <- data[1:25, 2] + 2  # Group difference in var 2
  groups <- rep(0:1, each = 25)

  result <- perm_maxT(data, groups, R = 500)

  # p-value for var 2 should be smallest
  expect_true(result$p.values[2] < max(result$p.values[-2]))
})

test_that("perm_maxT validates inputs", {
  data <- matrix(rnorm(200), nrow = 50, ncol = 4)
  groups <- rep(0:1, each = 25)

  expect_error(perm_maxT(as.data.frame(data), groups))  # Not matrix
  expect_error(perm_maxT(data, rep(0:1, 10)))  # Wrong group length
})
