test_that("stationary_boot returns correct structure", {
  set.seed(42)
  x <- rnorm(100)
  result <- stationary_boot(x, p = 0.1, R = 50)

  expect_type(result, "list")
  expect_length(result, 50)
  expect_true(all(sapply(result, length) == 100))
})

test_that("stationary_boot preserves length", {
  set.seed(42)
  x <- rnorm(200)
  result <- stationary_boot(x, p = 0.1, R = 30)

  expect_true(all(sapply(result, length) == length(x)))
})

test_that("stationary_boot validates p parameter", {
  x <- rnorm(50)
  expect_error(stationary_boot(x, p = 0))     # p must be > 0
  expect_error(stationary_boot(x, p = 1.5))   # p must be <= 1
})

test_that("stationary_boot handles different p values", {
  set.seed(42)
  x <- rnorm(100)
  result_p01 <- stationary_boot(x, p = 0.1, R = 50)
  result_p02 <- stationary_boot(x, p = 0.2, R = 50)

  expect_equal(sapply(result_p01, length), sapply(result_p02, length))
})

test_that("stationary_boot works on time series", {
  set.seed(42)
  ts_data <- arima.sim(n = 100, list(ar = 0.8))
  result <- stationary_boot(as.numeric(ts_data), p = 0.1, R = 50)

  expect_length(result, 50)
})
