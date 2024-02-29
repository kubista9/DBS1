DROP SCHEMA IF EXISTS dvdrental CASCADE;
CREATE SCHEMA dvdrental;
SET SCHEMA 'dvdrental';

--Create a list of all stores.
select * from store;

--Create a list of films (title and description) longer than 120 minutes.
select title, description, length
from film
where length > 120;

--What are the addresses of each store?
select store_id, address
from store, address
where store.address_id = address.address_id;

--What is the name of the customer who lives in the city 'Apeldoorn'?
select first_name, last_name
from customer
where address_id = (
    select address_id
    from address
    where city_id = (
        select city_id
        from city
        where city = 'Apeldoorn'
        )
    );

--What are the categories of the film 'ARABIA DOGMA'?
select name
from category
where category_id = (
    select category_id
    from film_category
    where film_id =
          (select film_id
           from film
           where title = 'ARABIA DOGMA')
    );

--Which actors (their names) were in the film 'INTERVIEW LIAISONS'?
select first_name, last_name
from actor
where actor_id in (
    select actor_id
    from film_actor
    where film_id in (
            select film_id
            from film
            where title = 'INTERVIEW LIAISONS'
        )
    );

select first_name, last_name
from actor a, film_actor fa, film f
where a.actor_id = fa.actor_id
and fa.film_id = f.film_id
and f.title = 'INTERVIEW LIAISONS';

select first_name, last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where f.title = 'INTERVIEW LIAISONS';

--What is the name of the staff who rented a copy of 'HUNCHBACK IMPOSSIBLE' to customer KURT EMMONS?
select first_name, last_name
from rental, staff
where staff.staff_id = rental.staff_id
and rental.inventory_id in (
    select inventory_id
    from inventory
    where film_id = (
        select film_id
        from film
        where title = 'HUNCHBACK IMPOSSIBLE')
    and customer_id = (
        select customer_id
        from customer
        where customer.first_name = 'KURT'
        and customer.last_name = 'EMMONS'
        )
    );

--Show how many inventory items are available at each store.
select store.store_id, count(inventory)
from store, inventory
where inventory.store_id = store.store_id
group by store.store_id;

--How many times have VIVIAN RUIZ rented something?
select count(return_date)
from customer, rental
where rental.customer_id = customer.customer_id
and customer.first_name = 'VIVIAN'
and customer.last_name = 'RUIZ';
