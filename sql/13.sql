/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */
WITH ActorRevenue AS (
  SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    f.film_id,
    f.title,
    SUM(p.amount) AS total_revenue
  FROM actor a
  INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
  INNER JOIN film f ON fa.film_id = f.film_id
  INNER JOIN inventory i ON f.film_id = i.film_id
  INNER JOIN rental r ON i.inventory_id = r.inventory_id
  INNER JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY a.actor_id, a.first_name, a.last_name, f.film_id, f.title
),
RankedFilms AS (
  SELECT
    actor_id,
    first_name,
    last_name,
    film_id,
    title,
    total_revenue,
    ROW_NUMBER() OVER (
      PARTITION BY actor_id
      ORDER BY total_revenue DESC, film_id
    ) AS film_rank
  FROM ActorRevenue
)
SELECT
  actor_id,
  first_name,
  last_name,
  film_id,
  title,
  film_rank AS rank,
  total_revenue AS revenue
FROM RankedFilms
WHERE film_rank <= 3
ORDER BY actor_id, film_rank;
