context("get_arguments")
 
test_that("The get_arguments function basics work as expected", {  
  contains <- function(expected) {
    function(x) {
      expectation(
        isTRUE(all(expected %in% x)),
        paste("doesn't contain:",expected)
      )
    }
  }
  
  expect_that(get_arguments("nonexistent",code = ""), is_false())
  expect_that(names(get_arguments("plot", code = "plot(1:10,col='blue')")[[1]]), contains(c("x","col")))
  expect_that(get_arguments("plot", code = "plot(1:10,col='blue')")[[1]], contains(c("1:10","blue")))
  expect_that(names(get_arguments("hist", code = "hist(rnorm(10),breaks=50)")[[1]]), contains(c("x","breaks")))
  expect_that(get_arguments("hist", code = "hist(rnorm(10),breaks=50)")[[1]], contains(c("rnorm(10)","50")))
})