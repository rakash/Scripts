#https://www.tutorialspoint.com/r
#https://campus.datacamp.com/courses/free-introduction-to-r/chapter-5-data-frames?ex=8

print(23.9 + 11.6)

# Assignment using equal operator.
var.1 = c(0,1,2,3)           

# Assignment using leftward operator.
var.2 <- c("learn","R")   

# Assignment using rightward operator.   
c(TRUE,1) -> var.3           

print(var.1)
cat ("var.1 is ", var.1 ,"\n")
cat ("var.2 is ", var.2 ,"\n")
cat ("var.3 is ", var.3 ,"\n")


var_x <- "Hello"
cat("The class of var_x is ",class(var_x),"\n")

var_x <- 34.5
cat("  Now the class of var_x is ",class(var_x),"\n")

var_x <- 27L
cat("   Next the class of var_x becomes ",class(var_x),"\n")

print(ls())

ls()

# List the variables starting with the pattern "var".
print(ls(pattern = "var"))

print(ls(all.name = TRUE))

rm(var.3)
print(var.3)

rm(list = ls()) # all variables can be deleted
print(ls())

# If statement
if(boolean_expression) {
  #// statement(s) will execute if the boolean expression is true.
}


x <- 30L
if(is.integer(x)) {
  print("X is an Integer")
}

# If else

if(boolean_expression) {
  #// statement(s) will execute if the boolean expression is true.
} else {
  #// statement(s) will execute if the boolean expression is false.
}


x <- c("what","is","truth")

if("Truth" %in% x) {
  print("Truth is found")
} else {
  print("Truth is not found")
}


x <- c("what","is","truth")

if("Truth" %in% x) {
  print("Truth is found the first time")
} else if ("truth" %in% x) {
  print("truth is found the second time")
} else {
  print("No truth found")
}

# Switch

switch(expression, case1, case2, case3....)

x <- switch(
 2,
  "first",
  "third",
  "second",
  "fourth"
)
print(x)


# LOOPS

# REPEAT LOOP

repeat { 
  commands 
  if(condition) {
    break
  }
}

v <- c("Hello","loop")
cnt <- 2

repeat {
  print(v)
  cnt <- cnt+1
  
  if(cnt > 5) {
    break
  }
}

# WHILE LOOP - It tests the condition before executing the loop body.

while (test_expression) {
  statement
}


v <- c("Hello","while loop")
cnt <- 2

while (cnt < 7) {
  print(v)
  cnt = cnt + 1
}

# FOR LOOP - Like a while statement, except that it tests the condition at the end of the loop body.

for (value in vector) {
  statements
}


v <- LETTERS[1:4]
for ( i in v) {
  print(i)
}

# -- LOOP CONTROL STATEMENTS

# BREAK STATEMENT

v <- c("Hello","loop")
cnt <- 2

repeat {
  print(v)
  cnt <- cnt + 1
  
  if(cnt > 5) {
    break
  }
}

# NEXT STATEMENT

v <- LETTERS[1:6]
for ( i in v) {
  
  if (i == "D") {
    next
  }
  print(i)
}


# -- FUNCTIONS








