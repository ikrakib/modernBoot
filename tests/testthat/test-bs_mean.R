test_that("bs_mean returns list with correct structure", {
  set.seed(42)
  x <- rnorm(50, mean = 5, sd = 2)
  result <- bs_mean(x, R = 200)

  expect_type(result, "list")
  expect_named(result, c("stat", "boot", "ci"))
  expect_type(result$stat, "double")
  expect_type(result$boot, "double")
  expect_type(result$ci, "double")
  expect_length(result$boot, 200)
  expect_length(result$ci, 2)
})

test_that("bs_mean produces reasonable CI", {
  set.seed(42)
  x <- rnorm(100, mean = 10, sd = 1)
  result <- bs_mean(x, R = 500, conf = 0.95)

  # True mean should fall in CI
  expect_true(result$ci[1] <= mean(x) && mean(x) <= result$ci[2])
  # CI should be reasonably narrow
  expect_true(result$ci[2] - result$ci[1] < 1)
})

test_that("bs_mean validates inputs", {
  expect_error(bs_mean(c("a", "b")))
  expect_error(bs_mean(5))  # only 1 observation
  expect_error(bs_mean(rnorm(10), R = -1))
  expect_error(bs_mean(rnorm(10), conf = 1.5))
})

test_that("bs_mean respects different confidence levels", {
  set.seed(42)
  x <- rnorm(50)
  result_90 <- bs_mean(x, R = 500, conf = 0.90)
  result_99 <- bs_mean(x, R = 500, conf = 0.99)

  # Wider conf level should give wider interval
  width_90 <- result_90$ci[2] - result_90$ci[1]
  width_99 <- result_99$ci[2] - result_99$ci[1]
  expect_true(width_99 > width_90)
})

test_that("bs_mean handles NAs (with na.rm)", {
  set.seed(42)
  x <- c(rnorm(40), NA, NA, NA)
  result <- bs_mean(x, R = 200)

  expect_false(is.na(result$stat))
  expect_true(all(!is.na(result$boot)))
})
