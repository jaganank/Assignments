use ineuron;

create table city(
id int,
cname varchar(17),
countrycode varchar(10),
district varchar(30),
population int);

/* Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
The CountryCode for America is USA.
*/
select * from city where countrycode='USA' and population > 100000;

/* Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
The CountryCode for America is USA  */

select cname from city where countrycode='USA' and population > 120000;

/*Q3. Query all columns (attributes) for every row in the CITY table. */

select * from city;

/* Q4. Query all columns for a city in CITY with the ID 1661. */

select * from city where id=1661;

/* Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is
JPN. */

select * from city where countrycode='JPN';

/*Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is
JPN.
 */
 
 select cname from city where countrycode='JPN';

create table station(
id int,
city varchar(30),
state varchar(2),
lat_n int,
long_w int);

/* Q7. Query a list of CITY and STATE from the STATION table. */
select city,state from station;


/* Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
in any order, but exclude duplicates from the answer. */

select distinct city from station where mod(id,2)=0 order by city asc;

/*Q9. Find the difference between the total number of CITY entries in the table and the number of
distinct CITY entries in the table */

select count(CITY) - count(distinct city) from station;

/* Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
largest city, choose the one that comes first when ordered alphabetically */

select   city,length(city) from station 
where length(city) in (select max(length(city)) from station 
						union select min(length(city)) from station)
						order by length(city) desc,
                        city asc limit 2;
                        
/*Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
cannot contain duplicates.
Input Format
 */
 
 select distinct city from station where city regexp'^[aeiou]';
 
 /*Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
contain duplicates. */

select distinct city from station
where right(city,1) in ('a', 'e', 'i', 'o', 'u');
                        
/* Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
contain duplicates.
 */
 
 select distinct city from station where city not regexp'^[aeiouAEIOU]';
 
 /* Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot
contain duplicates.
 */
 
select distinct city from station
where right(city,1)  not in ('a', 'e', 'i', 'o', 'u');

/* Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
with vowels. Your result cannot contain duplicates.
*/

select distinct city from station where not city rlike '^[AEIOUaeiou]' and not city rlike '.*[AEIOUaeiou]$' 

/* Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
vowels. Your result cannot contain duplicates.
 */

select city from station where lower(substr(city,1,1)) not in ('a','e','i','o','u') and lower(substr(city,length(city),1)) not in ('a','e','i','o','u');    

/* Q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive. Return the result table in any order. */

create table product(
product_id  int not null,
product_name varchar(30),
unit_price int,
primary key (product_id));
  
 desc product;
 
 create table sales(
 seller_id int,
 product_id int,
 product_name varchar(30),
 buyer_id int,
 sale_date date,
 quantity int,
 price int,
 foreign key (product_id) references product(product_id));

insert into product(product_id,product_name,unit_price) values (1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);

select * from product;

insert into sales(seller_id,product_id,product_name,buyer_id,sale_date,quantity,price) values
(1,1,'S8',1,'2019-01-21',2,2000),(1,2,'G4',2,'2019-02-17',1,800),(2,2,'G4',3,'2019-06-02',1,800),(3,3,'iPhone',4,'2019-05-13',2,2800);

select product_id,product_name from product where product_id not in (select product_id from sales where sale_date not between '2019-01-01' and '2019-03-31');

select Product.product_id,Product.product_name from product join sales on Product.product_id = Sales.product_id group by product_id having min(sale_date) >= '2019-01-01' and max(sale_date) <= '2019-03-31';

  /*Q18. Write an SQL query to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.
 */
 
 create table views(
 article_id int,
 author_id int,
 viewer_id int,
 view_date date);
 
 insert into views values(1,3,5,'2019-08-01');
 insert into views values(1,3,6,'2019-08-02');
 insert into views values(2,7,7,'2019-08-01');
 insert into views values(2,7,6,'2019-08-02');
 insert into views values(4,7,1,'2019-07-22');
 insert into views values(3,4,4,'2019-07-21');
 insert into views values(3,4,4,'2019-07-21');
 
 select distinct author_id from views where viewer_id = author_id order by author_id asc;
 
 /* Q19 Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
places.
 */
 
 create table delivery(
 delivery_id int not null,
 customer_id int,
 order_date date,
 customer_pref_delivery_date date,
 primary key (delivery_id));


