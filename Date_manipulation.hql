-- Input file for unixtimestamp conversion
-- Output should have the date in format MM/dd/yy for all the rows
customer:

cust_id   cust_name   cust_birthday
08339     John        Jan 11,2003
82382     Vicki       06/17/1969
32323     Jenny       8/10/54

-- Create the input table with the above data

drop table if exists customer;

create table customer(
cust_id int,
cust_name string,
cust_birthday string)
row format delimited
fields terminated by '\t'
lines terminated by '\n'
stored as textfile; 

load data local inpath '/users/s061332/hive_input1.txt' into table problem1_dept;

-- Insert overwrite into an new table with the required output

insert overwrite table problem1_solution
select
cust_id,
cust_name,
(case
when trim(cust_birthday)=(from_unixtime(unix_timestamp(cust_birthday,'MMM dd,yyyy'),'MMM dd,yyyy')) then (from_unixtime(unix_timestamp(cust_birthday,'MMM dd,yyyy'),'MM/dd/yy'))
when trim(cust_birthday)=(from_unixtime(unix_timestamp(cust_birthday,'MM/dd/yyyy'),'MM/dd/yyyy')) then(from_unixtime(unix_timestamp(cust_birthday,'MM/dd/yyyy'),'MM/dd/yy'))
when trim(cust_birthday)=(from_unixtime(unix_timestamp(cust_birthday,'MM/dd/yy'),'MM/dd/yy')) then (from_unixtime(unix_timestamp(cust_birthday,'MM/dd/yy'),'MM/dd/yy'))
end) as cust_birthday
from customer;


-- To add or subtract days/ months from an date field you can use the below;

add_months(date,-1) - Subtract exactly a month from the date passed

date_sub(date,1) - Subtract the number of days from the date passed
