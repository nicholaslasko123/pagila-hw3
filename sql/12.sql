/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
SELECT
  c.customer_id,
  c.first_name,
  c.last_name
FROM customer c
CROSS JOIN LATERAL (
  SELECT COUNT(*) AS action_count
  FROM (
    SELECT r.rental_date, cat.name AS category
    FROM rental r
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film f ON i.film_id = f.film_id
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category cat ON fc.category_id = cat.category_id
    WHERE r.customer_id = c.customer_id
    ORDER BY r.rental_date DESC
    LIMIT 5
  ) AS latest_rentals
  WHERE latest_rentals.category = 'Action'
) AS act_count
WHERE act_count.action_count >= 3
ORDER BY c.customer_id;