insert into delivery value(1,1,'2019-08-01','2019-08-02');
insert into delivery value(2,5,'2019-08-02','2019-08-02');
insert into delivery value(3,1,'2019-08-11','2019-08-11');
insert into delivery value(4,3,'2019-08-24','2019-08-26');
insert into delivery value(5,4,'2019-08-21','2019-08-22');
insert into delivery value(6,2,'2019-08-11','2019-08-13');

select round(sum(order_date = customer_pref_delivery_date) * 100 / count(*),2) as immediate_percentage from delivery;

/* Q20. Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
tie.  */

create table ads(
ad_id int not null,
user_id int not null,
action enum('Clicked','Viewed','Ignored') not null,
primary key (ad_id,user_id));


insert into ads value(1,1,'Clicked');
insert into ads value(2,2,1);
insert into ads value(3,3,'Viewed');
insert into ads value(5,5,'Ignored');
insert into ads value(1,7,'Ignored');
insert into ads value(2,7,'Viewed');
insert into ads value(3,5,'Clicked');
insert into ads value(1,4,'Viewed');
insert into ads value(2,11,'Viewed');
insert into ads value(1,2,'Clicked');

select ad_id, ifnull(round(sum(action='Clicked') / sum(action != 'Ignored') *100,2),0) ClickThroughRate 
from ads group by ad_id order by ClickThroughRate desc,ad_id;

/* Q21. Write an SQL query to find the team size of each of the employees. */

create table employee(
employee_id int not null,
team_id int,
primary key (employee_id));

insert into employee value(1,8);
insert into employee value(2,8);
insert into employee value(3,8);
insert into employee value(4,7);
insert into employee value(5,9);
insert into employee value(6,9);

select employee_id,count(team_id) over (partition by  team_id) team_size from employee; 

/* 
Q22. Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
 */

create table countries(
country_id int not null,
country_name varchar(25),
primary key (country_id));

drop table weather

create table weather(
country_id int not null,
weather_state int,
day date,
foreign key (country_id) references countries(country_id));


select country_name, case when avg(weather_state) <= 15 then "Cold"
                          when avg(weather_state) >= 25 then "Hot"
                          else "Warm" end as weather_type
from Countries inner join Weather
on Countries.country_id = Weather.country_id
where left(day, 7) = '2019-11'
group by country_name


/* Q23. Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.  */

create table prices(
product_id	int,
start_date date,
end_date date,
price int);


create table unitsold(
product_id int,
purchase_date date,
units int
);

insert into prices values(1,'2019-02-17','2019-02-28',5);
insert into prices values(1,'2019-03-01','2019-03-22',20);
insert into prices values(2,'2019-02-01','2019-02-20',15);
insert into prices values(2,'2019-02-21','2019-03-31',30);

insert into unitsold values(1,'2019-02-25',100);
insert into unitsold values(1,'2019-03-01',15);
insert into unitsold values(2,'2019-02-10',200);
insert into unitsold values(2,'2019-03-22',30);

select u.product_id, round(sum(units * price)/sum(units),2) as Average_Price from unitsold u 
inner join prices p on u.product_id = p.product_id
where u.purchase_date between p.start_date and p.end_date
group by u.product_id;

/*Q24. Write an SQL query to report the first login date for each player.
  */
  
  create table activity(
  player_id int,
  device_id int,
  event_date date,
  games_played int);
  

insert into activity values(1,2,'2016-03-01',5);
insert into activity values(1,2,'2016-05-02',6);
insert into activity values(2,3,'2017-06-25',1);
insert into activity values(3,1,'2016-03-02',0);
insert into activity values(3,4,'2018-07-03',5);

select player_id,min(event_date) as first_login from activity group by player_id;

/*Q25. Write an SQL query to report the device that is first logged in for each playe  */

select player_id,min(device_id) as device_id from activity group by player_id;

/*Q26. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount.
 */

create table products(
product_id int not null,
product_name varchar(30),
product_category varchar(20),
primary key (product_id));


create table orders(
product_id int,
order_date date,
unit int,
foreign key (product_id) references products(product_id));

select  p.product_name , sum(o.unit) as Unit from products p join orders o on p.product_id=o.product_id 
where month(o.order_date)=2 and year(o.order_date) = 2020 
group by o.product_id 
having Unit >=100;

/* Q27. Write an SQL query to find the users who have valid emails.
 */

create table users(
user_id int,
name varchar(30),
mail varchar(45),
primary key(user_id));

