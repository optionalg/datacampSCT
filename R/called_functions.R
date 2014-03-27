called_functions <- function( user.code=DM.user.code){
  parseData <- getParseData(parse(text=DM.user.code))
  id <- with(parseData, id[token == "SYMBOL_FUNCTION_CALL"])
  call_funs <- sapply(id, function(x) getParseText(parseData, id=x))
  
  return(call_funs)  
}