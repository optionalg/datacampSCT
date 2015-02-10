#' Check whether a student called a function with the correct formal arguments or actual arguments 
#' 
#' This function is the key component of many more advanced Submission Correctness Tests. 
#' We use the terms "formal arguments" and "actual arguments" (read \url{http://adv-r.had.co.nz/Functions.html#function-arguments} if you are not familiar with those terms). The function returns the number of times the function call you specify was done in the student code.
#' The function can be used in a "layered fashion". Have a look at the examples to understand the different use cases.
#' You can either check whether the student assigned "something" to the formal arguments
#' or you can check whether the student used the correct actual arguments. 
#' In the latter case, you can compare what was supplied to the actual arguments 
#' either as a string or after evaluating it.  Have a look at the examples in case this is unclear.
#' 
#' @param fun String with the name of the function. E.g. "plot".
#' @param args A character vector with the names of the formal arguments a student should have assigned 
#' a value to when calling the function \code{fun}.
#' @param values The values a student should have assigned to the arguments specified in the argument \code{args} (in other words: the actual arguments).
#' The values should be supplied in the order corresponding to the order of \code{args}.
#' @param eval A logical vector specifying whether the corresponding value in the \code{values} arguments should be 
#' evaluated when testing whether a student did the function call.
#' @param code The string containing the code submitted by the user. 
#' The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically).
#' This means you don't have to specify this argument when writing SCTs for DataCamp.com.  
#'      
#'  @examples
#'  # When student submits incorrect code function_has_arguments returns false
#'  code_with_error = "mean(x);plot(xasdfasb,a;mean(x)"
#'  function_has_arguments("plot", code = code_with_error)
#'  
#'  # When you check the existence of formal arguments in a function, it returns them correctly:
#'  code2 = "plot(rnorm(10),pch=16,xlab='test');plot(rnorm(100));plot(x~y)"
#'  function_has_arguments("plot","x",code=code2) # 3 occurences
#'  function_has_arguments("plot",c("x","xlab"),code=code2) # 1 occurence
#'  
#'  # When you specify the arguments of a function explicitly without evaluation:
#'  code3 = "plot(rnorm(100),pch=16,xlab='test');plot(x~y);mean(x);hist(mean(rnorm(100)))";  
#'  x = y = 1:10;
#'  function_has_arguments("plot","x","rnorm(100)",code=code3) # one occurence
#'  function_has_arguments("plot","x","x ~ y",code=code3) # one occurence
#'  function_has_arguments("hist","x","mean(rnorm(100))",code=code3) # one occurence
#'  function_has_arguments("plot",c("x","pch","xlab"),c("rnorm(100)","16","test"),code=code3)
#'  function_has_arguments("plot",c("x","pch","xlab"),c("rnorm(100)","14","test"),code=code3)
#'  
#'  # When you specify the arguments of a function explicitly with evaluation:
#'  x = y = 1:10; 
#'  my_test=label="test";
#'  code4 = "plot(1:20,pch=16,xlab=label,ylab='saywhat');plot(x);plot(x~y);mean(x);hist(mean(1:10))"; 
#'  function_has_arguments("plot","xlab","my_test",eval=TRUE,code=code4)
#'  
#'  @export
function_has_arguments = function(fun = NULL, args = NULL, values = NULL, eval = NULL, code = DM.user.code) {  
  if (is.null(fun)) {
    return(FALSE) 
  }
  if (is.null(args)) {
    expressions = expressions_for_function(fun = fun, code = code)
    if (length(expressions) == 0 || any(expressions == FALSE)) { 
      return(FALSE) 
    } else {
      return(length(expressions))       
    }
  }
  if (is.null(eval)) { 
    eval = rep(FALSE, length(args)) 
  }
  if (!is.null(values) && length(eval) != length(values)) { 
    stop("eval vector should have same lenght as values vector, for obvious reasons -).") 
  }
  
  # Step 1: Get the expressions in which the function is used:
  expressions = expressions_for_function(fun = fun, code = code)
  if (length(expressions) == 0 || any(expressions == FALSE)) { return(FALSE) }
  
  # Step 2: Get the arguments
  argument_list = list()
  for (i in 1:length(expressions)) {
    argument_list[[i]] = arguments_for_expression(expressions[i], fun = fun)
  }
  
  # Step 3: Find matches:
  matches = c()
  for(i in 1:length(argument_list)) {
    matches[i] = check_function_arguments(argument_list[[i]], args, values, eval)
  }
  return(sum(matches))
}

expressions_for_function = function(fun = NULL, code = NULL) {
  # Parse user code and get parse information: 
  parseData = try(getParseData(parse(text=code, keep.source = TRUE)),silent=TRUE)
  
  if (inherits(parseData, "try-error")) {
    return(FALSE)
  }
  
  ids_of_expressions = parseData$parent[parseData$text == fun & parseData$token == "SYMBOL_FUNCTION_CALL"] 
  #ids_of_expressions = with(parseData, parent[text == fun & token == "SYMBOL_FUNCTION_CALL"]) 
  ids_of_expressions = parseData$parent[ parseData$id %in% ids_of_expressions ] 
  
  called_expressions = sapply(ids_of_expressions, function(x) getParseText(parseData, id=x))
  
  return(called_expressions)
}

arguments_for_expression = function(expression = NULL, fun = NULL) {  
  arguments = match.call(get(fun), call=parse(text=expression))[-1]
  arguments_list = as.list(arguments)
  
  # start ugly-fix:
  names = names(arguments_list)
  arguments_list = as.character(arguments_list)
  names(arguments_list) = names
  # end ugly-fix
  
  return(arguments_list)
}

check_function_arguments = function(student_arguments = NULL, args = args, values = values, eval = eval) {
  relevant_student_args = student_arguments[ names(student_arguments) %in% args ]  
  if(length(relevant_student_args) != length(args)){ return(FALSE) }
    
  match_vector = c()
  # Situation with values:
  if (!is.null(values)) {
    # Loop over relevant arguments: 
    for (i in 1:length(args)) {
      index = which(names(relevant_student_args) %in% args[i])
      if (length(index) == 0) { 
        return(FALSE) 
      } else{
        if (eval[i] == FALSE) {
          match_vector[i] =  try(all.equal(as.character(relevant_student_args[[index]]), as.character(values[i])))
        } else {
          match_vector[i] =  try(all.equal(eval(parse(text=relevant_student_args[[index]])), eval(parse(text=values[i]))))        
        }
      }                      
    }
    match_vector = as.logical(match_vector)
    if (any(is.na(match_vector))) { 
      match_vector=FALSE 
    }
    return(all(match_vector)) # All values should be correct!
  } else if (is.null(values)) {
    # Situation without values: 
    # Just check whether all args were called by student:
    return(all(args %in%  names(student_arguments)))    
  }  
}