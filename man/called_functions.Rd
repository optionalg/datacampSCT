\name{called_functions}
\alias{called_functions}
\title{Check which functions were called by a student}
\usage{
called_functions(code = DM.user.code)
}
\arguments{
  \item{code}{The string containing the code submitted by
  the user.  The default is \code{DM.user.code} which
  contains the student code submitted to the DataCamp
  server (automagically).  This means you don't have to
  specify this argument when writing SCTs for
  DataCamp.com.}
}
\description{
Function takes the user code as input, and returns a
character vector with the names of the functions called by
a student. In case the code provided by a student cannot be
parsed (which happens for example when the student code
contains a syntax error), the function returns an empty
character string.
}
\examples{
DM.user.code = "x=rnorm(100);mean(x = 1:10,);sum(x)"
 # Return the functions that were called in DM.user.code
 called_functions()
}

