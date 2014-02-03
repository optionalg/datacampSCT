student_used_function = function(fun){
  # How many times was the function called?  
  fun_called = sum(called_functions() %in% fun);
  return(fun_called)
}

check_arguments = function(student_arguments, args, values,eval){
  relevant_student_args = student_arguments[ names(student_arguments) %in% args ];
  if(length(relevant_student_args)==0){ return(FALSE) }
  match_vector = c();
  for(i in 1:length(relevant_student_args)){
    index = which( args == names(relevant_student_args)[i]);
    if(length(index)==0){ 
      return(FALSE) 
    } else{
      if (eval[index]==FALSE){
        match_vector[i] =  try(identical(as.character(relevant_student_args[index]), as.character(values[index])));
      } else {
        match_vector[i] =  try(identical(eval(parse(text=relevant_student_args[index])), eval(parse(text=values[index]))));        
      }
    }                      
  }
  return(all(match_vector)); # All values should be correct!
}

function_has_arguments = function(fun=NULL,args=NULL,values=NULL,eval=NULL){
  if (is.null(eval)){ eval = rep(FALSE,length(args)) }
  if (!is.null(values) && length(eval)!=length(values)){ stop("eval vector should have same lenght as values vector, for obvious reasons ;-).") }
    
  if ((!is.null(fun)) && student_used_function(fun)!=0){
    arguments = get_arguments(fun);   
    
    if (!is.null(args) && is.null(values)){ 
      # Just check whether these arguments were provided, irrespective of their value
      has_arguments = c();
      for (i in 1:length(arguments)){ # Loop over different times a function is used
        has_arguments[i] = all(args %in% names(arguments[[i]]));
      }
      return(sum(has_arguments))
    } else if (!is.null(args) && !is.null(values)){
      if(length(args)!=length(values)){ stop("you idiot, give args and values the same length.")}
      # Check whether the correct value was assign to the correct argument by a student
      correct_arguments = c();
      for (i in 1:length(arguments)){ # Loop over different times a function is used
        correct_arguments[i] = check_arguments(student_arguments=arguments[[i]], args,values,eval);
    }
    return(sum(correct_arguments))
  }
  }
  return(FALSE)
}