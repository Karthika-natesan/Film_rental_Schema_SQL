
--                                                Film - Rental Schema project 


use film_rental;

-- Question 1.	What is the total revenue generated from all rentals in the database? (2 Marks)

select * from payment;
select * from rental;

select p.rental_id, sum(p.amount) as total_revenue 
from payment p join rental r 
on p.rental_id = r.rental_id
group by rental_id;

# The query returned 1000 rows with total revenue generated corresponding to each rental_id in the database. 


/* ****************************************************************************************************************************************************************** */

-- Question 2.	How many rentals were made in each month_name? (2 Marks)

select monthname(rental_date) as month_name , count(rental_id) as no_of_rentals from rental 
group by month_name;

# The query returned 5 rows with number of rentals made every month from database. 

/* ***************************************************************************************************************************************************************** */

-- QUESTION 3.	What is the rental rate of the film with the longest title in the database? (2 Marks)

select * from film;

select film_id, title , rental_rate from film 
order by length(title) desc 
limit 1; 

# The query returned a single row with the rental rate of the longest title in the database i.e., rental_rate of 2.99
-- for the film title with "ARACHNOPHOBIA ROLLERCOASTER". 

/* ****************************************************************************************************************************************************************** */

-- QUESTION 4.	What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22:04:30")? (2 Marks)



select * from rental;
select * from film;


select avg(f.rental_rate) as average_rental_rate from film f
join inventory i 
on f.film_id = i.film_id 
join rental r 
on i.inventory_id = r.inventory_id
where r.rental_date in (select r.rental_date from rental r where r.rental_date > '2005-05-05 22:04:30'
and r.rental_date < '2005-06-05 22:04:30');

# The query returned a single row with the average rental rate of 2.931176 for the films from the given date interval. 

/* ******************************************************************************************************************************************************************** */

-- QUESTION 5.	What is the most popular category of films in terms of the number of rentals? (3 Marks)

with popular_category as (
select  r.rental_id, f.film_id,c.category_id,c.name as film_category from rental r 
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id) 
select film_category,count(rental_id) as rental_count from popular_category group by film_category order by rental_count 
desc limit 1;

# The query returned a single row with the most popular film category i.e., "sports" , in terms of number of rentals the film was taken by the customers. 

/* ********************************************************************************************************************************************************************* */
-- QUESTION 6.	Find the longest movie duration from the list of films that have not been rented by any customer. (3 Marks)

# code 1: list of movies that have not been rented by any customer:
select f.film_id, f.length from film f 
left join inventory i on f.film_id = i.film_id 
left join rental r on i.inventory_id = r.inventory_id 
where r.rental_id is null;

# code 2:  longest movie duration from the list : 
select max(f.length) as longest_movie_duration 
from film f
 left join inventory i on f.film_id = i.film_id 
left join rental r on i.inventory_id = r.inventory_id 
where r.rental_id is null;

# The query in code 2 returns a single row with the longest duration of a movie in the database i.e., 184 . 

/* *********************************************************************************************************************************************************************** */
-- QUESTION 7.	What is the average rental rate for films, broken down by category? (3 Marks)
select * from film_category;

select c.name AS category_name, avg(f.rental_rate) as average_rental_rate
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group BY c.name;
 
 # The query returned 16 rows with film category and its average rental rate of films under that category. There are 16 categories in the database.
 
/* ********************************************************************************************************************************************************************* */

-- QUESTION 8.	What is the total revenue generated from rentals for each actor in the database? (3 Marks)

select  fa.actor_id, sum(p.amount) as total_revenue from film_actor as fa 
join film_category as fc on fa.film_id = fc.film_id 
join film f on fc.film_id = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by fa.actor_id;

# The query returned 200 rows with the total revenue for each actor in the database and we can see that there are a total of 200 actors involved. 

/* ********************************************************************************************************************************************************************** */
-- QUESTION 9. Show all the actresses who worked in a film having a "Wrestler" in the description. (3 Marks)

select * from film;
select * from actor;

# list of films having a "Wrestler" in the description :
select film_id , description from film where description like "%wrestler%";

# list of all the actors who in the above list : 
select distinct concat_ws(" ",a.first_name,a.last_name) as actor_name from actor a 
join film_actor as fa on a.actor_id = fa.actor_id
join film_category as fc on fa.film_id = fc.film_id 
join film f on fc.film_id = f.film_id 
where description like "%wrestler%";

# The query returns 183 rows with all the actors who worked in a film having "Wrestler" in the description. 
/* Since there is no feild with gender given in the database to provide detials particularly about acteresses ,
   I'm providing data as common . */

/* *********************************************************************************************************************************************************** */ 

-- QUESTION 10.	Which customers have rented the same film more than once? (3 Marks)

select * from customer;
select concat_ws(" ",c.first_name,c.last_name) as customer_name, i.film_id, count(r.rental_id) as rental_count
from customer c 
join rental r 
on c.customer_id = r.customer_id 
join inventory i 
on r.inventory_id = i.inventory_id
group by c.customer_id, i.film_id 
having rental_count > 1 ;

