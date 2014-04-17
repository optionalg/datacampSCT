context("student_typed checks")

test_that("The student typed function basics work as expected", {  
  expect_that(student_typed("abc", code = "def"), is_false())
  expect_that(student_typed("t", code = "t"), equals(1))
  expect_that(student_typed("abc", code="abc;abc;abc"), equals(3))
})

test_that("It ignores white spaces", {  
  expect_that(student_typed("plot(x, col='blue')", code = "plot(x,col='blue')"), equals(1))
  expect_that(student_typed("mean(x)", code = "mean( x )"), equals(1))
})

test_that("It ignores whether student used = or <- for assignment", {  
  expect_that(student_typed("x=5", code = "x<-5"), equals(1))
  expect_that(student_typed("x<-5", code = "x=5"), equals(1))
})

test_that("It ignores whether student used T/F or TRUE/FALSE as booleans", {  
  expect_that(student_typed("the_truth = TRUE", code = "the_truth = T"), equals(1))
  expect_that(student_typed("the_truth = T", code = "the_truth = TRUE"), equals(1))
})

test_that("It ignores whether student used T/F or TRUE/FALSE as booleans", {  
  expect_that(student_typed("the_truth = TRUE", code = "the_truth = T"), equals(1))
  expect_that(student_typed("the_truth = T", code = "the_truth = TRUE"), equals(1))
  expect_that(student_typed("a_lie = FALSE", code = "a_lie = F"), equals(1))
  expect_that(student_typed("a_lie = F", code = "a_lie = FALSE"), equals(1))
  expect_that(student_typed("FALSE", code = "TRUE"), is_false())  
})

test_that("It ignores whether it ignores ; and newlines", {  
  expect_that(student_typed("a;b;c", code = "abc"), equals(1))
  expect_that(student_typed("a;\nb;\nc", code = "abc"), equals(1))
  expect_that(student_typed("abc", code = "abc;\nabc;\nabc"), equals(3))  
})
