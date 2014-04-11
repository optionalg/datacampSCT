#' Check which functions were called by a student
#' 
#' Function takes the user code as input, then checks which functions were 
#' called by the student and returns a character vector with the names of those functions.
#' In case \code{DM.user.code} cannot be parsed, the function returns an empty character string.
#' 
#'  @param user_code The string containing the code submitted by the user. 
#'  The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically).
#'  
#'  @examples
#'  DM.user.code = "#Some random user code\n x <- 1:10 \n mean(x,y=blablaY,z=blablaZ);sum(x)\n sapply(x,FUN=sum) \n mean(x2=2,y2=3)"
#'  # Return the functions that were called in DM.user.code
#'  called_functions()
#'  
#'  @export
called_functions <- function(user_code=DM.user.code) {
  parseData <- try(getParseData(parse(text=user_code)),silent=TRUE);
  if (inherits(parseData,"try-error")) {
    return("")
  }                 
  id <- with(parseData, id[token == "SYMBOL_FUNCTION_CALL"]);
  call_funs <- sapply(id, function(x) getParseText(parseData, id=x));
  
  return(call_funs);
} 