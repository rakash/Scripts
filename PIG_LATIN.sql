field/ atom - like a cell

tuple - like a row

bag - collection of rows

maps - key-value pair

Relation - Bag of tuples

# APACHE PIG EXECUTION MECHANISMS:

1) Interactive Mode (Grunt shell)
2) Batch Mode (Script)
3) Embedded Mode (UDF)

Interactive Mode:

LOCAL mode:

$ ./pig -x local

mapreduce mode

$ ./pig -x mapreduce

grunt >

Example statement -- grunt> customers = LOAD 'customers.txt' USING PigStorage(',');

# EXECUTING APACHE PIG IN BATCH MODE:

sample_script.pig

student = LOAD 'hdfs://localhost:9000/pig_data/student.txt' USING
   PigStorage(',') as (id:int,name:chararray,city:chararray);
  
Dump student;

Now, you can execute the script in the above file as shown below

Local mode -- $ pig -x local Sample_script.pig

Mapreduce mode -- $ pig -x mapreduce Sample_script.pig


# SHELL COMMANDS :

sh Command -- we can invoke any shell commands from the Grunt shell
 sh shell command parameters
 
 
 
 

