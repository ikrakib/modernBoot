test_that("wild_boot_lm returns list with correct structure", {
  set.seed(42)
  x <- rnorm(50)
  y <- 2 + 1.5 * x + rnorm(50)
  fit <- lm(y ~ x)

  result <- wild_boot_lm(fit, R = 100, type = "rademacher")

  expect_type(result, "list")
  expect_named(result, c("coef", "boot"))
  expect_length(result$coef, 2)
  expect_equal(nrow(result$boot), 2)
  expect_equal(ncol(result$boot), 100)
})

test_that("wild_boot_lm handles both weight schemes", {
  set.seed(42)
  x <- rnorm(50)
  y <- 2 + 1.5 * x + rnorm(50, sd = abs(x))  # heteroscedastic
  fit <- lm(y ~ x)

  result_rad <- wild_boot_lm(fit, R = 100, type = "rademacher")
  result_mam <- wild_boot_lm(fit, R = 100, type = "mammen")

  expect_equal(nrow(result_rad$boot), nrow(result_mam$boot))
  expect_equal(ncol(result_rad$boot), ncol(result_mam$boot))
})

test_that("wild_boot_lm validates inputs", {
  expect_error(wild_boot_lm("not a model"))
  expect_error(wild_boot_lm(lm(rnorm(10) ~ 1), R = -1))
})

test_that("wild_boot_lm coefficient matches original fit", {
  set.seed(42)
  x <- rnorm(50)
  y <- 2 + 1.5 * x + rnorm(50)
  fit <- lm(y ~ x)

  result <- wild_boot_lm(fit, R = 100)

  expect_equal(result$coef, coef(fit))
})
