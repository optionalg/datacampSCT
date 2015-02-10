context("function_has_arguments")

test_that("when student submits incorrect code function_has_arguments returns false", {
  code_with_error = "mean(x);plot(xasdfasb,a;mean(x)"
  
  expect_that(function_has_arguments("plot", "x",code = code_with_error), is_false())
  expect_that(function_has_arguments("mean", "x",code = code_with_error), is_false())
  expect_that(function_has_arguments("plot", code = code_with_error), is_false())
})


test_that("when you ask for the function only, it returns number of appearances", {
 code1 = "x=1:10;mean(x);plot(x);mean(x);hist(mean(rnorm(100)))" 
 a = function_has_arguments("plot",code=code1)
 expect_that(a, is_equivalent_to(1L))
 expect_that(function_has_arguments("mean","x",code=code1), is_equivalent_to(3L))
 expect_that(function_has_arguments("hist","x",code=code1), is_equivalent_to(1L))
 expect_that(function_has_arguments("rnorm",code=code1), is_equivalent_to(1L))
 expect_that(1,equals(1))
 expect_that(3,equals(3))
 expect_that(4,equals(4))  
})

test_that("when you check the existence of arguments in a function, it returns them correctly", {
  x = y = 1:10;
  code2 = "plot(rnorm(10),pch=16,xlab='test',ylab='saywhat');plot(rnorm(100));plot(x~y);mean(x);hist(mean(rnorm(100)))";
  
  expect_that(function_has_arguments("plot","x",code=code2), equals(3))
  expect_that(function_has_arguments("plot",c("x","xlab"),code=code2), equals(1))
  expect_that(function_has_arguments("mean","x",code=code2), equals(2))
  expect_that(function_has_arguments("hist","x",code=code2), equals(1))    
  expect_that(function_has_arguments("rnorm","n",code=code2),equals(3))
  
  expect_that(function_has_arguments("rnorm",c("n","x"),code=code2),equals(0))
  expect_that(function_has_arguments("plot",c("x","pch","y"),code=code2),equals(0))
  expect_that(function_has_arguments("mean",c("x","trim"),code=code2),equals(0))
})


test_that("you specify the arguments of a function explicitly without evaluation", {
  code2 = "plot(rnorm(10),pch=16,xlab='test',ylab='saywhat');plot(rnorm(100));plot(x~y);mean(x);hist(mean(rnorm(100)))";  
  x = y = 1:10;
  
  expect_that(function_has_arguments("plot","x","rnorm(100)",code=code2), equals(1))
  expect_that(function_has_arguments("plot","x","x ~ y",code=code2), equals(1))
  expect_that(function_has_arguments("plot","x","rnorm(10)",code=code2), equals(1))
  
  expect_that(function_has_arguments("plot",c("x","pch","xlab"),c("rnorm(10)","16","test"),code=code2), equals(1))
  expect_that(function_has_arguments("plot",c("x","pch","xlab","ylab"),c("rnorm(10)","16","test","saywhat"),code=code2), equals(1))  
  expect_that(function_has_arguments("hist","x","mean(rnorm(100))",code=code2), equals(1))  

  expect_that(function_has_arguments("plot",c("x","pch","xlab"),c("rnorm(10)","16","bla"),code=code2), equals(0))    
  expect_that(function_has_arguments("plot",c("x","pch","zlab"),c("rnorm(10)","16","bla"),code=code2), equals(0))    
  
  expect_that(function_has_arguments("hist",c("x","z"),"mean(rnorm(100))",code=code2), throws_error())    
})

test_that("Correct handling of TRUE, T and FALSE, F", {
  x = 1:10
  code4 = "hist(x, right = TRUE)"
  code5 = "hist(x, right = T)"
  expect_that(function_has_arguments("hist", "right", "T", eval=TRUE, code = code4), equals(1))
  expect_that(function_has_arguments("hist", "right", "TRUE", eval=TRUE, code = code5), equals(1))  
})
