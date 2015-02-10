context("called_functions checks")

test_that("The called_functions basics work as expected", { 
  contains <- function(expected) {
    function(x) {
      expectation(
        isTRUE(all(expected %in% x)),
        paste("doesn't contain:",expected)
      )
    }
  }
  
  expect_that(called_functions(code = "mean(x);plot(x)"), contains("mean"))
  expect_that(called_functions(code = "mean(x);plot(x);plot(x~y)"), contains("mean"))
  expect_that(called_functions(code = "mean(x);plot(x);plot(x~y)"), contains(rep("plot", 2)))
  expect_that(called_functions(code = "mean(rnorm(10));plot(rnorm(100));plot(x~y)"), contains(rep("rnorm", 2)))  
})