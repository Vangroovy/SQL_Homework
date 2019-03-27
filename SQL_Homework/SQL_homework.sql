USE sakila;

-- 1a. Display the first and last name in the actor table --
SELECT first_name, last_name
FROM actor; 

-- 1b. Set the name columns to upper case and display the first and last name in the column Actor Name --
SELECT CONCAT_WS(' ', first_name, last_name) AS actor_name
FROM actor;

UPDATE actor
SET actor_name = UPPER(actor_name);

-- 2a. Find all actors with the first name Joe --
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name LIKE 'Joe';
        
-- 2b. Find all actors with a last name that contains 'GEN' --
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';
    
-- 2c. Find all actors with last names containing 'LI', order by last name --
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name;
    
-- 2d. Find Afghanistan, Bangladesh and China --
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Create a column to keep a description of each actor --
ALTER TABLE actor
ADD description BLOB AFTER last_update; 

-- 3b. Delete the description column --
ALTER TABLE actor
DROP description;

-- 4a. List the last names and the number of actors with the same last name --
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- 4b. Show the number of actors with the same last names --
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

-- 4c. Correct Groucho Williams to Harpo Williams --
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = 'Groucho' AND last_name = 'WILLIAMS';
	

-- 4d. Correct Harpo Williams to GROUCHO in a single query Williams --
UPDATE actor
SET first_name = 'Groucho'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a. Write a query to locate the schema of the address table --
DESC sakila.address;

-- 6a. Display the first and last name and address of all staff members --
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
USING(address_id);

-- 6b. Display total amount rung by staff in August 2005 --
SELECT s.first_name, s.last_name, 
SUM(p.amount) AS "total amount rung up"
FROM staff s
JOIN payment p
USING (staff_id)
WHERE p.payment_date LIKE "%2005-08%"
GROUP BY staff_id
;

-- 6c.  List each film and the number of actors who are listed for the film --
SELECT f.title, 
COUNT(a.actor_id) AS "total actors in movie"
FROM film f
INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.film_id
;

-- 6d. count number of copies of Hunchback Impossible in inventory --
SELECT f.title,
COUNT(i.film_id) AS "total copies"
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.film_id
;

-- 6e. total paid by customer, sorted alphabetically --
SELECT c.first_name, c.last_name, 
SUM(p.amount) AS "total amount paid"
FROM customer c
INNER JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a. Display English movies with titles starting with K and Q --
SELECT title
FROM film f
WHERE language_id IN
(
	SELECT language_id
	FROM language l
	WHERE name = 'English'
	)
AND title LIKE 'K%' OR title LIKE 'Q%';


-- 7b.  Actors in the film Alone Trip --
SELECT first_name, last_name
FROM actor a
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor fa
    WHERE film_id IN
    (
		SELECT film_id
        FROM film f
        WHERE title = 'Alone Trip'
	)
);
    
-- 7c.  Name and email addresses of Canadian customers *fix--
SELECT first_name, last_name, email 
FROM customer
JOIN address ON
customer.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
WHERE country.country = 'Canada'
;

-- 7d.  Identify movies categorized as family films --
SELECT title
FROM film f
WHERE film_id IN
(
	SELECT film_id
    FROM film_category fc
    WHERE category_id IN
    (
		SELECT category_id
        FROM category c
        WHERE name = 'family'
	)
);

-- 7e. Most frequently rented movies in descending order --
SELECT film.title, 
COUNT(rental.rental_id) AS 'Total Rentals'
FROM film, rental, inventory
WHERE film.film_id=inventory.film_id AND
inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY 2 DESC, 1
;

-- 7f. Display how much business, in dollars each store brought in --
SELECT store.store_id, 
SUM(payment.amount) AS 'Total Business'
FROM store
JOIN inventory ON
store.store_id = inventory.store_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id          
GROUP BY store.store_id;

-- 7g.  Display for each store its store ID, city and country --
SELECT store.store_id, city.city, country.country
FROM store
JOIN address ON
store.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id;

-- 7h. List top 5 genres in gross revenue in descending order --
SELECT category.name, 
SUM(payment.amount) AS "Gross Revenue"
FROM category
JOIN film_category ON
category.category_id = film_category.category_id
JOIN inventory ON
film_category.film_id = inventory.film_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY 2 DESC, 1
LIMIT 5
;
                    
-- 8a.  Create a view of 7h --
CREATE VIEW `top_genre` AS 
SELECT category.`name`, 
SUM(payment.`amount`) AS "Gross Revenue"
FROM category
JOIN film_category ON
category.`category_id` = film_category.`category_id`
JOIN inventory ON
film_category.`film_id` = inventory.`film_id`
JOIN rental ON
inventory.`inventory_id` = rental.`inventory_id`
JOIN payment ON
rental.`rental_id` = payment.`rental_id`
GROUP BY category.name
ORDER BY 2 DESC, 1
LIMIT 5
;

-- 8b. Display the view in 8a --
SELECT * FROM `top_genre`;



-- 8c.  Drop the view in 8c --
DROP VIEW `top_genre`;