insert into users values(1,'Winston','winston@leetcode.com');
insert into users values(2,'Jonathan','jonathanisgreat');
insert into users values(3,'Annabelle','bella-@leetcode.com');
insert into users values(4,'Sally','sally.come@leetcode.com');
insert into users values(5,'Marwan','quartz#2020@leetcode.com');
insert into users values(6,'David','david69@gmail.com');
insert into users values(7,'Shapiro','.shapo@leetcode.com');

select user_id,name,mail from users where mail regexp '^[A-Za-z][A-Za-z0-9\_\.\-]*@leetcode\.com$';

/*Q28.  Write an SQL query to report the customer_id and customer_name of customers who have spent at
least $100 in each month of June and July 2020.  */

create table customers(
customer_id int,
name varchar(20),
country varchar(10),
primary key (customer_id));


create table product(
product_id int,
description varchar(20),
price int,
primary key (product_id));

/*
set foreign_key_checks=0;
drop table orders;
set foreign_key_checks=1;
*/

create table orders(
order_id int,
customer_id int,
product_id int,
order_date date,
quantity int,
foreign key (customer_id) references customers(customer_id),
foreign key (product_id) references product(product_id));

select o.customer_id,c.name from customers c,product p,orders o 
where c.customer_id = o.customer_id and p.product_id = o.product_id
group by o.customer_id
having 
(
	sum(case when o.order_date like '2020-06%' then o.quantity * p.price else 0 end) >= 100
	and
	sum(case when o.order_date like '2020-07%' then o.quantity * p.price else 0 end) >= 100
);

/* Q29. Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020 */

create table tvprogram(
program_date datetime,
content_id int,
channel varchar(20),
primary key(program_date,content_id));


create table content(
content_id varchar(10),
title varchar(30),
kids_content  enum('Y','N'),
content_type  varchar(10),
primary key (content_id));

select distinct c.title from content c join tvprogram t using(content_id)
where c.kids_content = 'Y'and c.content_type = 'Movies'and t.program_date like '2020-06%'; 

/* Q30. Write an SQL query to find the npv of each query of the Queries table. */

create table npv(
id int,
year int,
npv int,
primary key(id,year));

create table queries(
id int,
year int,
primary key(id,year));

/* select distinct c.title from content c join tvprogram t using(content_id)
where c.kids_content = 'Y'and c.content_type = 'Movies'and t.program_date like '2020-06%';  */

select q.id,q.year,ifnull(n.npv,0) as npv from queries as q 
left join npv as n 
on (q.id,q.year) = (n.id,n.year);

/* Q31.Write an SQL query to find the npv of each query of the Queries table. */

select q.id,q.year,ifnull(n.npv,0) as npv from queries as q 
left join npv as n 
on (q.id,q.year) = (n.id,n.year);

/* Q32 Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.  */

create table employees(
id int,
name varchar(20),
primary key(id));

create table employeeuni(
id int,
unique_id int,
primary key(id,unique_id));

select unique_id,name from employees 
left join
employeeuni using(id);

/*Q33 Write an SQL query to report the distance travelled by each user. */

create table User(
id int,
name varchar(20),
primary key(id));

create table rides(
id int,
user_id int,
distance int,
primary key(id));

select name,sum(ifnull(distance,0)) as travelled_distance from rides r 
right join User  u
on r.user_id= u.id
group by name
order by 2 desc,1 asc;

/* Q34. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount. */


create table products(
product_id int,
product_name varchar(30),
product_category varchar(20),
primary key (product_id));
 

create table orders(
product_id int,
order_date date,
unit int,
foreign key (product_id) references products(product_id));

insert into products values(1,'Leetcode Solutions','book');
insert into products values(2,'Jewels of Stringology','book');
insert into products values(3,'HP','laptop');
insert into products values(4,'Lenova','laptop');
insert into products values(5,'Leetcode kit','T-shirt');

insert into orders values(1,'2020-02-05',60);
insert into orders values(1,'2020-02-10',70);
insert into orders values(2,'2020-01-18',30);
insert into orders values(2,'2020-02-11',80);
insert into orders values(3,'2020-02-17',2);
insert into orders values(3,'2020-02-24',3);
insert into orders values(4,'2020-03-01',20);
insert into orders values(4,'2020-03-04',30);
insert into orders values(4,'2020-03-04',60);
insert into orders values(5,'2020-02-25',50);
insert into orders values(5,'2020-02-27',50);
insert into orders values(5,'2020-03-01',50);

