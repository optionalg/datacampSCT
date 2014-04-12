#' Check whether a student called a function with the correct arguments and/or argument values
#' 
#' Function checks whether a student called a function with the correct arguments and/org argument values. 
#' It returns the number of times the function call you specify was done in the student code.
#' You can either check whether the student supplied "something" to the specified arguments, 
#' or you can check whether the student supplied certain values to the arguments. 
#' In case you want to specifically check what the student assigned to an argument, 
#' you can either check that as a character value or check the actual value that a student assigned to an argument.
#' Have a look at the examples in case this is unclear.
#' 
#'  @param fun String with the name of the function. E.g. "plot".
#'  @param args A character vector with the names of the arguments a student should have assigned 
#'  a value to when calling the function \code{fun}.
#'  @param values The values a student should have assigned to the arguments specified in the argument \code{args}.
#'  The values should be supplied in the order corresponding to the order of \code{args}.
#'  @param eval A vector of booleans specifying whether the corresponding value in the \code{values} arguments should be 
#'  evaluated when testing whether a student did the function call.
#'  @param code The string containing the code submitted by the user. 
#'  The default is \code{DM.user.code} which contains the student code submitted to the DataCamp server (automagically).
#'  
#'      
#'  @examples
#'  # Suppose the student has to write a loop that prints the numbers 1 up to 10.
#'  
#'  @export
function_has_arguments = function(fun=NULL, args=NULL, values=NULL, eval=NULL, code=DM.user.code) {  
  if (is.null(fun)) { 
    return(FALSE) 
  }
  if (is.null(args)) {     
    return(length(expressions_for_function(fun,code))) 
  }
  if (is.null(eval)) { 
    eval = rep(FALSE,length(args)) 
  }
  if (!is.null(values) && length(eval)!=length(values)) { 
    stop("eval vector should have same lenght as values vector, for obvious reasons ;-).") 
  }
  
  # Step 1: Get the expressions in which the function is used:
  expressions = expressions_for_function(fun,code);
  if(length(expressions)==0){ return(FALSE) }
  
  # Step 2: Get the arguments
  argument_list = list();
  for(i in 1:length(expressions)){
    argument_list[[i]] = arguments_for_expression(expressions[i],fun=fun)
  }
  
  # Step 3: Find matches:
  matches = c();
  for(i in 1:length(argument_list)) {
    matches[i] = check_function_arguments(argument_list[[i]],args,values,eval);
  }
  return(sum(matches))
}

expressions_for_function = function(fun = NULL, code=DM.user.code){
  # Parse user code and get parse information: 
  parseData <- getParseData(parse(text=code)); 
  ids_of_expressions = with(parseData, parent[text == fun & token == "SYMBOL_FUNCTION_CALL"]); 
  ids_of_expressions = parseData$parent[ parseData$id %in% ids_of_expressions ]; 
  called_expressions <- sapply(ids_of_expressions, function(x) getParseText(parseData, id=x))
  
  return(called_expressions)
}

arguments_for_expression = function(expression=NULL,fun=NULL){
  arguments <- match.call(get(fun), call=parse(text=expression))[-1];
  arguments_list = as.list(arguments);
  
  # start ugly-fix:
  names = names(arguments_list);
  arguments_list = as.character(arguments_list);
  names(arguments_list) = names;
  # end ugly-fix
  
  return(arguments_list)
}

check_function_arguments = function(student_arguments=NULL,args=args,values=values,eval=eval){
  relevant_student_args = student_arguments[ names(student_arguments) %in% args ];  
  if(length(relevant_student_args)!=length(args)){ return(FALSE) }
  
  
  match_vector = c();
  # Situation with values:
  if(!is.null(values)){
    # Loop over relevant arguments: 
    for(i in 1:length(args)){
      index = which( names(relevant_student_args) %in% args[i] );
      if(length(index)==0){ 
        return(FALSE) 
      } else{
        if (eval[i]==FALSE){
          match_vector[i] =  try(all.equal(as.character(relevant_student_args[[index]]), as.character(values[i])));
        } else {
          match_vector[i] =  try(all.equal(eval(parse(text=relevant_student_args[[index]])), eval(parse(text=values[i]))));        
        }
      }                      
    }
    match_vector = as.logical(match_vector);
    if(any(is.na(match_vector))){ match_vector=FALSE }
    return(all(match_vector)); # All values should be correct!
  } else if (is.null(values)){
    # Situation without values: 
    # Just check whether all args were called by student:
    return(all(args %in%  names(student_arguments)))    
  }  
}

# code_is_correct = function(code=DM.user.code){
#   x = try(eval(parse(text=code)),silent=TRUE)
#   is_correct = ! "try-error" %in% class(x)
#   ifelse(is_correct,return(TRUE),return(FALSE))
# }