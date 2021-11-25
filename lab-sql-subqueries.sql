### Instructions

USE sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT b.title, COUNT(a.inventory_id) AS movie_counts FROM sakila.inventory a
LEFT JOIN sakila.film b ON a.film_id=b.film_id
WHERE b.title = "Hunchback Impossible"
GROUP BY a.film_id;

-- 2. List all films whose length is longer than the average of all the films.
#AVERAGE LENGTH
SELECT AVG(length) FROM sakila.film;

SELECT title, length FROM sakila.film
WHERE length>(
SELECT AVG(length) FROM sakila.film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT c.first_name, c.last_name FROM sakila.film_actor a
LEFT JOIN sakila.film b ON a.film_id = b.film_id
JOIN sakila.actor c ON a.actor_id=c.actor_id
WHERE b.title = "Alone Trip";

# I think that subqueries are not necessary in this case...
-- film_id of that title
SELECT film_id FROM sakila.film
WHERE title = "Alone Trip";

SELECT a.film_id, b.first_name, b.last_name FROM sakila.film_actor a
RIGHT JOIN sakila.actor b ON a.actor_id = b.actor_id
WHERE film_id IN (
SELECT film_id FROM sakila.film
WHERE title = "Alone Trip");

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT category_id FROM sakila.category
WHERE name="Family";

SELECT a.title FROM sakila.film a
RIGHT JOIN sakila.film_category b ON a.film_id = b.film_id
WHERE b.category_id IN (
SELECT category_id FROM sakila.category
WHERE name="Family");

-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct 
-- tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM sakila.customer
WHERE address_id IN (
SELECT address_id FROM sakila.address
WHERE city_id IN (
SELECT city_id FROM sakila.city
WHERE country_id IN (
SELECT country_id FROM sakila.country
WHERE country = "Canada"
)
)
);

SELECT a.first_name, a.last_name, a.email FROM sakila.customer a
JOIN sakila.address b ON a.address_id = b.address_id
JOIN sakila.city c ON b.city_id=c.city_id
JOIN sakila.country d ON c.country_id=d.country_id
WHERE d.country="Canada";

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT first_name, last_name FROM sakila.actor
WHERE actor_id IN (
SELECT id_actor FROM (
SELECT b.actor_id AS id_actor, COUNT(b.film_id) AS films_starred FROM sakila.film a
LEFT JOIN sakila.film_actor b ON a.film_id=b.film_id
LEFT JOIN sakila.actor c ON b.actor_id=c.actor_id
GROUP BY b.actor_id
ORDER BY films_starred DESC
LIMIT 1) sub1
);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments.
SELECT first_name, last_name FROM sakila.customer
WHERE customer_id IN (
SELECT id FROM
(
SELECT a.customer_id AS id, SUM(b.amount) AS sum_of_payments 
FROM sakila.customer AS a
LEFT JOIN sakila.payment AS b ON a.customer_id=b.customer_id
GROUP BY a.customer_id
ORDER BY sum_of_payments DESC
LIMIT 1
) sub1
);

-- 8. Customers who spent more than the average payments.
SELECT AVG(amount) AS avg_payment FROM sakila.payment;
SELECT a.first_name, a.last_name, b.amount FROM sakila.customer AS a
LEFT JOIN sakila.payment AS b ON a.customer_id=b.customer_id;

SELECT a.first_name, a.last_name, b.amount FROM sakila.customer AS a
LEFT JOIN sakila.payment AS b ON a.customer_id=b.customer_id
WHERE b.amount > (
SELECT AVG(amount) AS avg_payment FROM sakila.payment
)
ORDER BY b.amount;