select  p.product_name , sum(o.unit) as Unit from products p join orders o on p.product_id=o.product_id 
where month(o.order_date)=2 and year(o.order_date) = 2020 
group by o.product_id
having Unit >=100;

/* Q35. Write an SQL query to:
● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name
*/

create table movies(
movie_id int,
title varchar(30),
primary key (movie_id));


create table users(
user_id int,
u_name varchar(30),
primary key (user_id));

create table movierating(
movie_id int,
user_id int,
rating int,
created_at date,
foreign key (movie_id) references movies(movie_id),
foreign key (user_id) references users(user_id));

insert into movies values(1,'Avengers');
insert into movies values(2,'Frozen 2');
insert into movies values(3,'Joker');

insert into users values(1,'Daniel');
insert into users values(2,'Monica');
insert into users values(3,'Maria');
insert into users values(4,'James');

insert into movierating values(1,1,3,'2020-01-12');
insert into movierating values(1,2,4,'2020-02-11');
insert into movierating values(1,3,2,'2020-02-12');
insert into movierating values(1,4,1,'2020-01-01');
insert into movierating values(2,1,5,'2020-02-17');
insert into movierating values(2,2,2,'2020-02-01');
insert into movierating values(2,3,2,'2020-03-01');
insert into movierating values(3,1,3,'2020-02-22');
insert into movierating values(3,2,4,'2020-02-25');


(select u_name results
from users
left join movierating
using (user_id)
group by user_id
order by count(rating) desc, u_name
limit 1)
union
(select title
from movies
left join movierating
using(movie_id)
where left(created_at,7) = '2020-02'
group by movie_id
order by avg(rating) desc, title
limit 1)

/*Q36 Write an SQL query to report the distance travelled by each use */

create table userstable(
id int,
u_name varchar(30),
primary key (id));

 create table ridestable(
id int,
user_id int,
distance int,
primary key (id));

insert into userstable values(1,'Alice');
insert into userstable values(2,'Bob');
insert into userstable values(3,'Alex');
insert into userstable values(4,'Donald');
insert into userstable values(7,'Lee');
insert into userstable values(13,'Jonathan');
insert into userstable values(19,'Elvis');


insert into ridestable values(1,1,120);
insert into ridestable values(2,2,317);
insert into ridestable values(3,3,222);
insert into ridestable values(4,7,100);
insert into ridestable values(5,13,312);
insert into ridestable values(6,19,50);
insert into ridestable values(7,7,120);
insert into ridestable values(8,19,400);
insert into ridestable values(9,7,230);

select u_name,sum(distance) from userstable u
LEFT JOIN
ridestable r
ON
u.id = r.user_id
group by u_name;

/* Q37. Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.
 */
create table employees(
id int,
name varchar(20),
primary key(id));

create table employeeuni(
id int,
unique_id int,
primary key(id,unique_id));

insert into employees values(1,'Alice');
insert into employees values(7,'Bob');
insert into employees values(11,'Meir');
insert into employees values(90,'Winston');
insert into employees values(3,'Jonathan');

insert into employeeuni values(3,1);
insert into employeeuni values(11,2);
insert into employeeuni values(90,3);

select unique_id,name from employees 
left join
employeeuni using(id);

/* Q38. Write an SQL query to find the id and the name of all students who are enrolled in departments that no
longer exist.
 */
 
 create table departments(
id int,
name varchar(30),
primary key(id));

create table students(
id int,
name varchar(30),
department_id int,
primary key(id));

insert into departments values(1,'Electrical Engineering');
insert into departments values(7,'Computer Engineering');
insert into departments values(13,'Business Administration');

insert into students values(23,'Alice',1);
insert into students values(1,'Bob',7);
insert into students values(5,'Jenifer',13);
insert into students values(2,'John',14);
insert into students values(4,'Jasmine',77);
insert into students values(3,'Steve',74);
insert into students values(6,'Luis',1);
insert into students values(8,'Jonathan',7);
insert into students values(7,'Diana',33);
insert into students values(11,'Madelynn',1);

select s.id,s.name from students s
LEFT JOIN
departments d
ON s.department_id = d.id
where d.id is null;
 
/* Q39.
Write an SQL query to report the number of calls and the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2.
 */
 create table calls(
from_id int,
to_id int,
duration int);

insert into calls values(1,2,59);
insert into calls values(2,1,11);
insert into calls values(1,3,20);
insert into calls values(3,4,100);
insert into calls values(3,4,200);
insert into calls values(3,4,200);
insert into calls values(4,3,499);