/* The query returns 212 rows with customers who have rented the same film more than once. From the results we can understand 
   the following insights : 
   ** customer have rented more than one film 
   ** rented same film for second time and max number of rental count is 2.  */
   
/* ******************************************************************************************************************************************************************* */

-- QUESTION 11.	How many films in the comedy category have a rental rate higher than the average rental rate? (3 Mark)

# code 1 : count of films under each category 
select count(fc.film_id), c.name from film_category fc 
join category c on fc.category_id = c.category_id 
group by c.name ;

# code 2 : rental rate for each film from comedy category
select f.film_id,f.rental_rate from film f join film_category fc
on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where c.name like "%comedy%" and f.rental_rate > (select avg(f.rental_rate) from film f);

# code 3 : count of films in the comedy category have a rental rate higher than the average rental rate
select count(f.film_id) as comedy_category_films_with_higher_rental_rate from film f 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where c.name like "%comedy%" and f.rental_rate > (select avg(f.rental_rate) from film f);

/* The query in code 3 returns a single row with the information that out of 58 comedy film category,
 there are 42 films which have a rental rate higher than the average rental rate. */


/* *********************************************************************************************************************************************************************** */

-- QUESTION 12.	Which films have been rented the most by customers living in each city? (3 Marks)
with x as
 (select f.title, city.city, COUNT(r.rental_id) as rental_count
from film f join 
inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join customer c on r.customer_id = c.customer_id
join address a on c.address_id = a.address_id 
join city on a.city_id = city.city_id
group by city.city, f.title ) 

select  x.city, x.title from x  

where rental_count = (
  select MAX(rental_count)
  from (
    select city.city, f.film_id, count(*) as rental_count
    from film f join 
inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join customer c on r.customer_id = c.customer_id
join address a on c.address_id = a.address_id 
join city on a.city_id = city.city_id
group by city.city, f.film_id
  ) as y
  where y.city = x.city
);

/* The abouve query returns 11092 rows with the list of films have been rented the most by customers living in each city */


/* ************************************************************************************************************************************************************* */ 

-- QUESTION 13.	What is the total amount spent by customers whose rental payments exceed $200? (3 Marks)

select* from payment;

select customer_id, sum(amount) as total_amount from payment
 group by customer_id 
 having total_amount > 200;

# The query returns 2 rows with customer_id whose rental payments are above $200 in the database. 

/* ************************************************************************************************************************************************************** */

-- QUESTION  14.	Display the fields which are having foreign key constraints related to the "rental" table. [Hint: using Information_schema] (2 Marks)

select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE;     
select distinct column_name, constraint_name, referenced_table_name
from information_schema.key_column_usage
where table_name = 'rental' and constraint_name like '%fk%'; 

 # The query returns 3 rows with the detials about the fields which are having fk constraints related to rental table. 
 # They are : 1. customer_id 2. inventory_id 3. staff_id
/* ***************************************************************************************************************************************************************** */

-- QUESTION 15.	Create a View for the total revenue generated by each staff member, broken down by store city with the country name. (4 Marks)

create view  total_revenue_by_staff as
select s.staff_id, sum(p.amount) as total_revenue, city.city, c.country from payment p 
join staff s on p.staff_id = s.staff_id 
join store on s.store_id = store.store_id 
join address a on store.address_id = a.address_id 
join city on a.city_id = city.city_id 
join country c on city.country_id = c.country_id 
group by s.staff_id,city.city, c.country; 

select * from total_revenue_by_staff;

# The query returns 2 rows from the view created.

/* ****************************************************************************************************************************************************************** */

/* QUESTION 16.	Create a view based on rental information consisting of visiting_day,
 customer_name, the title of the film,  no_of_rental_days, 
 the amount paid by the customer along with the percentage of customer spending. (4 Marks)
*/
 
create view rental_information as 
select concat_ws(" ",c.first_name,c.last_name) as customer_name,f.title,sum(p.amount) as amount_paid_by_customer,
day(r.rental_date) as visiting_day,
datediff(r.return_date,r.rental_date) as no_of_rental_days
 from customer c 
 join rental r on c.customer_id = r.customer_id 
 join payment p on r.rental_id = p.rental_id
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id
group by customer_name,f.title,visiting_day,no_of_rental_days;

# The query returned 16044 rows from the view created. 

/* ******************************************************************************************************************************************************* */

-- Question 17.	Display the customers who paid 50% of their total rental costs within one day. (5 Marks)

    select distinct c.customer_id, concat_ws(' ',c.first_name, c.last_name) as customer_name
     from customer c 
    join rental r on c.customer_id = r.customer_id
    join payment p on r.rental_id = p.rental_id
    where r.customer_id = c.customer_id and  (
    select sum(p.amount)
    from rental r
    join payment p on r.rental_id = p.rental_id
    where r.customer_id = c.customer_id) >= 0.5 * (
    select sum(p.amount)
    from rental r
    join payment p on r.rental_id = p.rental_id
    where r.customer_id = c.customer_id ) ; 

/*  The query returns 599 rows with list of customers who paid 50% of their total rental cost. Since payment_date and rental_date are same 
	for all these customers they must have paid within one day. */
    
 /* ********************************************************************************************************************************************************************** */
  --                                                             Thank You !