#' Check whether the student printed something to the console
#' 
#' Function checks whether the student's console contains the output one gets by evaluating the character provided to \code{expr}.
#' It returns \code{TRUE} when the student's console indeed contains the expected output and \code{FALSE} otherwise.
#' 
#'  @param expr The expression (as string) for which the output should be in the student's console.
#'  @param console_output The string containing the output printed to the student's console. 
#'  The default is \code{DM.console.output} which is set on the DataCamp server (automagically).
#'  This means you don't have to specify this argument when writing SCTs for DataCamp.com.
#'      
#'  @examples
#'  # Suppose the student has to write a loop that prints the numbers 1 up to 10.
#'  # A smart student does exactly that and thus submits the code assigned to DM.user.code: 
#'  DM.user.code = "n=10;for(i in 1:n){print(i)};"
#'  # What student's console contains:
#'  DM.console.output = paste(capture.output(eval(parse(text=DM.user.code))), collapse="")
#'  # What the test tells us:
#'  output_contains("for(i in 1:10){print(i)}")
#'  # Suppose the student was supposed to loop upto 20:
#'  output_contains("for(i in 1:20){print(i)}")
#'  
#'  @export
output_contains = function(expr, console_output = DM.console.output) {
  correct_output = try(capture.output(try(eval(parse(text=expr)))))
  
  if (inherits(correct_output, "try-error")) {
    return(FALSE)
  }
  correct_output = paste(correct_output, collapse='')
  
  # Remove new-lines: 
  console_output = gsub("\n|[[:space:]]","", console_output)
  correct_output = gsub("\n|[[:space:]]","", correct_output)
  
  where.is.regex = gregexpr(pattern = correct_output, text = console_output, fixed = TRUE)
  if (any(where.is.regex[[1]] == (-1))) { 
    return(FALSE) 
  } else { 
    return(TRUE) 
  }
}

#' Other version of output_contains useful in some cases
#' 
#' @param expr The expression (as string) for which the output should be in the student's console.
#' @param console_output The string containing the output printed to the student's console. 
#' The default is \code{DM.console.output} which is set on the DataCamp server (automagically).
#' This means you don't have to specify this argument when writing SCTs for DataCamp.com.
#'  
#' @export
output_contains2 = function(expr, console_output = DM.console.output) {
  library("evaluate")
  correct_output = try(evaluate(expr, envir = globalenv())[[2]])
  if (inherits(correct_output, "try-error")) {
    return(FALSE)
  }
  correct_output = paste(correct_output, collapse = "")
  console_output = gsub("\n|[[:space:]]", "", console_output)
  correct_output = gsub("\n|[[:space:]]", "", correct_output)
  where.is.regex = gregexpr(pattern = correct_output, text = console_output, 
                            fixed = TRUE)
  if (any(where.is.regex[[1]] == (-1))) {
    return(FALSE)
  } else {
    return(TRUE)
  }  
}