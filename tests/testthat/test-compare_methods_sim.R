test_that("compare_methods_sim returns list of correct length", {
  set.seed(42)
  gen <- function() rnorm(50, mean = 5)
  result <- compare_methods_sim(gen, Rsim = 10, Rboot = 200, parallel = FALSE)

  expect_type(result, "list")
  expect_length(result, 10)
})

test_that("compare_methods_sim each element has bs and bca", {
  set.seed(42)
  gen <- function() rnorm(50)
  result <- compare_methods_sim(gen, Rsim = 5, Rboot = 100, parallel = FALSE)

  expect_true(all(sapply(result, function(x) "bs" %in% names(x))))
  expect_true(all(sapply(result, function(x) "bca" %in% names(x))))
})

test_that("compare_methods_sim validates data_generator", {
  expect_error(compare_methods_sim("not a function"))
  expect_error(compare_methods_sim(function() 5, Rsim = -1))
})

test_that("compare_methods_sim handles errors gracefully", {
  set.seed(42)
  # Generator that sometimes fails
  gen <- function() {
    if (runif(1) < 0.5) stop("Error")
    rnorm(50)
  }

  result <- compare_methods_sim(gen, Rsim = 5, Rboot = 100, parallel = FALSE)

  expect_length(result, 5)
})
