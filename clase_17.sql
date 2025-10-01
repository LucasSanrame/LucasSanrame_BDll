USE sakila;

#1
SELECT a.address, a.postal_code, c.city, co.country
FROM address a
INNER JOIN city c USING (city_id)
INNER JOIN country co USING (country_id)
WHERE a.postal_code IN ('39241', '18204', '24397');

SELECT a.address, a.postal_code, c.city, co.country
FROM address a
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('53574', '58125', '13737');

SET profiling = 1;
SHOW PROFILES;

ALTER TABLE address ADD INDEX idx_postal (postal_code);
ALTER TABLE address DROP INDEX idx_postal;

#Antes de usar índice, la consulta demoraba ~0.016 seg. Tras crear el índice, la duración bajó a menos de 0.001 seg.
#Esto confirma que, aunque la creación del índice es más costosa al principio, luego agiliza mucho las consultas que se repiten seguido.
#En cambio, sin índice puede ser útil si son búsquedas esporádicas.

#2
SHOW INDEXES FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'Agustin';

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'Pepi';

#Cuando se filtra por "first_name", la búsqueda no aprovecha índices y se recorren todas las filas.
#En cambio, al consultar por "last_name", existe un índice que acelera la búsqueda, haciendo más eficiente el acceso a los datos.

#3
EXPLAIN
SELECT film_id, title, description
FROM film
WHERE description LIKE '%action%';

EXPLAIN
SELECT film_id, title, description
FROM film_text
WHERE MATCH(title, description) AGAINST ('action');

#Con LIKE no se utilizan índices y se revisa cada fila completa, lo cual es más lento.
#En cambio, con MATCH...AGAINST se aprovecha un índice FULLTEXT, reduciendo la cantidad de registros leídos y acelerando el proceso.
