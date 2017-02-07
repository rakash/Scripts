# https://www.simple-talk.com/dotnet/software-tools/data-manipulation-in-r--beyond-sql/

# RSQLite 

help(mtcars)
data(mtcars)

View(mtcars)

rm(mtcars) # remove from current session

mtcars

install.packages("RSQLite")
library(RSQLite)

conn <- dbConnect(SQLite(),'mycars.db')

# we can write the data by specifying the connection, the name of the table, and the name of the data frame that contains the data to be persisted.

dbWriteTable(conn, "cars", mtcars)

#it is possible to run CREATE TABLE statements if you like to using standard SQL DDL.

dbGetQuery(conn, 'CREATE TABLE test_table(id int, name text)')

# tables in the database can be listed by a single function call. 

dbListTables(conn)

# Likewise, the field names for a given table can be listed referencing the connection and the table name.

dbListFields(conn, "cars")

# With a connection available, a database created and a table populated with data, queries can now be executed using the dbGetQuery function.

dbGetQuery(conn, "SELECT * FROM cars WHERE mpg > 20")

# surround your queries with double quotes so that strings in a SQL statement can be surrounded in single quotes.

dbGetQuery(conn, "SELECT * FROM cars WHERE row_names LIKE 'Merc%'")

# extracts the "make" of the car from the row name where the make and model are concatenated. 

mtcars$make <- gsub(' .*$', '', rownames(mtcars))

# The new column can now be used in queries like any of the other columns.


dbGetQuery(conn, "SELECT make, count(*) FROM mtcars GROUP BY make HAVING count(*) > 1 ORDER BY 2 DESC, 1")



# sqldf package

library(sqldf)
data(mtcars)

# The sqldf package allows you to access data frames using SQL. Regardless of where data originates, it can be queried as long as it is contained within a data frame. This means that data can  be read in from a variety of data sources (delimited files, a web pages, web APIs, a relational databases, NoSQL datasoures, etc) and subsequently queried and manipulated as if it were all in a single relational database. To see how straightforward it is, open a new R Session, install the package, load it and the mtcars data

sqldf("SELECT * FROM mtcars WHERE mpg > 20")

# If you are following along and executed this statement in RStudio, the number of rows is correct, but the row names containing the name of each car are missing.
# The reason is that row names are not standard columns and are ignored by default by sqldf. To include these rows in the output, specify row.names=TRUE when making the call.

sqldf("SELECT * FROM mtcars WHERE mpg > 20", row.names=TRUE)


# Within R, there are many ways to create new data frames. The base language contains support, and packages like dplyr and reshape are in common use. With sqldf, you can bypass the use of all of this. In fact, the sqldf call itself returns a dataframe. With this in mind, you can do sequences of calls to sqldf to incrementally process or summarize a data set.

df <- sqldf("SELECT * FROM mtcars WHERE mpg > 20", row.names=TRUE)

df

#The df object now contains a dataframe with the results of the query. If you are going to process a data frame in this way, you are better off making the row names an ordinary column value.

df$make_model<-row.names(df)

# The new column is now available in the dataframe. And any result of a query, even if it varies widely from the original is simply returned as a new data frame.

mpgSummary <- sqldf("select avg(mpg) avg, min(mpg) min, max(mpg) max from df where make_model like 'Merc%'")

mpgSummary


# FILE IMPORTS

write.csv(mtcars, 'mtcars.csv')

getwd()

# to import the dataset mtcars through GUI, click Import dataset on top right and select the local file. It is similar to 

mtcars <- read.csv("~/Desktop/r_art/simple-talk-SQL-and-R/mtcars.csv", stringsAsFactors=FALSE)

View(mtcars)

# The RJava and RJDBC Package

# JDBC is the Java analog to the ODBC standard that was original developed by Microsoft. A JDBC driver is software that enables a Java application to interact with a specific database. The RJDBC package therefore relies upon the RJava package and consequently on an underlying Java installation on an R User's machine. At times, the behavior of the Java Virtual Machine must be addressed to prevent problems. For instance, if you encounter OutOfMemoryExceptions, the solution is to increase the amount of memory available to the JVM.

