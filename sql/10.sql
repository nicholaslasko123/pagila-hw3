/*
 * Management wants to rank customers by how much money they have spent in order to send coupons to the top 10%.
 *
 * Write a query that computes the total amount that each customer has spent.
 * Include a "percentile" column that contains the customer's percentile spending,
 * and include only customers in at least the 90th percentile.
 * Order the results alphabetically.
 *
 * HINT:
 * I used the `ntile` window function to compute the percentile.
 */
WITH CustomerTotals AS (
  SELECT
    c.customer_id,
    UPPER(c.first_name || ' ' || c.last_name) AS customer_name,
    SUM(p.amount) AS total_spent
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
),
RankedCustomers AS (
  SELECT
    customer_id,
    customer_name,
    total_spent,
    NTILE(100) OVER (ORDER BY total_spent ASC) AS spending_percentile
  FROM CustomerTotals
)
SELECT
  customer_id,
  customer_name AS name,
  total_spent AS total_payment,
  spending_percentile AS percentile
FROM RankedCustomers
WHERE spending_percentile >= 90
ORDER BY customer_name;
