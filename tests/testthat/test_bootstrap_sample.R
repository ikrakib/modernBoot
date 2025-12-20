# File: tests/testthat/test_bootstrap_sample.R

test_that("bs_mean works with basic data", {
  set.seed(42)
  x <- rnorm(50, mean = 5, sd = 2)
  result <- bs_mean(x, R = 100)
  
  expect_is(result, "list")
  expect_true(abs(result$stat - 5) < 1)
  expect_length(result$boot, 100)
  expect_length(result$ci, 2)
})

test_that("bs_mean validates input", {
  expect_error(bs_mean(c(1)), "must be a numeric vector with at least 2 elements")
  expect_error(bs_mean("not numeric"), "must be a numeric vector")
})

test_that("bca_ci works with basic data", {
  set.seed(42)
  x <- rnorm(50, mean = 5, sd = 2)
  result <- bca_ci(x, R = 100)
  
  expect_is(result, "list")
  expect_true(all(is.finite(result$ci)))
  expect_length(result$ci, 4)
})

test_that("bca_ci validates input", {
  expect_error(bca_ci(c(1)), "must be a numeric vector with at least 2 elements")
})
