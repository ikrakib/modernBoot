test_that("moving_block_boot returns correct structure", {
  set.seed(42)
  x <- rnorm(100)
  result <- moving_block_boot(x, block_size = 10, R = 50)

  expect_type(result, "list")
  expect_length(result, 50)
  expect_true(all(sapply(result, length) == 100))
})

test_that("moving_block_boot preserves length", {
  set.seed(42)
  x <- rnorm(200)
  result <- moving_block_boot(x, block_size = 15, R = 30)

  expect_true(all(sapply(result, length) == length(x)))
})

test_that("moving_block_boot validates inputs", {
  x <- rnorm(50)
  expect_error(moving_block_boot(c("a", "b")))
  expect_error(moving_block_boot(5))
  expect_error(moving_block_boot(x, block_size = 100))  # block > n
  expect_error(moving_block_boot(x, R = -1))
})

test_that("moving_block_boot works on time series", {
  set.seed(42)
  ts_data <- arima.sim(n = 100, list(ar = 0.7))
  result <- moving_block_boot(as.numeric(ts_data), block_size = 10, R = 50)

  expect_length(result, 50)
})

test_that("moving_block_boot handles different block sizes", {
  set.seed(42)
  x <- rnorm(200)
  result_small <- moving_block_boot(x, block_size = 5, R = 20)
  result_large <- moving_block_boot(x, block_size = 50, R = 20)

  expect_equal(sapply(result_small, length), sapply(result_large, length))
})
