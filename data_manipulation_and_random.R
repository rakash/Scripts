# GENERAL RANDOM PRACTICE

c(1, 4, 5, 9, 10)[!c(1, 4, 5, 9, 10) %in% c(1, 5, 10, 11, 13)
                  ]
mean_impute <- function(x) { x[is.na(x)] <- mean(x, na.rm = TRUE); x }

gender = factor(c("m","f","f","m","f","f"))
x = table(gender)
x
cumsum(x)


t = data.frame(table(gender))
t$cumfreq = cumsum(t$Freq)
t$cumfreq
t$Freq
t$cumpercent= round(t$cumfreq / sum(t$Freq)*100,2)
t$cumpercent


mydata = sample(LETTERS[1:5],16,replace = TRUE)
mydata.count= table(mydata)

mydata
pie(mydata.count, col=rainbow(12))

x = c(1:7)
y = c("m","f","f","m","f")


rbind(x,y)

cbind(x,y)


df = data.frame(x = c(1:4), y = c("m","f","f","m"))
df2 = data.frame(x = c(5:8))


df
df2


library(dplyr)
combdf = bind_rows(df,df2)
combdf


library(dplyr)
data %>% mutate(var=coalesce(X,Y,Z))

apply, lapply , sapply, vapply, mapply, rapply, and tapply


A<-matrix(1:9, 3,3)
B<-matrix(4:15, 4,3)
C<-matrix(8:10, 3,2)
MyList<-list(A,B,C) # display the list
MyList

lapply(MyList,"[", , 2)


sapply is almost lapply but returns vector instead of list. unless simplify = F specified..

Conversely, a function like unlist, can tell lappy to give us a vector:
  
  unlist(lapply(MyList,"[", 2,1 ))


apply - When you want to apply a function to the rows or columns or both of a matrix and output is a one-dimensional if only row or column is selected else it is a 2D-matrix 
lapply - When you want to apply a function to each element of a list in turn and get a list back.
sapply - When you want to apply a function to each element of a list in turn, but you want a vector back, rather than a list.
tapply - When you want to apply a function to subsets of a vector and the subsets are defined by some other vector, usually a factor.


ifelse(is.na(df$var1), 0,1)


start.time <- Sys.time()
runif(5555,1,1000)
end.time <- Sys.time()
end.time - start.time


temp = data.frame(v1<-c(1:10),v2<-c(5:14))
temp 
temp1 = data.frame(v1=c(1:10),v2=c(5:14))
temp1



df <- na.omit(mydata)


mydate <- as.POSIXlt("2015-09-27 12:02:14")
library(lubridate)
date(mydate) # Extracting date part
format(mydate, format="%H:%M:%S") # Extracting time part
month(mydate)
second(mydate)


============================================================================
  
# Data manipulation  -- https://www.analyticsvidhya.com/blog/2015/12/faster-data-manipulation-7-packages/
  

# 1. dplyr::

library(dplyr)  
cars <- data(mtcars)
cars
iris <- data('iris')
head(cars)
data("mtcars")
cars <- data("mtcars")
head(cars)
data("iris")
mydata < mtcars

str(mydata)


#creating a local dataframe. Local data frame are easier to read

mynewdata <- tbl_df(mydata)
myirisdata <- tbl_df(iris)

head(myirisdata)

#use filter to filter data with required condition
filter(mynewdata, cyl > 4 & gear > 4 )

filter(myirisdata, Species %in% c('setosa', 'virginica'))

#use select to pick columns by name
select(mynewdata, cyl,mpg,hp)

#here you can use (-) to hide columns
select(mynewdata, -cyl, -mpg ) 

#hide a range of columns
select(mynewdata, -c(cyl,mpg))

#select series of columns

select(mynewdata, cyl:gear)


#chaining or pipelining - a way to perform multiple operations
#in one line
mynewdata %>%
  select(cyl, wt, gear)%>%
  filter(wt > 2)


#arrange can be used to reorder rows
mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(wt)


mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(desc(wt))


#mutate - create new variables

mynewdata %>%
  select(mpg, cyl)%>%
  mutate(newvariable = mpg*cyl)

OR 

newvariable <- mynewdata %>% mutate(newvariable = mpg*cyl)

#summarise - this is used to find insights from data
myirisdata%>%
  group_by(Species)%>%
  summarise(Average = mean(Sepal.Length, na.rm = TRUE))

#or use summarise each
myirisdata%>%
  group_by(Species)%>%
  summarise_each(funs(mean, n()), Sepal.Length, Sepal.Width)

#you can rename the variables using rename command
mynewdata %>% rename(miles = mpg)

# 2. data.table package. 

# A data table has 3 parts namely DT[i,j,by].
# You can understand this as, we can tell R to subset the rows using 'i', to calculate 'j' which is grouped by 'by'. 
# Most of the times, 'by' relates to categorical variable.


#load data
data("airquality")
mydata <- airquality
head(airquality,6)

data(iris)
myiris <- iris

#loAD package
library(data.table)

mydata <- data.table(mydata)
mydata

myiris <- data.table(myiris)
myiris

#subset rows - select 2nd to 4th row

mydata[2:4,]

#select columns with particular values
myiris[Species == 'setosa']

#select columns with multiple values. This will give you columns with Setosa
#and virginica species
myiris[Species %in% c('setosa', 'virginica')]

#select columns. Returns a vector
mydata[,Temp]

