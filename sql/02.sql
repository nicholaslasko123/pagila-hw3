/*
 * Compute the country with the most customers in it. 
 */
WITH country_customer_counts AS (
    SELECT co.country, COUNT(*) AS customer_count
    FROM customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    GROUP BY co.country
)
SELECT country
FROM country_customer_counts
WHERE customer_count = (SELECT MAX(customer_count) FROM country_customer_counts);
