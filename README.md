[![Build Status](https://api.travis-ci.org/Data-Camp/datacampSCT.svg?branch=master)](https://travis-ci.org/Data-Camp/datacampSCT)

The `datacampSCT` package is a set of help functions that enable you to quickly test student code and to give feedback to a student on what is wrong/right in an exercise. 

## Submission Correctness Tests
<center><i>
#### "Mistakes are not errors but partially correct solutions with underlying logic"
</i></center>

The key ingredient to an interactive exercise is the Submission Correctness Test (SCT). Conceptually, an SCT is simple. It takes as input the code that was submitted by a student, processes it and outputs:

1. If the exercise was solved correctly.
2. Feedback to the student, either to congratulate him when he solved the exercise correctly, or to guide him into the direction of the correct solution in case he did not find the correct solution.

Submission Correctness Tests are written in R, so it is possible to leverage existing R functionality or to create new types of tests that can be shared with the community.

### Submission Correctness Tests step-by-step:

In this subsection, we describe the three essential ingredients of a SCT: 

1. The student's input.
2. Testing the student's submission.
3. The output of the SCT.

- **Student's input:**<br>
SCTs are run in the students workspace (the global environment), so you can use all objects that a student created as input for the test. Furthermore, DataCamp gives you access to two more items that can help you to generate useful feedback for your students:
   - `DM.user.code`: The code written by the student as a string.
   - `DM.console.output`: The output in the console as a string.

- **Testing the students submission:**<br>
The Submission Correctness Test processes the inputs described in step one, to decide whether a student correctly solved the exercise or not. These tests can be really simple or relatively advanced, but they are always written in R, so you can leverage the existing functionality. To make writing these SCTs as simple as possible, the `datacampSCT` provides a few help functions. You can install it locally through:
   ```ruby
library("devtools");
install_github("datacampSCT","data-camp")
install_github("datacamp","data-camp");
library("datacamp")
```
	(Note that we are developing a new and improved version of this package that will leverage the functionality in the `testthat` package.)

- **Output:**<br>
The output of a Submission Correctness Test is a list with two components:
	1. a boolean (`TRUE`/`FALSE`) indicating whether the exercise was correctly solved or not, and
	2. a string that provides a message to the student. 
The output of the test should be assigned to a variable `DM.result`.

DataCamp will show your feedback to the student in a standardized way: green if the student solved the exercise correctly, and red if he did not. We encourage you to provide useful messages to your students, and to write different messages for different mistakes a student can make.

### Submission Correctness Tests Examples:

You can use SCTs to test a wide variety of things: e.g. has the student...
- estimated a certain model correctly?
- generated a transformed time series that fulfills certain conditions?
- generated a certain type of graph?
- forecasted a metric of interest witin certain bounds?
- etc.

The examples above show the immense potential of SCTs to automate teaching. The examples below are simpler and aim to illustrate the concept.

#### Example: illustrating the concept of an SCT
Let us start with a really dummed down example to illustrate the idea behind an SCT. Suppose you ask a student to assign the value 42 to the variable `x`. To test what a user did, you could write the following SCT: <i>(example provided for educational purposes only)</i>
```ruby
# Smart student code
x = 42
# Not-so-smart student code
x = 43

# Start SCT
if (x == 42) { 
  DM.result = list(TRUE, "Well done, you genius!")
} else { 
  DM.result = list(FALSE, "Please assign 42 to x.") 
}
```

#### Example: check whether a student typed certain expressions or not
Suppose you expect a student to type `17%%4` and `2^5` somewhere in the editor, and you would like to check whether a student actually did that. The code will be:
```ruby
# Smart student code
DM.user.code = "17%%4; 2^5"
# Not-so-smart student code
DM.user.code = "42"

# Start SCT
if (! (student_typed("17%%4") & student_typed("2^5"))) {
	DM.result = list(FALSE,"Looks like you didn't type one of the expressions we expected.")
} else {
	DM.result = list(TRUE,"Well done!")	
}
```

#### Example: check whether the student printed something to the console or not

Suppose the student has to write a loop that prints the numbers 1 up to 10:
```ruby
# A smart student does exactly that and thus submits the code assigned to DM.user.code: 
DM.user.code = "n=10;for(i in 1:n){print(i)};"
# What student's console contains:
DM.console.output = paste(capture.output(eval(parse(text = DM.user.code))), collapse="")

# Start SCT: 
if (! output_contains("for(i in 1:10){print(i)}")) {
	DM.result = list(FALSE, "Did you print the numbers one up to ten to the console?")
} else {
	DM.result = list(TRUE, "Well done!")
}
```

#### Example: check whether a student called certain functions

Suppose you just want to check whether a student called certain functions or not, but the details are not important. 
For example, a student should have called the `rnorm()` and `mean()` functions in his code. 

```ruby 
# Student submits the code assigned to DM.user.code as answer
DM.user.code = "x=rnorm(100);mean(x = 1:10,);sum(x)"

# Start SCT
if (! (c("rnorm", "mean") %in% called_functions())) {
	DM.result = list(FALSE,"Looks like you forgot to call either 'rnorm()' or 'mean()'.")
} else {
	DM.result = list(TRUE,"Well done!")	
}
```

#### Example: check whether a student called a function with the correct arguments or not

Suppose you are teaching students about the normal distribution. Their task in this exercise is to generate 10000 observations and plot a histogram with the color blue and 50 breaks. This can be tested as follows (simplified for educational purposes):

```ruby 
# Smart student submits the code assigned to DM.user.code as answer
DM.user.code = "hist(rnorm(10000),col='blue',breaks=50)"

# Start SCT
if (function_has_arguments("hist", c("x","col","breaks"), c("rnorm(10000)","blue","50"))==0) {
	DM.result = list(FALSE, "Try again! You didn't create a histogram with the correct arguments.")	
} else {
	DM.result = list(TRUE, "Correct!")
}
```

#### Example: creating a multiple choice question

It is also possible to craft multiple choice questions using SCTs. Suppose you have a multiple choice question with 4 options, and the second option represents the correct answer. You would like to check if the student chose the right option:

```ruby 
# Smart student selects option 2 in the MCQ-menu. DM.user.code now equals: 
DM.user.code = 2

# Not-so-smart student selects option 4 in the MCQ-menu. DM.user.code now equals: 
DM.user.code = 4

# Start SCT
if ( !exists("DM.result") ){
  DM.result = list(FALSE, "Please select one of the options!")
} else if ( identical(DM.result, 2) ){
  DM.result = list(TRUE, "Well done! You are a smart student.")
} else {
  DM.result = list(FALSE, "Incorrect. You are a not-so-smart student.")
}
```

#### Other examples:
Look at the source code of the interactive [Introduction to R](https://github.com/data-camp/introduction_to_R) course.
