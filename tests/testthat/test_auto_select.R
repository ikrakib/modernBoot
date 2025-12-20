test_that("auto_select_method detects IID data", {
  x <- rnorm(50)
  result <- auto_select_method(x)
  
  expect_equal(result$method, "nonparametric_boot")
  expect_true(is.character(result$rationale))
})

test_that("auto_select_method detects time series", {
  set.seed(42)
  ts_data <- ts(rnorm(50), frequency = 12)
  result <- auto_select_method(ts_data)
  
  expect_equal(result$method, "block_boot")
  expect_true(is.character(result$rationale))
})

test_that("auto_select_method detects clustering", {
  x <- rnorm(50)
  cluster <- rep(1:5, each = 10)
  result <- auto_select_method(x, cluster = cluster)
  
  expect_equal(result$method, "clustered_boot")
  expect_true(is.character(result$rationale))
})

test_that("auto_select_method detects multivariate data", {
  mat <- matrix(rnorm(100), nrow = 50, ncol = 2)
  result <- auto_select_method(mat)
  
  expect_equal(result$method, "perm_maxT")
  expect_true(is.character(result$rationale))
})

test_that("auto_select_method validates cluster length", {
  x <- rnorm(50)
  bad_cluster <- 1:10
  
  expect_error(
    auto_select_method(x, cluster = bad_cluster),
    "cluster"
  )
})
