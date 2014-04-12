\name{student_typed}
\alias{student_typed}
\title{Test whether the student code contains a certain string}
\usage{
student_typed(string, code = DM.user.code)
}
\arguments{
  \item{string}{The string you would like to find in the
  student's code.}

  \item{code}{The string containing the code submitted by
  the user. The default is \code{DM.user.code} which
  contains the student code submitted to the DataCamp
  server (automagically). This means you don't have to
  specify this argument when writing SCTs for
  DataCamp.com.}
}
\description{
Returns either \code{FALSE} in case the student didn't type
the string, or the number of occurrences in the code. Both
for the submitted student code (\code{code} argument) as
well as for the string you want to test (\code{string}
argument) it holds that: (i) the white spaces are ignored,
(ii) \code{;} and new lines are ignored, (iii) \code{TRUE}
/ \code{T}, and \code{FALSE} / \code{F} are considered as
the same string (iv) it doesn't matter if the student uses
\code{=} or \code{<-} for assignment. This function is
useful when it's hard to check e.g. a function call with
\code{\link{function_has_arguments}} or when it would be
too slow to do a real comparison, or when you want to check
whether the student used a certain type of notation.
}
\examples{
DM.user.code = "for (i in 1:2) { x[i] = rnorm(1E6) }"
# Return the number of times a student typed:
student_typed("for(i in 1:2")
# Has the student used the notation 1E6?
student_typed("1E6")
}

