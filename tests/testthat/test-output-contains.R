context("output_contains")

test_that("output_contains basics work as expected", {  
  DM.user.code = "n=10;for(i in 1:n){print(i)};"
  assign("DM.console.output", paste(capture.output(eval(parse(text=DM.user.code))), collapse=""), envir = globalenv())
  
  expect_that(output_contains("for(i in 1:10){print(i)}"), is_true())
})