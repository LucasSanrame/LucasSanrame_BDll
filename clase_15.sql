use sakila;

#1
CREATE VIEW list_of_customers AS SELECT c.customer_id,CONCAT(c.first_name, ' ', c.last_name) AS full_name, a.address, a.postal_code AS zip_code, a.phone, ci.city, co.country, IF(c.active = 1, 'active', 'inactive') AS status, c.store_id
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id;

#2
CREATE VIEW film_details AS SELECT f.film_id, f.title, f.description, cat.name AS category, f.rental_rate AS price, f.length, f.rating, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name, a.first_name SEPARATOR ', ') AS actors
FROM film f JOIN film_category fc ON f.film_id = fc.film_id JOIN category cat ON fc.category_id = cat.category_id JOIN film_actor fa ON f.film_id = fa.film_id JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, cat.name, f.rental_rate, f.length, f.rating;
    
#3
CREATE VIEW sales_by_film_category AS SELECT cat.name AS category, SUM(p.amount) AS total_rental
FROM category cat JOIN film_category fc ON cat.category_id = fc.category_id JOIN film f ON fc.film_id = f.film_id JOIN inventory i ON f.film_id = i.film_id JOIN rental r ON i.inventory_id = r.inventory_id JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cat.name
ORDER BY total_rental DESC;

#4
CREATE VIEW actor_information AS SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count FROM actor a
#crea una vista llamada "actor_information" y selecciona las columnas de nombre, apellido (de la tabla de actores) y cuenta cuantas peliculas tiene asociadas cada actor en la tabla "film_actor"
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
#se unen todos los registros de "film_actor" que coincidan con el actor actual
GROUP BY a.actor_id, a.first_name, a.last_name
#agrupa los resultados por actor
ORDER BY film_count DESC, a.last_name;
#ordena los resultados mostrando primero los actores con más películas
