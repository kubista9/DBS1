--Wiseflow 331167
create schema dvdrental;
set schema 'dvdrental';

--What is the city_id of 'La Paz'?
select city_id
from city
where city ilike 'La Paz';

--How many customers have the first name Kelly?
select count(first_name)
from customer
where first_name ilike 'Kelly';

--What is the average length of a movie?
select avg(length)
from film;

--Consider the address with an address_id of 261. In which country is this address located?
select country
from address join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
and address_id = 261;

--How many addresses includes the letter sequence 'way' or 'Way'?
select count(*)
from address
where address ilike '%Way%';

-- How many customer lives in London?
select count(customer_id)
from customer join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
and city = 'London';

--What is the store_id of the store with the most customer registered?
select store.store_id, count(customer_id) count
from store join customer on store.store_id = customer.store_id
group by store.store_id
order by count desc limit 1;

--How many movies has Tim Cary rented?
select count(rental)
from rental join customer c on rental.customer_id = c.customer_id
where first_name = 'Tim'
and last_name = 'Cary';

--What is the first name of the customer who has spent the largest amount?
select first_name, sum(amount) sum
from customer join payment p on customer.customer_id = p.customer_id
group by first_name
order by sum desc limit 1;

--List the film titles along with the actors' last names and the film categories.
-- When ordered alphabetically, first by category name, then by title, and
-- lastly by the actors' last names, what is the first actor's last name?
select title, last_name, name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
order by name, title, last_name;

--How many customers have rented more than 30 movies?
select customer.customer_id, count(rental) as count
from customer join rental on customer.customer_id = rental.customer_id
group by customer.customer_id
having count(rental) > 30;

-- How many customers, who are not from Australia, are
-- registered in a store in Australia?
select count(*)
from customer
join address on customer.address_id = address.address_id
join city  on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country != 'Australia'
and customer.store_id in (
    select store_id
    from store
    join address on store.address_id = address.address_id
    join city on city.city_id = address.city_id
    join country on city.country_id = country.country_id
    where country = 'Australia'
    );

--How many customer have rented both 'Badman Dawn' and 'Bucket Brotherhood'?
select count( customer_id)
from rental r join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
and f.title ilike 'Bucket Brotherhood'
or f.title ilike 'Badman Dawn';

--Which actor has appeared in most films rented by customers from Chile?
select actor.first_name, actor.last_name, count(*) count
from actor join film_actor fa on actor.actor_id = fa.actor_id
join film on fa.film_id = film.film_id
join inventory i on film.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join customer c on r.customer_id = c.customer_id
join address a on c.address_id = a.address_id
join city c2 on a.city_id = c2.city_id
join country c3 on c2.country_id = c3.country_id
and country ilike 'Chile'
group by actor.first_name, actor.last_name
order by count desc limit 1;

--How many actors have appeared in both long films (more than 2.5 hours)
-- and short films (less than 1 hour)?
select count(distinct actor.actor_id)
from actor join film_actor fa on actor.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
and film_id in (
    select film_id
    from film
    where length > 150
       or length < 60

        );

