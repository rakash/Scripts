--Create table

CREATE Table realEstate ( Street string.City, string.zip, int.State, String.Beds, int.Baths, int sq_feet, int.flat_type, String.Price, int) row format delimited FIELDS terminated
BY ' , ' stored AS textfile;

--Load data into Hive

load data local inpath ‘/home/hadoop/Downloads/real_state.csv’ into table realEstate;

--Problem Statement 1:

--City wise list all the Condos which is not less than ten thousand.

select * from realEstate where ((price>10000) AND (type ==’Condo’)) group by city;


--Problem Statement 2:

-- In GALT city which residential type has more than 800sq__ft. Display their respective details street,sq__ft,sale_date,city.

Select street,sq__ft,sale_date,city from realEstate where ((city==’GALT’) AND (sq__ft>800));


-- Problem Statement 3:

-- Which is the cheapest Condo in CA. name the city,street and price for the Condo.

Select street,city,price from realEstate where type==’Condo’ order by price limit 1;

-- Problem Statement 4:	

-- List top 5 residency details which lie in the budget of 60000-120000, an area more than 1450, sold after 17th may, min bedroom 3 and, min bathroom 2.

Select street,city,zip,state,beds,baths,sq__ft,type,sale_date,price from realEstate where((price>=60000 and price<=120000) AND (sq__ft>1150) AND (beds>2) AND (baths>1)) order by price limit 5;

-- Problem Statement 5:

-- separate list of residential apartments with more than 2 beds. Also include columns in following order City,Baths,Sq_feet,Price,flat_type,Beds respectively.

-- Hence Creating table to do partitioning

CREATE TABLE interestedBHK( City string,Baths int,Sq_feet int,Price int) partitioned BY (flat_type string, Beds int)row format delimited FIELDS terminated BY ‘,’ stored AS textfile;

-- load data and  Hence query formed:

insert into table interestedBHK partition(flat_type,Beds) select City,Baths,Sq_feet,Price,flat_type,Beds from realEstate where (Beds>2 and flat_type=’Residential’);


--PARTITION EXAMPLE: https://acadgild.com/blog/partitioning-in-hive/


CREATE TABLE par_user (first_name varchar(60), lastname varchar(60), roll_no varchar(60) partitioned by (country varchar(60), state varchar(60)) row format delimited fields
terminated by ' , ' stored as textfile;

show tables; 

describe formatted par_user;


-- 2 types of partitioning - Static and Dynamic

--Steps for static partitioning:
-- 1.Creating input files for partitioning:

	-- user_info - sathyam, kumar, 89  ; userinfo1 - manish, kumar , 76
	
-- 2.Copying the input files:

load data local inpath 'path_to_file' into table par_user partition(country = 'us' , state = 'fl'); --user_info

load data local inpath 'path_to_file' into table par_user partition(country = 'ca' , state = 'au'); --user_info1

-- 3.Retrieving the user information:

select * from par_user where par_user.country = 'us' and par_user.state = 'fl';

--similarly for ca and au, if needed 

select * from par_user where par_user.country = 'ca' and par_user.state = 'au';


-- When to use dynamic partitioning:

--1.Creating tables:

--We need to create the partitioned table par_user as shown below.

create table par_user (first_name VARCHAR(60), lastname varchar(60), roll_no varchar(60)) partitioned by ( country varchar(60), state varchar(60)) row format
delimited fields terminated by ' , ' stored as textfile;


create table user1 (first_name VARCHAR(60), lastname varchar(60), roll_no varchar(60), country string, state string)  row format
delimited fields terminated by ' , ' stored as textfile;

-- 2.Creating input file for dynamic partitioning:

-- 3.Loading input file into user1 table:

load data inpath 'file_path' into table user1;


--4.Setting of parameters for dynamic partitioning:

--To use the dynamic partitioning in hive we need to set the below parameters in hive shell or in hive-site.xml file.

--In this case we have set the below properties in hive shell.

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.exec.max.dynamic.partitions=1000;
set hive.exec.max.dynamic.partitions.pernode=1000;


-- 5.Retrieving data from partitioned table:

insert into table par_user partition ( country, state) select first_name, lastname, roll_no, country, state from user1;


-- The command to display the records present in different partition.
-- The actual records in the partition.

hadoop dfs -cat /user/hive/warehouse/new_sample_database.db/par_user/country=ca/state=au/000000_0
hadoop dfs -cat /user/hive/warehouse/new_sample_database.db/par_user/country=us/state=fl/000000_0



