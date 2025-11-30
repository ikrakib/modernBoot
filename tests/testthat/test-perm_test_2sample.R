test_that("perm_test_2sample returns list with correct structure", {
  set.seed(42)
  x <- rnorm(30, mean = 0)
  y <- rnorm(30, mean = 0.5)

  result <- perm_test_2sample(x, y, R = 200)

  expect_type(result, "list")
  expect_named(result, c("obs", "reps", "p.value"))
  expect_type(result$obs, "double")
  expect_type(result$reps, "double")
  expect_type(result$p.value, "double")
  expect_length(result$reps, 200)
})

test_that("perm_test_2sample p-value is valid", {
  set.seed(42)
  x <- rnorm(30, mean = 0)
  y <- rnorm(30, mean = 0)

  result <- perm_test_2sample(x, y, R = 500)

  expect_true(result$p.value >= 0 && result$p.value <= 1)
})

test_that("perm_test_2sample detects difference", {
  set.seed(42)
  x <- rnorm(50, mean = 0)
  y <- rnorm(50, mean = 2)  # Clear difference

  result <- perm_test_2sample(x, y, R = 1000)

  # p-value should be small
  expect_true(result$p.value < 0.1)
})

test_that("perm_test_2sample validates inputs", {
  x <- rnorm(30)
  y <- rnorm(30)

  expect_error(perm_test_2sample(c("a"), y))
  expect_error(perm_test_2sample(x, 5))  # y too short
  expect_error(perm_test_2sample(x, y, R = -1))
})

test_that("perm_test_2sample works with custom statistic", {
  set.seed(42)
  x <- rnorm(20)
  y <- rnorm(20)

  custom_stat <- function(a, b) median(a) - median(b)
  result <- perm_test_2sample(x, y, R = 200, stat = custom_stat)
  expect_type(result$obs, "double")
  expect_true(result$p.value >= 0 && result$p.value <= 1)
})
