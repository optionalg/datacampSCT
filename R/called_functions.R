called_functions <- function( user_code=DM.user.code){
  parseData <- getParseData(parse(text=user_code));
  id <- with(parseData, id[token == "SYMBOL_FUNCTION_CALL"]);
  call_funs <- sapply(id, function(x) getParseText(parseData, id=x));
  
  return(call_funs);
} 