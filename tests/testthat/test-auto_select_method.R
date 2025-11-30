test_that("auto_select_method detects IID data", {
  x <- rnorm(50)
  result <- auto_select_method(x)

  expect_named(result, c("method", "rationale"))
  expect_equal(result$method, "nonparametric_boot")
  expect_type(result$rationale, "character")
})

test_that("auto_select_method detects time series", {
  ts_data <- arima.sim(n = 100, list(ar = 0.7))
  result <- auto_select_method(ts_data)

  expect_equal(result$method, "block_boot")
})

test_that("auto_select_method detects multivariate data", {
  data <- matrix(rnorm(200), nrow = 50, ncol = 4)
  result <- auto_select_method(data)

  expect_equal(result$method, "perm_maxT")
})

test_that("auto_select_method detects clusters", {
  x <- rnorm(50)
  clusters <- rep(1:5, each = 10)
  result <- auto_select_method(x, cluster = clusters)

  expect_equal(result$method, "clustered_boot")
})

test_that("auto_select_method validates cluster length", {
  x <- rnorm(50)
  clusters <- rep(1:5, 9)  # Wrong length

  expect_error(auto_select_method(x, cluster = clusters))
})
