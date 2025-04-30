USE sakila;

SELECT title, rating
FROM film
WHERE length <= ALL (SELECT length FROM film WHERE length IS NOT NULL);

SELECT f.title
FROM film f
WHERE f.length <= ALL (SELECT length FROM film WHERE length IS NOT NULL)
AND 1 > ALL (
    SELECT COUNT(*)
    FROM film f2
    WHERE f2.length = f.length
    HAVING COUNT(*) > 1
);

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    (SELECT MIN(amount) FROM payment p WHERE p.customer_id = c.customer_id) AS lowest_payment
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
ORDER BY 
    c.customer_id;
    
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    (SELECT amount FROM payment p1 
     WHERE p1.customer_id = c.customer_id 
     AND amount <= ALL(SELECT amount FROM payment WHERE customer_id = c.customer_id)
     LIMIT 1) AS lowest_payment,
    (SELECT amount FROM payment p1 
     WHERE p1.customer_id = c.customer_id 
     AND amount >= ALL(SELECT amount FROM payment WHERE customer_id = c.customer_id)
     LIMIT 1) AS highest_payment
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
ORDER BY 
    c.customer_id;