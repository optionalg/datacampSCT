get_arguments = function(fun, code = DM.user.code){
  # Function takes a function.name and the DM.user.code as input, 
  # then checks how many times the user called that function 
  # and for each time the function was called it returns the arguments supplied to the function. 
  # The ouput is a list. Each list component contains a vector with the supplied arguments.
  # The names of the latter vector are the respective argument names
  
  # Step 1: Get the expressions in which the function is used:
  expressions = expressions_for_function(fun);
  
  # Step 2: Get the arguments for each function call:
  args_list = sapply(expressions,arguments_for_expression,fun);
  
  return(args_list)
}
