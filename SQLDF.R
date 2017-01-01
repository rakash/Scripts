install.packages("babynames")
library(babynames)
str(babynames)
install.packages("sqldf")
library(sqldf)

mydata <- babynames

sqldf("select count(*) from mydata")

sqldf("select * from mydata limit 10")

sqldf("select year, sex, name from mydata limit 10")

#filtering data
sqldf("select year,name, sex as 'Gender' from mydata where sex == 'F' limit 20")

sqldf("select * from mydata where prop > 0.05 limit 20")

sqldf("select * from mydata where sex != 'F' ")

sqldf("select year,name,4*prop as 'final_prop' from mydata where prop <= 0.40 limit 10")


sqldf("select * from mydata order by year desc limit 20") #order by 1 condition
sqldf("select * from mydata order by year desc,n desc limit 20") #order by 2 conditions
sqldf("select * from mydata order by name limit 20") #order alphabetically



sqldf("select * from mydata where name like 'Ben%' ") #name starts with Ben
sqldf("select * from mydata where name like '%man'limit 30") #name ends with man
 sqldf("select * from mydata where name like '%man%' ") #name must contain man
 sqldf("select * from mydata where name in ('Coleman','Benjamin','Bennie')") #using IN
 sqldf("select * from mydata where year between 2000 and 2014") #using BETWEEN


 
 #multiple filters - and,or,not
 
sqldf("select * from mydata where year >= 1980 and prop <0.5")

sqldf("select * from mydata where year >= 1980 and prop <0.5 order by prop desc")

sqldf("select * from mydata where name != '%man%' or year > 2000") #no man in name 

sqldf("select * from mydata where prop > 0.07 and year not between 2000 and 2014")

sqldf("select * from mydata where n > 10000 order by name desc ")



#basic aggregations
sqldf("select sum(n) as 'Total_Count' from mydata")
sqldf("select min(n), max(n) from mydata")
sqldf("select year,avg(n) as 'Average' from mydata group by year order by Average desc") #average by year
sqldf("select year,count(*) as count from mydata group by year limit 100") #count by year
sqldf("select year,n,count(*) as 'my_count' from mydata where n > 10000 group by year order by my_count desc limit 100") #multiple filters 


#use having
sqldf("select year,name,sum(n) as 'my_sum' from mydata group by year, name having my_sum > 10000 order by my_sum desc limit 100")


#unique count for a variable
sqldf("select count(distinct name) as 'count_names' from mydata ")


sqldf("select year, n, case when year = '2014' then 'Young' else 'Old' end as 'young_or_old' from mydata limit 10")

sqldf("select *, case when name != '%man%' then 'Not_a_man' when name = 'Ban%' then 'Born_with_Ban' else 'Un_Ban_Man' end as 'Name_Fun' from mydata")

# FROM CSV

crash <- read.csv.sql("crashes.csv",sql = "select * from file")

roads <- read.csv.sql("roads.csv",sql = "select * from file")


#join the data sets
sqldf("select * from crash join roads on crash.Road = roads.Road ")#inner join
sqldf("select crash.Year, crash.Volume, roads.* from crash left join roads on crash.Road = roads.Road") #left join

#joining while aggregation
sqldf("select crash.Year, crash.Volume, roads.* from crash left join roads on crash.Road = roads.Road order by 1")
sqldf("select crash.Year, crash.Volume, roads.* from crash left join roads on crash.Road = roads.Road where roads.Road != 'US-36' order by 1")
sqldf("select Road, avg(roads.Length) as 'Avg_Length', avg(N_Crashes) as 'Avg_Crash' from roads join crash using (Road) group by Road")


#besides Road, adding Year variable as a key
roads$Year <- crash$Year[1:5]
sqldf("select crash.Year, crash.Volume, roads.* from crash left join roads on crash.Road = roads.Road and crash.Year = roads.Year order by 1") #multiple keys


library(RSQLite)
help("initExtension")

#some string functions
sqldf("select name,leftstr(name,3) as 'First_3' from mydata order by First_3 desc limit 100")
sqldf("select name,reverse(name) as 'Rev_Name' from mydata limit 100")
sqldf("select name,rightstr(name,3) as 'Back_3' from mydata order by First_3 desc limit 100")


# https://www.codecademy.com/learn/learn-sql

# https://www.codecademy.com/learn/sql-analyzing-business-metrics
