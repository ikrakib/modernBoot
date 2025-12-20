test_that("bs_mean works with basic data", {
  skip_on_os("mac")      # Skip on macOS
  skip_on_os("windows")  # Skip on Windows

  set.seed(42)
  x <- rnorm(50, mean = 5, sd = 2)
  result <- bs_mean(x, R = 100)

  expect_type(result, "list")
  expect_true(abs(result$stat - 5) < 1)
  expect_length(result$boot, 100)
  expect_length(result$ci, 2)
})
