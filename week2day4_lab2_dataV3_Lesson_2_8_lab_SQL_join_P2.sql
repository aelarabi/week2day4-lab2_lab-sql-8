/*Lab | SQL Join (Part II)
In this lab, you will be using the Sakila database of movie rentals.

Instructions
Write a query to display for each store its store ID, city, and country.
Write a query to display how much business, in dollars, each store brought in.
Which film categories are longest?
Display the most frequently rented movies in descending order.
List the top five genres in gross revenue in descending order.
Is "Academy Dinosaur" available for rent from Store 1?
Get all pairs of actors that worked together.
Get all pairs of customers that have rented the same film more than 3 times.
For each film, list actor that has acted in more films.*/
use sakila;
-- 1) Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;
select store_id, city, country
from store as st
join address as ad
on st.address_id=ad.address_id
join city as city 
on ad.city_id=city.city_id
join country as country
on city.country_id=country.country_id;

-- 2) Write a query to display how much business, in dollars, each store brought in.
select * from staff;
select * from payment;
select store_id,sum(amount) as "Revenue in Dollars"
from staff as st
right join payment as pay
on st.staff_id=pay.staff_id
group by store_id;

-- 3) Which film categories are longest?
select * from category;
select * from film_category;
select * from film;
SELECT name as cat_name , sum(length) as "Total run time(minutes)"
FROM sakila.category as cat
JOIN sakila.film_category as f
ON cat.category_id = f.category_id
right join film as fi
on f.film_id=fi.film_id
GROUP BY cat_name
order by sum(length) desc
limit 1;

-- 4) Display the most frequently rented movies in descending order.
select * from film;
select * from inventory;
select * from rental;
select title as movie_title, count(rental_id) as "Number of times movie has been rented"
from film as fi 
left join inventory as inv
on fi.film_id=inv.film_id
right join rental as rent
on inv.inventory_id=rent.inventory_id
group by fi.film_id
order by count(rental_id) desc;

-- 5) List the top five genres in gross revenue in descending order.
SELECT name as cat_name , sum(amount) as "Gross revenue by genre(dollars)"
FROM sakila.category as cat
right JOIN sakila.film_category as f
ON cat.category_id = f.category_id
right join film as fi
on f.film_id=fi.film_id
left join inventory as inv
on fi.film_id=inv.film_id
left join rental as rent
on inv.inventory_id=rent.inventory_id
right join payment as pay
on rent.customer_id=pay.customer_id
GROUP BY cat_name
order by sum(amount) desc
limit 5;

-- 6)  Is "Academy Dinosaur" available for rent from Store 1?
select * from film;
select * from inventory;
select * from store;

select st.store_id, title as movie_title
from film as fi
join inventory as inv
on fi.film_id=inv.film_id
right join store as st
on inv.store_id=st.store_id
-- group by st.store_id this line messed up the query
having fi.title="Academy Dinosaur";
-- This query is funny. don't forget to ask

-- 7) Get all pairs of actors that worked together.
select * from film_actor;
select * from actor;
select film_id, first_name, last_name
from film_actor fiac
join actor as ac
on fiac.actor_id=ac.actor_id
group by fiac.actor_id
having film_id=film_id
order by film_id;

-- OR EVEN COOLER SHOWING THE FILM TITLE. 

select fi.film_id, first_name, last_name, title
from film_actor fiac
join actor as ac
on fiac.actor_id=ac.actor_id
join film as fi
on fiac.film_id=fi.film_id
group by fiac.actor_id
having fi.film_id=fi.film_id
order by fi.film_id;

-- THE QUERY BELOW IS ANOTHER TRIAL & GIVES A DIFFERENT COUNT.. I BELIEVE IT IS WRONG BUT I AM NOT SURE WHY IT IS HAPPENNING. ASK THE GURU
select fi.film_id, first_name, last_name, title
from film_actor fiac
join actor as ac
on fiac.actor_id=ac.actor_id
join film as fi
on fiac.film_id=fi.film_id
where fi.film_id=fi.film_id
group by last_name
order by fi.film_id;

-- THE QUERY ABOVE IS ANOTHER TRIAL & GIVES A DIFFERENT COUNT.. I BELIEVE IT IS WRONG BUT I AM NOT SURE WHY IT IS HAPPENNING. ASK THE GURU

-- 8) Get all pairs of customers that have rented the same film more than 3 times.
select * from customer;
select * from rental;
select * from inventory;
select first_name, last_name
from customer as cust
join rental as rent
on cust.customer_id=rent.customer_id
left join inventory as inv
on rent.inventory_id=inv.inventory_id
-- where count(film_id)>3  > does not work..
group by first_name
having count(distinct(film_id))>3;

-- 9) For each film, list actor that has acted in more films.
select * from film_actor;
select * from actor;

select film_id, first_name, last_name,count(ac.actor_id)
-- rank () over (ac.actor_id, order by film_id) as firstname from film_actor
from film_actor as fiac
join actor as ac
on fiac.actor_id=ac.actor_id
-- where count(ac.actor_id)>1
group by ac.actor_id
-- having count(first_name)=max(count(film_id))
-- having count(first_name)=max(count(film_actor.actor_id))
-- if (count(ac.actor_id)=max(count(ac.actor_id),limit 1,,)
order by film_id;

-- rank() over (order by count(ac.actor_id)) as highest from film_actor;
--  FOR THE PAST 3.5 HOURS I TRIED EVERYTHING. I CAN'T SEEM TO BE ABLE TO GET THIS ONE. I CAN SEE THE MAXIMUM IN THE CURRENT QUERY THIS FAR BUT IT I CAN NOT QUERY IT OUT. 