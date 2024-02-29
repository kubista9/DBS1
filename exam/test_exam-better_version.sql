create schema dvdrental_exam;
set schema 'dvdrental';

--Whats the actor_id of Will Wilson?
select actor_id
from actor
where first_name ilike 'Will'
and last_name ilike 'Wilson';

--How many films has Kenneth Hoffman acted in?
select count(film_id)
from film_actor fa inner join actor a on fa.actor_id = a.actor_id
and a.first_name ilike 'Kenneth'
and a.last_name ilike 'Hoffman';

--How many films are Animation or Action?
select count(title)
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
and c.name = 'Animation'
or c.name = 'Action';

SELECT COUNT(*) AS film_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ('Animation', 'Action');

--How long is the longest movie?
select length
from film
order by length desc;

--How many movies include the word 'Dog' in their description?
select count(film_id)
from film
where film.description ilike '%Dog%';

--How many movies are longer than 2 hours?
select count(film_id)
from film
where length > 120;

--How many times has the film 'Bucket Brotherhood' been rented?
select count(return_date)
from rental r join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
and f.title ilike 'Bucket Brotherhood';

--How many different customers have rented 'Bucket Brotherhood'
select count(distinct customer_id)
from rental r join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
and f.title ilike 'Bucket Brotherhood';

--Whats the average payment amount?
select avg(amount)
from payment;

--Whats the first name of the staff who is payed most from the customers?
select first_name, sum(amount) sum
from staff s inner join rental r on s.staff_id = r.staff_id
inner join payment p on r.rental_id = p.rental_id
group by first_name
order by sum desc;

--How many inventories have never been rented?
select count(*)
from inventory
where inventory_id not in (
    select inventory_id
    from rental
    );

--How many customers, who is not from Canada, is registered in a store in Canada?
SELECT c.customer_id, c.first_name, c.last_name, co.country, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN store s ON c.store_id = s.store_id
JOIN address store_address ON s.address_id = store_address.address_id
JOIN city store_city ON store_address.city_id = store_city.city_id
JOIN country store_country ON store_city.country_id = store_country.country_id
WHERE co.country <> 'Canada' AND store_country.country = 'Canada';

select count(*)
from customer
inner join address on customer.address_id = address.address_id
inner join city  on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where country != 'Canada'
and customer.store_id in (
    select store_id
    from store
    inner join address on store.address_id = address.address_id
    inner join city on city.city_id = address.city_id
    inner join country on city.country_id = country.country_id
    where country = 'Canada'
    );

--How many customers lives in the same city as some of the staff?
select count(distinct customer_id) count
from customer inner join address on customer.address_id = address.address_id
and address.address_id in (
    select address_id
    from staff
        );

SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city  ON address.city_id = city.city_id
WHERE city IN (
    SELECT DISTINCT city
    FROM staff
    JOIN address ON staff.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
);

--List the films title together with the actors firstname and the film category.
-- When ordering alphabetically, first by the firstname and then by the title
-- what is the category of the first film?
select title, first_name, name
from film f inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
order by first_name, title;

--Which film category does people from Argentina rent the most?
SELECT c.name AS category, COUNT(*) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer cu ON r.customer_id = cu.customer_id
WHERE co.country = 'Argentina'
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 1;

SELECT c.name AS category, COUNT(*) AS rental_count
FROM rental r
JOIN customer cu ON r.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE co.country = 'Argentina'
GROUP BY c.name
ORDER BY rental_count DESC
LIMIT 1;