select least(from_id,to_id) as person1,greatest(from_id,to_id) as person2,count(*) as call_count,sum(duration) from calls
group by 1,2;

/* Q40 Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places. */

create table prices(
product_id	int,
start_date date,
end_date date,
price int);


create table unitsold(
product_id int,
purchase_date date,
units int
);

select u.product_id, round(sum(units * price)/sum(units),2) as Average_Price from unitsold u 
inner join prices p on u.product_id = p.product_id
where u.purchase_date between p.start_date and p.end_date
group by u.product_id;

/* Q41. Write an SQL query to report the number of cubic feet of volume the inventory occupies in each
warehouse.  */

create table warehouse(
name varchar(30),
product_id int,
units	 int,
primary key(name,product_id));


create table products(
product_id int,
product_name varchar(30),
width int,
length int,
height int);

select (W.name) as Warehouse_name,sum(P.width*P.length*P.height * W.units) as volume from warehouse W
LEFT JOIN products P
ON  W.product_id = P.product_id 
GROUP BY W.name;

/*Q42 Write an SQL query to report the difference between the number of apples and oranges sold each day.
Return the result table ordered by sale_date */	

create table Sale(
sale_date date,
fruit enum("Apples","Oranges"),
sold_num int,
primary key(sale_date,fruit));


select a.sale_date, a.sold_num - b.sold_num from Sale a
LEFT JOIN Sale b
ON a.sale_date = b.sale_date
WHERE a.fruit = 'Apples' and b.fruit = 'Oranges';

/* Q43 Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players.*/

create table activity(
player_id int,
device_id int,
event_date date,
games_played  int,
primary key(player_id,event_date));


select round(count(t2.player_id)/count(t1.player_id),2) as fraction
from 
(select player_id,min(event_date) as first_login 
from activity
group by player_id)
t1 left join activity t2
on t1.player_id=t2.player_id and t1.first_login=t2.event_date-1;

/* Q44  Write an SQL query to report the managers with at least five direct reports.*/

create table employee(
id int,
ename varchar(20),
department varchar(3),
managerid  int,
primary key(id));

insert into employee values(101,'John','A',Null);
insert into employee values(102,'Dan','A',101);
insert into employee values(103,'James','A',101);
insert into employee values(104,'Amy','A',101);
insert into employee values(105,'Anne','A',101);
insert into employee values(106,'Ron','B',101);

select ename from employee where id 
IN
(select managerid from employee
group by managerid
having count(id) >= 5);

/*Q45 Write an SQL query to report the respective department name and number of students majoring in
each department for all departments in the Department table (even ones with no current students).
Return the result table ordered by student_number in descending order. In case of a tie, order them by
dept_name alphabetically.
 */
 
 create table student(
student_id int,
student_name varchar(30),
gender varchar(2),
dept_id int,
primary key(student_id));

 create table department(
dept_id int,
dept_name varchar(30),
primary key(dept_id));

insert into student values(1,'Jack','M',1);
insert into student values(2,'Jane','F',1);
insert into student values(3,'Mark','M',2);

insert into department values(1,'Engineering');
insert into department values(2,'Science');
insert into department values(3,'Law');

SELECT dept_name, COUNT(student_id) AS student_number FROM
department AS d LEFT JOIN student AS s ON d.dept_id = s.dept_id
GROUP BY dept_name
ORDER BY student_number DESC, dept_name;

select dept_name, count(student_id) as student_number from department as d
LEFT JOIN
student AS s
ON
d.dept_id = s.dept_id
GROUP BY dept_name
ORDER BY student_number DESC,dept_name;

/* Q46. Write an SQL query to report the customer ids from the Customer table that bought all the products in
the Product table */

create table Customer(
cust_id int,
prod_key int
);


create table Product(
prod_id int,
primary key(prod_id));

insert into Customer values(1,5);
insert into Customer values(2,6);
insert into Customer values(3,5);
insert into Customer values(3,6);
insert into Customer values(1,6);

insert into Product values(5);
insert into Product values(6);

select c.cust_id,p.prod_id from Customer as c
LEFT JOIN 
Product as p
ON
c.prod_key = p.prod_id
GROUP BY c.cust_id
HAVING count(distinct p.prod_id);

select cust_id from Customer
GROUP BY cust_id
HAVING count( distinct prod_key) = (select count(*) FROM Product);

