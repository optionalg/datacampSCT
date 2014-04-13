[![Build Status](https://api.travis-ci.org/Data-Camp/datacampSCT.svg?branch=master)](https://travis-ci.org/Data-Camp/datacampSCT)

The `datacampSCT` package is a set of help functions that enable you to quickly test student code and give feedback to a student on what's wrong/right in an exercise. 

## Submission Correctness Tests
<center>### "Mistakes are not errors but partially correct solutions with underlying logic."</center>

The key ingredient to an interactive course is the Submission Correctness Test (SCT). Conceptually, an SCT is simple. It takes as input the code a student submitted, processes it and outputs:

	1. Whether the exercise was correctly solved.
	2. Feedback to the student, either to congratulate him when he correctly solved the exercise, or to guide him into the direction of the correct solution in case he didn't find the correct solution.

Submission Correctness Tests are written in R, so it is possible to leverage existing R functionality, or create new types of tests that can be shared with the community.

### Submission Correctness Tests step-by-step:

In this subsection, we describe the three essential ingredients of an SCT: 
	1. The student's input.
	2. Testing the student's submission.
	3. The output of the SCT.

1. **Student's input:**<br>
SCT's are run in the students workspace (the global environment), so you can use all objects a student created as input for the test. Furthermore, DataCamp gives you access to two more items, that can help you to generate useful feedback for your students:
   - `DM.user.code`: The code written by the student as a string.
   - `DM.console.output`: The output in the console as a string.

2. **Testing the students submission:**<br>
The Submission Correctness Test processes the inputs described in step one, to decide whether a student correctly solved the exercise. These tests can be really simple or relatively advanced, but they are always written in R, so you can leverage existing functionality. To make writing these SCTs as simple as possible, the `datacampSCT` provides a few help functions. You can install it locally through:
   ```r
library("devtools");
install_github("datacampSCT","data-camp")
install_github("datacamp","data-camp");
library("datacamp")
```

(Note: we are developing a new version of this package that will leverage the functionality in the `testthat` package.)

3. **Output:**<br>
The output of a Submission Correctness Test is a list with two components:
	1. a boolean (TRUE/FALSE) indicating whether the exercise was correctly solved, and
	2. a string providing a message to the student. 
The output of the test should be assigned to a variable `DM.result`.

DataCamp will show your feedback to the student in a standardized way: Green when the student correctly solved the exercise, and red when he didn't. We encourage you to provide useful messages to your students, and write different messages for different mistakes a student can make.

### Submission Correctness Tests Examples:

You can use SCT's to test a wide variety of things: e.g. has the student...
- estimated a certain model correctly?
- generated a transformed time series that fulfills certain conditions?
- generated a certain type of graph?
- forecasted a metric of interest witin certain bounds?
- etc.
The above examples show the immense potential of SCTs to automate teaching. The examples below are simpler, and aim to illustrate the concept.

#### Example one: illustrating the concept of an SCT
Let's start with a really dummed down example to illustrate the idea behind an SCT. Suppose you ask a student to assign the value 42 to the variable `x`. To test what a user did, you could write the following SCT: <i>(example provided for educational purposes only)</i>
```ruby
if (x == 5) { 
  DM.result = list(TRUE, "Well done, you genius!")
} else { 
  DM.result = list(FALSE, "Please assign 5 to x") 
}
```

#### Example two: checking whether a student typed certain expressions
Suppose you expect a student to type `17%%4` and `2^5` somewhere in the editor, and you would like to check whether a student actually did that. The SCT then simply becomes:
```ruby
DM.result = code_test( c("17%%4","2^5") )
```

#### Example three: checking whether a student assigned a value to a variable
Suppose you expect a student to assign the value 5 to the variable `my.apples`. The SCT, then simply becomes:
```ruby
DM.result = closed_test(names = "my,apples", values = 5)
```
Similarly, to test the values of multiple variables, you can use:
```ruby
names  = c("my.apples", "my.oranges", "my.fruit")
values = c(5, 6, "my.apples+my.oranges")
DM.result = closed_test(names, values)
```
Using the build in `closed_test` function ensures that useful help messages are generated automatically for the student. Obviously, you can as well make use of values in the users workspace to test. Suppose for example you'd like to test whether a student constructed a named list (my.list) with the components: a vector (my.vector), a matrix (my.matrix) and a data frame (my.df). This can be checked through:
```ruby
name   = "my.list"
value  = "list(VECTOR = my.vector, MATRIX = my.matrix, DATAFRAME = my.df)"
DM.result = closed_test(name, value)
```

#### Other examples:
Look at the source code of the interactive [Introduction to R](https://github.com/data-camp/introduction_to_R) course.
