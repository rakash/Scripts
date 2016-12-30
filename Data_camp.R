# INtro to R --  chapter-5-data-frames

#planet_df - data frame
# Select first 5 values of diameter column -- Selection of data frame elements 
planets_df[1:5, "diameter"]

# Select the rings variable from planets_df
rings_vector <- planets_df$rings

# Print out rings_vector
rings_vector

# planets_df and rings_vector are pre-loaded in your workspace

# Adapt the code to select all columns for planets with rings
planets_df[rings_vector, ]

rings_vector[1:3]

# planets_df is pre-loaded in your workspace
subset(my_df, subset = some_condition)
# Select planets with diameter < 1
subset(planets_df, diameter < 1)

#sorting data frames

a <- c(100, 10, 1000)
order(a)
#[1] 2 1 3

a[order(a)]
#[1]   10  100 1000


# planets_df is pre-loaded in your workspace

# Use order() to create positions
positions <-  order(planets_df$diameter)
positions
# Use positions to sort planets_df
planets_df[positions, ]

# ------------ Lists ----------------------

#syntax -
my_list <- list(comp1, comp2, .. )


# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Construct list with these different elements:
my_list <- list(my_vector, my_matrix, my_df)


# Naming a list

my_list <- list(your_comp1, your_comp2)
names(my_list) <- c("name1", "name2")


# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Adapt list() call to give the components names
my_list <- list(my_vector, my_matrix, my_df)

# Print out my_list
names(my_list) <- c("vec", "mat", "df")
my_list


# The variables mov, act and rev are available

# Finish the code to build shining_list
shining_list <- list(moviename = mov, actors = act, reviews = rev)

# shining_list is already pre-loaded in the workspace

# Print out the vector representing the actors
shining_list[["actors"]]

# Print the second element of the vector representing the actors
shining_list[[2]][2]

# adding elements to list 

ext_list <- c(my_list , my_val)

# new name to list

ext_list <- c(my_list, my_name = my_val)


# shining_list, the list containing movie name, actors and reviews, is pre-loaded in the workspace

# We forgot something; add the year to shining_list
shining_list_full <- c(shining_list, year=1980)

# Have a look at shining_list_full
str(shining_list_full)

# ===================================================================================================================
  
# -- INTERMEDIATE - R - CHAPTER 1 
  
#Relation operators   

# Equality == 
# inequal !=

# < and > and <= and >=

# Comparison of logicals
TRUE == FALSE

# Comparison of numerics
-6 * 14 != 17 - 101

# Comparison of character strings
"useR" == "user"

# Compare a logical with a numeric
TRUE == 1
#---
  
  # Comparison of numerics
  -6 * 5 + 2 >= -10 + 1

# Comparison of character strings
"raining" <= "raining dogs"

# Comparison of logicals
TRUE > FALSE

#--
  
#Comparing vectors

# The linkedin and facebook vectors have already been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

# Popular days
linkedin > 15

# Quiet days
linkedin <= 5

# LinkedIn more popular than Facebook
linkedin > facebook

# Comparing matrices

# The social data has been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)
views <- matrix(c(linkedin, facebook), nrow = 2, byrow = TRUE)

# When does views equal 13?
views == 13

# When is views less than or equal to 14?
views <= 14

# The linkedin and last variable are already defined for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
last <- tail(linkedin, 1)

# Is last under 5 or above 10?
last < 5 | last > 10

# Is last between 15 (exclusive) and 20 (inclusive)?
last > 15 & last <= 20


# The social data (linkedin, facebook, views) has been created for you

# linkedin exceeds 10 but facebook below 10
linkedin > 10 & facebook < 10

# When were one or both visited at least 12 times?
linkedin >= 12 | facebook >= 12

# When is views between 11 (exclusive) and 14 (inclusive)?
views > 11 & views <= 14

# Reverse the result: !

x <- 5
y <- 7
!(!(x < 4) & !!!(y > 12))

# FALSE IS THE ANSWER

# Blend it all together

# li_df is pre-loaded in your workspace

# Select the second column, named day2, from li_df: second
second <- li_df$day2

# Build a logical vector, TRUE if value in second is extreme: extremes
extremes <- second > 25 | second < 5

# Count the number of TRUEs in extremes
sum(extremes)

# Solve it with a one-liner
sum(li_df$day2 > 25 | li_df$day2 < 5)


#Conditional Statements 