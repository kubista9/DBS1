create schema webshop;
set schema 'webshop';

--Find all customers whose first name starts with 'Jo'. Create a list of id and names.
select customer_id, first_name, middle_name, last_name
from customer
where first_name like 'Jo%';

--Find all customers whose first name contains 'ella' and who does not have a middle name.
select customer_id, first_name, middle_name, last_name
from customer
where first_name like '%ella%' and middle_name is null;

--Find customers who have made more than 4 orders. Show first name, last name, and the number of ordered items. Sort by highest count, then first name.
select first_name, last_name, count(*) as number_of_ordered_items
from customer, order
where customer.customer_id = order.order_id
group by first_name, last_name
having count(*) > 4
order by number_of_ordered_items desc, first_name;

SELECT first_name, last_name, COUNT(*) AS no_orders
FROM customer c,
     "order" o
WHERE c.customer_id = o.customer_id
GROUP BY first_name, last_name
HAVING COUNT(*) > 4
ORDER BY no_orders DESC, first_name;

--Find the customer id of Neysa Aldins (first and last name).
select customer_id, first_name, last_name
from customer
where first_name = 'Neysa' and last_name = 'Aldins';

--What is the price of the most expensive product?
select max(product_price)   --why i cannot put name?
from product;

--Find the most expensive product.Display the product_id, product_name, and the price.
select product_id, product_name, product_price
from product
    where product_price = (select max(product_price) from product);

--Find the sum of the quantity ordered of the most expensive product, i.e. how many of the most expensive product have been ordered.
select sum(quantity)
from orderedproduct
where product_id = (select product_id from product where product_price =(select max(product_price) from product));

--Who have ordered the most expensive product? Return their full names as a string, e.g. "Neysa Aldins".
select first_name, last_name
from customer, "order", orderedproduct
where customer.customer_id = order.customer_id
  and order.order_id = orderedproduct.order_id
  and orderedproduct.product_id = (
  select product_id
  from product
  where product_price = (
  select max(product_price)
  from product) );

--Return the first name of all female customers whose last name's second letter is 'o', and who were born in the eighties.
select first_name
from customer
where gender = 'F'
and last_name like '_o%'
and birthdate between '1980-01-01' and '1989-12-31';

--Which customers have birthday today? Return names as a string and their age. Note: answer will vary, the query is the same.
SELECT  CONCAT_WS(first_name, middle_name, last_name) AS fulle_name,
        DATE_PART('year', AGE(birthdate)) AS age
FROM customer
WHERE DATE_PART('day', birthdate) = DATE_PART('day', CURRENT_TIMESTAMP)
    AND DATE_PART('month', birthdate) = DATE_PART('month', CURRENT_TIMESTAMP);

--Find the first name and age of all customers from Denmark.
select first_name, DATE_PART('year', AGE(birthdate)) AS age
from customer, address, zipcode
where customer.customer_id = address.customer_id
and address.zip_code = zipcode.zip_code
and country_code = (select country_code from country where country_name = 'Denmark');

--Find the name of the products, sorted alphabetically, who have reviews that contain any of the keywords:
-- 'Great', 'Super', 'Excellent', 'Good' but with no case-sensitivity.
select product_name
from product, review
where product.product_id = review.product_id and review_text ilike any (array['%Great%','%Super','%Excellent%','%Good%'])
order by product_name;

select current_timestamp;
select current_time;
select current_date;
select now();

