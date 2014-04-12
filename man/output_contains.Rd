\name{output_contains}
\alias{output_contains}
\title{Check whether the student printed something to the console}
\usage{
output_contains(expr, console_output = DM.console.output)
}
\arguments{
  \item{expr}{The expression (as string) for which the
  output should be in the student's console.}

  \item{console_output}{The string containing the output
  printed to the student's console.  The default is
  \code{DM.console.output} which is set on the DataCamp
  server (automagically).}
}
\description{
Function checks whether the student's console contains the
output one gets by evaluating the character provided to
\code{expr}. It returns \code{TRUE} when the student's
console indeed contains the expected output and
\code{FALSE} otherwise.
}
\examples{
# Suppose the student has to write a loop that prints the numbers 1 up to 10.
 # A smart student does exactly that and thus submits the code assigned to DM.user.code:
 DM.user.code = 'n=10;for(i in 1:n){print(i)};'
 # What student's console contains:
 DM.console.output = paste(capture.output(eval(parse(text=DM.user.code))), collapse="")
 # What the test tells us:
 output_contains("for(i in 1:10){print(i)}")
 # Suppose the student was supposed to loop upto 20:
 output_contains("for(i in 1:20){print(i)}")
}

