/*
 * List the total amount of money that customers from each country have payed.
 * Order the results from most to least money.
 */
WITH country_totals AS (
  SELECT co.country, SUM(p.amount) AS total_payments
  FROM payment p
  JOIN customer c ON p.customer_id = c.customer_id
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country co ON ci.country_id = co.country_id
  GROUP BY co.country
)
SELECT country, total_payments
FROM country_totals
ORDER BY total_payments DESC, country ASC;
