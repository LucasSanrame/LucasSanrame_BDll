use sakila;

#1
SELECT CONCAT(c.last_name, ' ', c.first_name) AS apellido_nombre, a.address, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.country_id = (SELECT country_id FROM country WHERE country = 'Argentina');

#2
SELECT f.title,l.name AS lenguaje, CASE WHEN f.rating = 'G' THEN 'Audiencia general' WHEN f.rating = 'PG' THEN 'Supervisión parental recomendada' WHEN f.rating = 'PG-13' THEN 'Recomendado para padres' WHEN f.rating = 'R' THEN 'Contenido restringido' WHEN f.rating = 'NC-17' THEN 'Exclusivo para adultos' END AS clasificacion
FROM film f JOIN language l ON f.language_id = l.language_id;

#3
SET @nombre_actor = "penelope guiness";  -- Sustituye con el nombre del actor

SELECT f.title, f.release_year FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id JOIN actor a ON fa.actor_id = a.actor_id
WHERE LOWER(CONCAT(a.first_name, ' ', a.last_name)) LIKE LOWER(CONCAT('%', @nombre_actor, '%'));

#4
SELECT f.title, CONCAT(c.last_name, ' ', c.first_name) AS apellido_nombre,
CASE WHEN r.return_date IS NOT NULL THEN 'Si' ELSE 'no' END AS devuelto
FROM rental r JOIN inventory i ON r.inventory_id = i.inventory_id JOIN film f ON i.film_id = f.film_id JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);

#5
#Las dos son funciones para cambiar tipos de datos.
#"Cast" transforma un valor de un tipo de datos a otro y "convert" es parecido pero permite definir el formato de conversión.
#"Cast" es estándar y funciona en múltiples sistemas. "convert" es específico de SQL Server y MySQL

#6
#Nvl: Se usa para sustituir valores nulos (no compatible con mysql)
#ISNULL: invierte la condición null 0 --> 1 y de 1 --> 0
#IFNULL: Retorna el primer argumento si no es nulo, de lo contrario, retorna el segundo
#COALESCE: Retorna el primer valor no nulo de la lista de argumentos
