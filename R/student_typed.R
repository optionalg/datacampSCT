#' Test whether the student code contains a certain string
#' 
#' Returns either \code{FALSE} in case the student didn't type the string, or the number of occurrences in the code. 
#' Both for the submitted student code (\code{code} argument) 
#' as well as for the string you want to test (\code{string} argument) it holds that:
#' \enumerate{ 
#' \item the white spaces are ignored,
#' \item \code{;} and new lines are ignored, 
#' \item \code{TRUE} / \code{T}, and \code{FALSE} / \code{F} are considered as the same string
#' \item it doesn't matter if the student uses \code{=} or \code{<-} for assignment. 
#' }
#' This function is useful when it's hard to check e.g. a function call with \code{\link{function_has_arguments}},  
#' or when it would be too slow to do a real comparison, 
#' or when you want to check whether the student used a certain type of notation.
#' 
#' @param string The string you would like to find in the student's code.
#' @param code The string containing the code submitted by the user. 
#' The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically). 
#' This means you don't have to specify this argument when writing SCTs for DataCamp.com.
#'  
#' @examples
#' DM.user.code = "for (i in 1:2) { x[i] = rnorm(1E6) }"
#' # Return the number of times a student typed:
#' student_typed("for(i in 1:2")
#' # Has the student used the notation 1E6?
#' student_typed("1E6")
#' 
#' @export
student_typed = function(string, code = DM.user.code) {
  # Remove white spaces, ";" and "\n" from string & code
  code   = gsub("[[:space:]]|;|\n", "", code )
  string = gsub("[[:space:]]|;|\n", "", string )
  
  # Student can choose to assign by "=" or "<-", this shouldn't matter
  code   = gsub("=", "<-", code)
  string = gsub("=", "<-", string)
  
  # Student can choose to TRUE/T and FALSE/F
  code      = gsub("FALSE", "F", code)
  string    = gsub("FALSE", "F", string)
  code      = gsub("TRUE", "T", code)
  string    = gsub("TRUE", "T", string )
  
  # Student can use double and single quotes:
  code   = gsub( "\"", "\'", code )
  string = gsub( "\"", "\'", string )
  
  # Find reg ex and return result:  
  where.is.regex = gregexpr(pattern = string, text = code, fixed = TRUE)
  if (any(where.is.regex[[1]] == (-1))) {
    return(FALSE) 
  } # No match for the reg ex 
  n = length(where.is.regex[[1]])
  return(n)
} 