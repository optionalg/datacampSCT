#' Check which functions were called by a student
#' 
#' Function takes the user code as input, and returns a character vector with the names of the functions
#' called by a student.
#' In case the code provided by a student cannot be parsed (which happens for example when the student code contains a syntax error), 
#' the function returns an empty character string.
#' 
#'  @param code The string containing the code submitted by the user. 
#'  The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically). 
#'  This means you don't have to specify this argument when writing SCTs for DataCamp.com.
#'  
#'  @examples
#'  DM.user.code = "mean(x, y = blablaY, z = blablaZ);sum(x)\n sapply(x, FUN = sum)"
#'  # Return the functions that were called in DM.user.code
#'  called_functions()
#'  
#'  @export
called_functions = function(code = DM.user.code) {
  parseData = try(getParseData(parse(text = code)), silent=TRUE)
  if (inherits(parseData, "try-error")) {
    return("")
  }
  id = with(parseData, id[token == "SYMBOL_FUNCTION_CALL"]);
  call_funs = sapply(id, function(x) getParseText(parseData, id = x))
  
  return(call_funs);
} 