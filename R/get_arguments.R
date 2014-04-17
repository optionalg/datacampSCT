#' Get the arguments of one or multiple function calls done by a student
#' 
#' Function takes a function name (\code{fun}) and the submitted student code (\code{code}) as input.
#' For every time the function was called, it returns the formal and the actual arguments of that function call. 
#' 
#' The ouput is a list and each list item corresponds to a function call by the student. 
#' Each list item contains a vector with as values the actual arguments and as names the formal arguments.
#' 
#'  @param fun String with the name of the function for which you want to find the arguments supplied by the student.
#'  @param code String with the code submitted by the student. 
#'  The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically).
#'  This means you don't have to specify this argument when writing SCTs for DataCamp.com.
#'  
#'  @examples
#'  # Student called the plot function once with two arguments:
#'  DM.user.code = "plot(1:10,col='blue')"
#'  get_arguments("plot")
#'    
#'  # Student called the plot function twice:
#'  DM.user.code = "plot(1:10,col='blue');plot(rnorm(100));"
#'  get_arguments("plot")
#'  
#'  @export
get_arguments = function(fun = NULL, code = DM.user.code) {
  if (is.null(fun)) {
    stop("The 'fun' argument cannot be empty.")
  }
  # Step 1: Get the expressions in which the function is used:
  expressions = expressions_for_function(fun, code)
  if(length(expressions)==0){ return(FALSE) }
    
  # Step 2: Get the arguments for each function call:
  args_list = lapply(expressions, 
                     function(expression = NULL, fun = NULL) {
                       arguments = match.call(get(fun), call=parse(text=expression))[-1]
                       arguments_list = as.list(arguments) }, 
                     fun)
  
  return(args_list)
}