options( java.parameters = "-Xmx4g" )


# Install and load the RJDBC library 

install.packages("RJDBC")
library(RJDBC)

# This example uses the free Oracle XE database and a pre-installed demo account called HR. Note that in this case, the database installation itself is on a local workstation, but completely external to R. Before running the R code, you must ensure that the HR user account is available. From an operating system prompt, connect as a user with DBA privileges. 

# sqlplus / as sysdba

# Within SQL*Plus, unlock the HR account and set the password to match the username.

# alter user HR account unlock;
# alter user HR identified by HR;

# RJDBC requires the use of a JDBC driver, in this case an Oracle JDBC driver that was installed as part of Oracle's Instant Client is used. The code below includes a Java CLASSPATH that is specific to my personal machine that must be modified to match your setup. It loads the JDBC driver which is then used to make a database connection.

drv <- JDBC("oracle.jdbc.OracleDriver",
            classPath="/Users/cas/oracle/product/instantclient_11_2/ojdbc6.jar", " ")

# A connection is established using the loaded driver, a JDBC URL, and the user and password associated with the HR account.

con <- dbConnect(drv, "jdbc:oracle:thin:@localhost:1521:XE", "HR", "HR")

# The connection is then passed in each call along with the query.

hrTables  <- dbGetQuery(con, "select * from tab")

# This query displays all of the tables available within the HR user's schema.

hrTables


# Data Manipulation in R: Beyond SQL

# Example 1: The Pivot

library(reshape2)

df<- data.frame(
  JOB_ID=c('AD_ASST','ST_MAN','PU_MAN', 'SH_CLERK'),
  DEPARTMENT_NAME = c('Administration','Shipping','Purchasing','Shipping'),
  SALARY=c(4400, 36400, 11000, 64300)
)

View(df)

# -- A pivot operation applied to the operation results in each department name being used as a column.   Essentially, the original query is wrapped in and a pivot clause is appended.  The pivot clause lists the data value and column names to use.

#select * from 
#(select job_id, department_name, sum(salary) salary 
#from  DEPARTMENTS d 
#join EMPLOYEES e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
#where job_id in ('ST_MAN','AD_ASST','PU_MAN','SH_CLERK')
#group by job_id, department_name)
#pivot (
 # sum(salary) for (department_name) in (
  #  'Administration',
  #  'Purchasing',
  #  'Shipping') 
#) order by 1;

df2<- dcast(df, JOB_ID ~  DEPARTMENT_NAME)
View(df2)

View(mtcars)
# Example 2: The Transpose

rownames(df2) <- df2$JOB_ID
df2<-df2[-1]
t(df2)
t(mtcars)

# More Reshaping of Data

df<-mtcars
df$car_name <- rownames(mtcars)

# The melt function takes each column and represents the data by creating a column to hold the (old) column name and a second column to hold the actual value.  Any columns listed in the id vector are retained.

#melt(df, id="c(""car_name"))
# melt(df)

# melt(df, id="c(""car_name","gear"))

# melted <- melt(df, id="c(""car_name"))

# The complementary function for melt is cast.  There are a few variations on this function that allow you to choose what data structure is returned.  We will use the dcast variation that returns results as a data frame. We will store the results in a variable and will look at them a bit closer in the next section.

df2 <- dcast(melted, car_name ~ variable, value.var = c("value")) 

# The row names is stored in alphabetical order in a vector.

cn <- sort(colnames(df))

#Two new dataframes are created containing the data with the columns in alphabetical order.

original<- df[cn]
reshaped<- df2[cn]

#The data itself is reordered so that rows are in alphabetical order by name.

original <- original[order(original$car_name),]
reshaped <- reshaped[order(reshaped$car_name),]

# Because rownames are metadata and we have included them as the names column in the data frames, we will not consider them in the comparison of the two data frames.

rownames(reshaped)<-NULL
rownames(original)<-NULL

#With these arrangements in place, the original dataset and the melted-recast dataset contain the same data.

all.equal(original, reshaped)

