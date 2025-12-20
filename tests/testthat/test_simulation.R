# File: tests/testthat/test_simulation.R
# IMPORTANT: Expensive tests skip on CI to prevent timeouts

test_that("compare_methods_sim runs with minimal settings", {
  skip_on_cran()
  skip_on_ci()
  
  set.seed(42)
  gen <- function() rnorm(20)
  result <- compare_methods_sim(gen, Rsim = 2, Rboot = 50, parallel = FALSE)
  
  expect_length(result, 2)
  expect_is(result[[1]], "list")
})

test_that("compare_methods_sim validates inputs", {
  expect_error(
    compare_methods_sim(not_a_function, Rsim = 5),
    "data_generator must be a function"
  )
  
  expect_error(
    compare_methods_sim(function() rnorm(10), Rsim = 0),
    "Rsim"
  )
})

test_that("compare_methods_sim handles generator failures gracefully", {
  skip_on_cran()
  skip_on_ci()
  
  set.seed(42)
  bad_gen <- function() stop("Intentional error")
  result <- compare_methods_sim(bad_gen, Rsim = 2, Rboot = 50, parallel = FALSE)
  
  expect_length(result, 2)
  expect_true(is.na(result[[1]]$bs) || is.list(result[[1]]$bs))
})

test_that("compare_methods_sim with sequential (no parallel)", {
  skip_on_cran()
  skip_on_ci()
  
  set.seed(42)
  gen <- function() rnorm(20)
  result <- compare_methods_sim(gen, Rsim = 2, Rboot = 50, parallel = FALSE)
  
  expect_length(result, 2)
})