#returns sum of selected column
mydata[,sum(Ozone, na.rm = TRUE)]


# returns sum and standard deviation
mydata[,.(sum(Ozone, na.rm = TRUE), sd(Ozone, na.rm = TRUE))]

#print and plot
myiris[,{print(Sepal.Length)
plot(Sepal.Width)
  NULL}]


#grouping by a variable
myiris[,.(sepalsum = sum(Sepal.Length)), by=Species]

#select a column for computation, hence need to set the key on column
setkey(myiris, Species)

#selects all the rows associated with this data point
myiris['setosa']
myiris[c('setosa', 'virginica')]


# 3. ggplot2

library(ggplot2)
install.packages("gridExtra")
install.packages("cowplot")
require(cowplot)
library(gridExtra)
df <- ToothGrowth

df$dose <- as.factor(df$dose)
head(df)

#boxplot
bp <- ggplot(df, aes(x = dose, y = len, color = dose)) + geom_boxplot() + theme(legend.position = 'none')
bp

#add gridlines
bp + background_grid(major = "xy", minor = 'none')

#scatterplot
sp <- ggplot(mpg, aes(x = cty, y = hwy, color = factor(cyl)))+geom_point(size = 2.5)
sp


#barplot
bp <- ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() +theme(axis.text.x = element_text(angle = 70, vjust = 0.5))
bp


#compare two plots
plot_grid(sp, bp, labels = c("A","B"), ncol = 2, nrow = 1)


#histogram
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth = 0.25, fill = 'steelblue')+
  scale_x_continuous(breaks=seq(0,3, by=0.5))

# 4.  Reshape2 package

# melt function 

#create a data
ID <- c(1,2,3,4,5)
Names <- c('Joseph','Matrin','Joseph','James','Matrin')
DateofBirth <- c(1993,1992,1993,1994,1992)
Subject<- c('Maths','Biology','Science','Psycology','Physics')
thisdata <- data.frame(ID, Names, DateofBirth, Subject)
data.table(thisdata)

#load package
install.packages('reshape2')
library(reshape2)

#melt 
mt <- melt(thisdata, id=(c('ID','Names')))
mt


#cast
mcast <- dcast(mt, DateofBirth + Subject ~ variable)
mcast


# 5. ReadR 

Delimited files withread_delim(), read_csv(), read_tsv(), andread_csv2().
Fixed width files with read_fwf(), and read_table().
Web log files with read_log()

install.packages("readr")
library(readr)

read_csv('test.csv',col_names = TRUE)

read_csv("iris.csv", col_types = list(
  Sepal.Length = col_double(),
  Sepal.Width = col_double(),
  Petal.Length = col_double(),
  Petal.Width = col_double(),
  Species = col_factor(c("setosa", "versicolor", "virginica"))
))


# choose to omit unimportant columns

read_csv("iris.csv", col_types = list(
  Species = col_factor(c("setosa", "versicolor", "virginica"))
)

# 6. TidyR package


gather() - it 'gathers' multiple columns. Then, it converts them into key:value pairs. This function will transform wide from of data to long form. You can use it as in alternative to 'melt' in reshape package.
spread() - It does reverse of gather. It takes a key:value pair and converts it into separate columns.
separate() - It splits a column into multiple columns.
unite() - It does reverse of separate. It unites multiple columns into single column

library(tidyr)

#create a dummy data set
names <- c('A','B','C','D','E','A','B')
weight <- c(55,49,76,71,65,44,34)
age <- c(21,20,25,29,33,32,38)
Class <- c('Maths','Science','Social','Physics','Biology','Economics','Accounts')

#create data frame
tdata <- data.frame(names, age, weight, Class)
tdata

#using gather function
long_t <- tdata %>% gather(Key, Value, weight:Class)
long_t

#create a data set
Humidity <- c(37.79, 42.34, 52.16, 44.57, 43.83, 44.59)
Rain <- c(0.971360441, 1.10969716, 1.064475853, 0.953183435, 0.98878849, 0.939676146)
Time <- c("27/01/2015 15:44","23/02/2015 23:24", "31/03/2015 19:15", "20/01/2015 20:52", "23/02/2015 07:46", "31/01/2015 01:55")

#build a data frame
d_set <- data.frame(Humidity, Rain, Time)


#using separate function we can separate date, month, year
separate_d <- d_set %>% separate(Time, c('Date', 'Month','Year'))
separate_d

#using unite function - reverse of separate
unite_d <- separate_d%>% unite(Time, c(Date, Month, Year), sep = "/")
unite_d

#using spread function - reverse of gather
wide_t <- long_t %>% spread(Key, Value)
wide_t

# 7. Lubridate

library(lubridate)

#current date and time
now()

#assigning current date and time to variable n_time
n_time <- now()

#using update function
n_update <- update(n_time, year = 2013, month = 10)
n_update


#add days, months, year, seconds
d_time <- now()
d_time + ddays(1)

d_time + dweeks(2)

d_time + dyears(3)

d_time + dhours(2)

d_time + dminutes(50)

d_time + dseconds(60)

d_time

#extract date,time
n_time$hour <- hour(now())
n_time$minute <- minute(now())
n_time$second <- second(now())
n_time$month <- month(now())
n_time$year <- year(now())


new_data <- data.frame(n_time$hour, n_time$minute, n_time$second, n_time$month, n_time$year)
new_data


=============================================================================
  
  
  