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

test_that("compare_methods_sim works with sequential processing", {
  set.seed(42)
  gen <- function() rnorm(20)
  
  result <- compare_methods_sim(gen, Rsim = 2, Rboot = 50, parallel = FALSE)
  
  expect_length(result, 2)
  expect_is(result[[1]], "list")
})

test_that("compare_methods_sim handles small simulations", {
  set.seed(42)
  gen <- function() rnorm(15)
  
  result <- compare_methods_sim(gen, Rsim = 1, Rboot = 25, parallel = FALSE)
  
  expect_length(result, 1)
})
