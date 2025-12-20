# File: tests/testthat/test_time_series.R

test_that("moving_block_boot works with basic time series", {
  skip_if_not_installed("stats")
  
  set.seed(42)
  x <- arima.sim(n = 100, list(ar = 0.7))
  result <- moving_block_boot(x, block_size = 10, R = 50)
  
  expect_length(result, 50)
  expect_true(all(sapply(result, length) == 100))
  expect_true(all(sapply(result, is.numeric)))
})

test_that("moving_block_boot validates parameters", {
  x <- rnorm(50)
  
  expect_error(
    moving_block_boot(x, block_size = 100, R = 10),
    "block_size.*cannot exceed"
  )
  
  expect_error(
    moving_block_boot(c(1), block_size = 1, R = 10),
    "must be a numeric vector with at least 2 elements"
  )
})

test_that("moving_block_boot preserves block structure", {
  set.seed(42)
  x <- 1:100
  result <- moving_block_boot(x, block_size = 5, R = 1)
  
  expect_length(result[[1]], 100)
  expect_true(is.numeric(result[[1]]))
})
