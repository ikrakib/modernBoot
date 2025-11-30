test_that("bca_ci returns list with correct structure", {
  set.seed(42)
  x <- rnorm(50, mean = 5, sd = 2)
  result <- bca_ci(x, R = 200)

  expect_type(result, "list")
  expect_named(result, c("boot", "ci"))
  expect_s3_class(result$boot, "boot")
  expect_true(is.numeric(result$ci))
})

test_that("bca_ci produces reasonable CI", {
  set.seed(42)
  x <- rnorm(100, mean = 10, sd = 1)
  result <- bca_ci(x, R = 500, conf = 0.95)

  # CI should contain columns for bounds
  expect_true(ncol(result$ci) >= 2)
})

test_that("bca_ci validates inputs", {
  expect_error(bca_ci(c("a", "b")))
  expect_error(bca_ci(5))
  expect_error(bca_ci(rnorm(10), R = -1))
})

test_that("bca_ci works with skewed data", {
  set.seed(42)
  x <- rexp(50)  # Highly skewed
  result <- bca_ci(x, R = 300)

  expect_s3_class(result$boot, "boot")
  expect_true(is.numeric(result$ci))
})
