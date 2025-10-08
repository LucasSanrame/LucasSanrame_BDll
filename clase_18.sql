-- 1
DELIMITER //

CREATE FUNCTION count_film_inventory(
    p_film_ref VARCHAR(100),
    p_store_id INT
) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_inventory_count INT DEFAULT 0;
    DECLARE v_film_id_found INT;
    
    IF p_film_ref REGEXP '^[[:digit:]]+$' THEN
        SET v_film_id_found = CAST(p_film_ref AS UNSIGNED);
    ELSE
        SELECT film_id INTO v_film_id_found
        FROM film
        WHERE UPPER(title) = UPPER(p_film_ref)
        LIMIT 1;
    END IF;
    
    IF v_film_id_found IS NOT NULL THEN
        SELECT COUNT(inventory_id) INTO v_inventory_count
        FROM inventory
        WHERE film_id = v_film_id_found 
          AND store_id = p_store_id;
    END IF;
    
    RETURN v_inventory_count;
END //

DELIMITER ;

-- Ejemplos de uso
SELECT count_film_inventory('ACADEMY DINOSAUR', 1) AS copies;
SELECT count_film_inventory('1', 1) AS copies;
SELECT count_film_inventory('academy dinosaur', 2) AS copies; 

-- 2
DELIMITER //

CREATE PROCEDURE list_customers_in_country(
    IN p_country VARCHAR(50),
    OUT p_result TEXT
)
BEGIN
    DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE v_customer_name VARCHAR(100);
    DECLARE v_output TEXT DEFAULT '';
    DECLARE v_separator VARCHAR(1) DEFAULT ';';
    
    DECLARE customer_cursor CURSOR FOR
        SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name
        FROM customer c
        INNER JOIN address a USING(address_id)
        INNER JOIN city ci USING(city_id)
        INNER JOIN country co USING(country_id)
        WHERE co.country = p_country
        ORDER BY c.last_name, c.first_name;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
    OPEN customer_cursor;
    customer_loop: LOOP
        FETCH customer_cursor INTO v_customer_name;
        IF v_finished = 1 THEN
            LEAVE customer_loop;
        END IF;
        IF LENGTH(v_output) = 0 THEN
            SET v_output = v_customer_name;
        ELSE
            SET v_output = CONCAT(v_output, v_separator, v_customer_name);
        END IF;
    END LOOP;
    CLOSE customer_cursor;
    SET p_result = v_output;
END //

DELIMITER ;

-- Ejemplos de uso
CALL list_customers_in_country('Canada', @customer_list);
SELECT @customer_list AS 'Customers in Canada';

CALL list_customers_in_country('Mexico', @mx_customers);
SELECT @mx_customers;

CALL list_customers_in_country('United States', @us_list);
SELECT @us_list;

-- 3 - inventory_in_stock

DELIMITER //

CREATE FUNCTION inventory_in_stock(p_inventory_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out INT;
    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;
    IF v_rentals = 0 THEN
        RETURN TRUE;
    END IF;
    SELECT COUNT(*) INTO v_out
    FROM rental
    WHERE inventory_id = p_inventory_id
      AND return_date IS NULL;
    IF v_out > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END //
DELIMITER ;

-- 3 - film_in_stock

DELIMITER //
CREATE PROCEDURE film_in_stock(
    IN p_film_id INT,
    IN p_store_id INT,
    OUT p_film_count INT
)
READS SQL DATA
BEGIN
    SELECT COUNT(*) INTO p_film_count
    FROM inventory i
    WHERE i.film_id = p_film_id
      AND i.store_id = p_store_id
      AND inventory_in_stock(i.inventory_id) = TRUE;
END //
DELIMITER ;

-- EJEMPLOS DE USO
CALL film_in_stock(1, 1, @available);
SELECT @available AS 'Available Copies';


CALL film_in_stock(2, 1, @film2_count);
CALL film_in_stock(3, 2, @film3_count);
SELECT @film2_count AS 'Film 2 - Store 1', @film3_count AS 'Film 3 - Store 2';

SELECT 
    f.film_id,
    f.title,
    (SELECT COUNT(*) 
     FROM inventory i 
     WHERE i.film_id = f.film_id 
       AND i.store_id = 1 
       AND inventory_in_stock(i.inventory_id) = TRUE) AS available_at_store_1
FROM film f
HAVING available_at_store_1 > 0
LIMIT 10;