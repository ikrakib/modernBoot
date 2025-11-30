test_that("studentized_ci returns numeric vector of length 2", {
  set.seed(42)
  x <- rexp(50)
  result <- studentized_ci(x, q = 0.5, R = 100, Rinner = 50)

  expect_type(result, "double")
  expect_length(result, 2)
  expect_named(result, c("lower", "upper"))
  expect_true(result[1] < result[2])
})

test_that("studentized_ci validates quantile parameter", {
  x <- rnorm(50)

  expect_error(studentized_ci(x, q = 0))
  expect_error(studentized_ci(x, q = 1))
  expect_error(studentized_ci(x, q = 1.5))
})

test_that("studentized_ci works for different quantiles", {
  set.seed(42)
  x <- rexp(50)

  ci_median <- studentized_ci(x, q = 0.5, R = 100, Rinner = 50)
  ci_q75 <- studentized_ci(x, q = 0.75, R = 100, Rinner = 50)

  # Different quantiles should give different intervals
  expect_false(isTRUE(all.equal(ci_median, ci_q75)))
})

test_that("studentized_ci validates inputs", {
  expect_error(studentized_ci(c("a", "b")))
  expect_error(studentized_ci(5))
  expect_error(studentized_ci(rnorm(10), R = -1))
})
