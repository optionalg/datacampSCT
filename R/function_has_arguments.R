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

code_is_correct = function(code=DM.user.code){
  x = try(eval(parse(text=code)),silent=TRUE)
  is_correct = ! "try-error" %in% class(x)
  ifelse(is_correct,return(TRUE),return(FALSE))
}

function_has_arguments = function(fun=NULL,args=NULL,values=NULL,eval=NULL){
  if(!code_is_correct()){ return(FALSE) }
  if(is.null(fun)){ return(FALSE) }
  if(is.null(args)){     
    return(length(expressions_for_function(fun))) 
  }
  if (is.null(eval)){ 
    eval = rep(FALSE,length(args)) 
  }
  if (!is.null(values) && length(eval)!=length(values)){ 
    stop("eval vector should have same lenght as values vector, for obvious reasons ;-).") 
  }
  
  # Step 1: Get the expressions in which the function is used:
  expressions = expressions_for_function(fun);
  if(length(expressions)==0){ return(FALSE) }
  
  # Step 2: Get the arguments
  argument_list = list();
  for(i in 1:length(expressions)){
    argument_list[[i]] = arguments_for_expression(expressions[i],fun=fun)
  }
  
  # Step 3: Find matches:
  matches = c();
  for(i in 1:length(argument_list)){
    matches[i] = check_function_arguments(argument_list[[i]],args,values,eval);
  }
  return(sum(matches))
}
