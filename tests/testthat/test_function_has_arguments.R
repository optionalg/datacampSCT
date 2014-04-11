context("Function_has_arguments checks:")

# TODO
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/evals.RData"))
DM.user.code = "plot(evals$score,jitter(evals$bty_avg));"
function_has_arguments('plot', c('x', 'y'), c('evals$score', 'jitter(evals$bty_avg)'), c(T,F))
# TODO 2
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/atheism.RData"))
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/dasi/inference.Rdata"))
DM_india_subset = subset(atheism, atheism$nationality == "India" & atheism$year =="2012")

DM.user.code = 'inference(india$response, est = "proportion", type = "ci", method = "theoretical", success = "atheist");
inference(india$response, est = "proportion", method = "theoretical", type = "ci", success = "atheist");
inference(india$response, est = "proportion", type = "ci", success = "atheist", method = "theoretical")'
india = subset(atheism, atheism$nationality == "India" & atheism$year =="2012")
function_has_arguments('inference', c('y', 'est', 'type', 'method', 'success'), c('india$response', 'proportion', 'ci', 'theoretical', 'atheist'), c(TRUE,FALSE,FALSE,FALSE,FALSE))

test_that("when student submits incorrect code function_has_arguments returns false", {
  code_with_error = "mean(x);plot(xasdfasb,a;mean(x)";
  
  expect_that(function_has_arguments("plot",code=code_with_error), is_false())
  expect_that(function_has_arguments("plot","x",code=code_with_error), is_false())
  expect_that(function_has_arguments("mean","x",code=code_with_error), is_false())
  expect_that(function_has_arguments("plot",code=code_with_error),is_false())
})

test_that("when you ask for the function only, it returns number of appearances", {
  code1 = "x=1:10;mean(x);plot(x);mean(x);hist(mean(rnorm(100)))";
  
  expect_that(function_has_arguments("plot",code=code1), equals(1))
  expect_that(function_has_arguments("mean","x",code=code1), equals(3))
  expect_that(function_has_arguments("hist","x",code=code1), equals(1))
  expect_that(function_has_arguments("rnorm",code=code1),equals(1))
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

x = y = 1:10; 
my_test=label="test";
code3 = "plot(1:20,pch=16,xlab=label,ylab='saywhat');plot(x);plot(x~y);mean(x);hist(mean(1:10))"; 

test_that("you specify the arguments of a function explicitly with evaluation", { 
  
  expect_that(function_has_arguments("plot","x","1:10",eval=TRUE,code=code3), equals(1));
  expect_that(function_has_arguments("mean","x","1:10",eval=TRUE,code=code3), equals(2));  
  expect_that(function_has_arguments("plot","xlab","my_test",eval=TRUE,code=code3), equals(1));
  
  expect_that(function_has_arguments("plot",c("xlab","x",'ylab'),c("my_test","1:20","saywhat"),eval=c(T,T,F),code=code3), equals(1));
  expect_that(function_has_arguments("hist","x","mean(1:10)",eval=T,code=code3), equals(1));
})