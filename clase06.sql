
USE sakila;

-- 1
SELECT a1.last_name, concat(a1.first_name, (SELECT concat(', ', GROUP_CONCAT(a3.first_name ORDER BY a3.first_name))
FROM actor a3 
WHERE a3.last_name = a1.last_name AND a3.first_name != a1.first_name)) AS actors_with_same_lastname
FROM actor a1
WHERE EXISTS (SELECT 1 FROM actor a2 WHERE a1.last_name = a2.last_name AND a1.actor_id != a2.actor_id)
GROUP BY a1.last_name, a1.first_name
ORDER BY a1.last_name;

-- 2
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT DISTINCT actor_id FROM film_actor)
ORDER BY last_name, first_name;

-- 3
SELECT c.customer_id, c.first_name, c.last_name, (SELECT COUNT(*) FROM rental WHERE customer_id = c.customer_id) AS rental_count
FROM customer c
WHERE (SELECT COUNT(*) FROM rental WHERE customer_id = c.customer_id) = 1;

-- 4
WITH customer_rentals AS (SELECT customer_id, COUNT(*) AS rental_count FROM rental GROUP BY customer_id HAVING COUNT(*) > 1)
SELECT c.customer_id, c.first_name, c.last_name, cr.rental_count
FROM customer c
JOIN customer_rentals cr ON c.customer_id = cr.customer_id
ORDER BY cr.rental_count DESC;

-- 5
SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')))
ORDER BY last_name, first_name;

-- 6
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id AND film.title = 'BETRAYED REAR'
WHERE actor.actor_id NOT IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = 'CATCH AMISTAD'))
ORDER BY actor.last_name, actor.first_name;

-- 7
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE EXISTS (SELECT 1 FROM film_actor fa1 JOIN film f1 ON fa1.film_id = f1.film_id WHERE f1.title = 'BETRAYED REAR' AND fa1.actor_id = a.actor_id) 
AND EXISTS (SELECT 1 FROM film_actor fa2 JOIN film f2 ON fa2.film_id = f2.film_id WHERE f2.title = 'CATCH AMISTAD' AND fa2.actor_id = a.actor_id)
ORDER BY a.last_name, a.first_name;

-- 8
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
LEFT JOIN (SELECT DISTINCT fa.actor_id FROM film_actor fa JOIN film f ON fa.film_id = f.film_id WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')) AS film_actors ON actor.actor_id = film_actors.actor_id
WHERE film_actors.actor_id IS NULL
ORDER BY actor.last_name, actor.first_name;