/* Q47 Write an SQL query that reports the most experienced employees in each project. In case of a tie,
report all employees with the maximum number of experience years.*/

create table Project(
project_id int,
employee_id int,
primary key (project_id,employee_id));

create table Employee(
employee_id int,
name  varchar(20),
experience_years int,
primary key (employee_id));

insert into Project values(1,1);
insert into Project values(1,2);
insert into Project values(1,3);
insert into Project values(2,1);
insert into Project values(2,4);

insert into Employee values(1,'Khaleed',3);
insert into Employee values(2,'Ali',2);
insert into Employee values(3,'John',3);
insert into Employee values(4,'Doe',2);

select project_id, employee_id
from Project
join Employee
using (employee_id)
where (project_id, experience_years) in (
    select project_id, max(experience_years)
    from Project
    join Employee
    using (employee_id)
    group by project_id);

/* Q48 Write an SQL query that reports the books that have sold less than 10 copies in the last year,
excluding books that have been available for less than one month from today. Assume today is
2019-06-23.  */

create table Books(
book_id int,
name varchar(40),
available_from date,
primary key (book_id));

create table Orders(
order_id int,
book_id int,
quantity int,
dispatch_date date,
primary key (order_id),
foreign key (book_id) references Books(book_id));

insert into Books values(1,'Kalila and Demna','2010-01-01');
insert into Books values(2,'28 Letters','2012-05-12');
insert into Books values(3,'The Hobbit','2019-06-10');
insert into Books values(4,'13 Reasons Why','2019-06-01');
insert into Books values(5,'The Hunger Games','2008-09-21');

insert into Orders values(1,1,2,'2018-07-26');
insert into Orders values(2,1,2,'2018-11-05');
insert into Orders values(3,3,8,'2019-06-11');
insert into Orders values(4,4,6,'2019-06-05');
insert into Orders values(5,4,5,'2019-06-20');
insert into Orders values(6,5,9,'2009-02-02');
insert into Orders values(7,5,8,'2010-04-13');

select book_id, name from Books
where book_id not in (
    select book_id from Orders 
    where (dispatch_date between date_sub('2019-06-23',interval 1 year) and '2019-06-23') 
    group by (book_id) 
    having sum(quantity) >= 10)
and 
    available_from < date_sub('2019-06-23', interval 1 month);
    
/*Q49. Write a SQL query to find the highest grade with its corresponding course for each student. In case of
a tie, you should find the course with the smallest course_id.  */

create table Enrollments(
student_id int,
course_id int,
grade int,
primary key (student_id,course_id));

insert into Enrollments values(2,2,95);
insert into Enrollments values(2,3,95);
insert into Enrollments values(1,1,90);
insert into Enrollments values(1,2,99);
insert into Enrollments values(3,1,80);
insert into Enrollments values(3,2,75);
insert into Enrollments values(3,3,82);

select student_id, min(course_id) as course_id, grade
from Enrollments
where (student_id, grade) in 
    (select student_id, max(grade)
    from Enrollments
    group by student_id)
group by student_id, grade
order by student_id asc;

/* Q50 Write an SQL query to find the winner in each group */

create table players(
player_id int,
group_id int,
primary key (player_id));

create table Matches(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int,
primary key (match_id));

insert into players values(15,1);
insert into players values(25,1);
insert into players values(30,1);
insert into players values(45,1);
insert into players values(10,2);
insert into players values(35,2);
insert into players values(50,2);
insert into players values(20,3);
insert into players values(40,3);

insert into Matches values(1,15,45,3,0);
insert into Matches values(2,30,25,1,2);
insert into Matches values(3,30,15,2,0);
insert into Matches values(4,40,20,5,2);
insert into Matches values(5,35,50,1,1);

select group_id,player_id 
from (
    select sc.group_id group_id, sc.player_id player_id, 
       rank() over (partition by sc.group_id order by sum(sc.score) desc, sc.player_id asc) as rnk 
    from(
        select p.group_id group_id,
         p.player_id player_id ,
         sum(m.first_score) as score
        from players p
        inner join matches m
        on p.player_id = m.first_player
        group by p.group_id,p.player_id
        
        union all
        
        select p.group_id group_id,
         p.player_id player_id ,
        sum(second_score) as score
        from players p
        inner join matches m
        on p.player_id = m.second_player
        group by p.group_id,p.player_id
    ) sc
    group by sc.group_id,sc.player_id
) A 
where rnk = 1;