# The function call returns TRUE, indicating that the two data frames contain identical values.  If you wanted to retain this set of transformations for use in subsequent tests, you can use the following function.

normalize_df <- function(df, sort_column){
  cn <- sort(colnames(df))
  df <- df[cn]
  df <- df[order(df[sort_column]),]
  rownames(df) <- NULL
  return(df)
}

# This function can compare the data frames without the need to run each normalization step manually.

all.equal(
  normalize_df(df,  'car_name'), 
  normalize_df(df2, 'car_name')
)

# Reshaping and Tidy Data

library(tidyr)

#  The tidyr package contains methods that correspond to melt and cast:  gather and spread.  The gather function is called along with the "bare" column name - the name of the column without enclosing it in quotes.
melted_tidyr <- gather(df, car_name)

# The only difference between the dataframe in this case with the one produced by reshape2 is the rownames.  The all.equal method includes an option to ignore the rownames.

all.equal(melted, melted_tidyr, check.names=FALSE)

# The function call returns TRUE.  We will ensure that the column names are unique by explicitly naming them and then call the spread function to convert the data back to its original format.

colnames(melted_tidyr ) <- c('car_name', 'variable', 'value')
spread_tidyr <- spread(melted_tidyr, variable, value)

#The final result is a data frame that matches the original (once the data frames are normalized).

all.equal(
  normalize_df(df, 'car_name'), 
  normalize_df(spread_tidyr, 'car_name')
)


# SQL-like Manipulations in a Functional Style

library(dplyr)

# SELECT

# The functions that correspond to the SQL SELECT statement are select() and mutate().  We will use a piping operator to chain together calls on the data frame based on the mtcars data frame.  The mutate column is used to add derived data frame columns.  In this case, we will append the car name, the number of cylinders and the string literal cylinder.  This new column will be named description.  We then filter which columns will be viewable and restrict them to the new description column and the gear column.  Finally, we will pipe to the View function (which is not part of dplyr) which will display the final result

df %>% 
  mutate(description=paste(car_name, cyl, 'cylinder')) %>%
  select(description, gear) %>% 
  View()

# ORDER BY

# The ORDER BY function is used to sort the data based on one or more columns.  The arrange function is the dplyr equivalent.   

df %>% select(car_name) %>% arrange(car_name) %>% View() 

# GROUP BY

# The SQL GROUP BY clause is used in close conjunction with aggregate functions like SUM() and MEAN().  The clause indicates the level of grouping at which a given summary function is applied.  When using  the dplyr package, it is common practice to use the summarize and  group_by functions together.

df %>% group_by(cyl) %>% summarize(mean(hp)) %>% View()

# In SQL, it is necessary to list the columns referenced in the GROUP BY clause in the SELECT clause - along with any aggregate functions.  The dplyr package just requires you to specify the function used to aggregate in the summarize clause.  The dplyr functions can be chained together in creative ways that would require nested subqueries in SQL.  For instance, if you wanted to compare the average just calculated with the actual value in each row, this can be accomplished using the mutate function rather than summarize

df %>% group_by(cyl) %>% 
  mutate(mhp=mean(hp)) %>% 
  select(cyl, hp, mhp) %>%
  arrange(cyl, hp) %>% View()


# WHERE/HAVING

# The WHERE clause in SQL is used to filter which rows are returned.  The HAVING clause is used when evaluating summaries that rely upon a GROUP BY.  The simplest case is filtering using an equality operator. 

df %>% filter(car_name=='Volvo 142E') %>% View()

# This example is essentially the same usage that you would obtain using a WHERE clause in SQL.  The next example uses an aggregate function inside of a filter function.  This corresponds with the SQL HAVING clause.  Note that the results include records which have an actual horse power (hp) that is less than 200.  However, they are part of the grouping (by cyl) that is greater than 200.

df %>% group_by(cyl) %>% 
  mutate(mhp=mean(hp)) %>% 
  filter(mhp > 200 & mpg < 17) %>% 
  select(car_name, mhp, hp, mpg) %>% 
  View()

# =====================================================================================================================================================

