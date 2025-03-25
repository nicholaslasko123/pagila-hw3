/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */
WITH american_circus_actors AS (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'AMERICAN CIRCUS'
),
movies_with_shared_actors AS (
    SELECT fa.film_id, COUNT(DISTINCT fa.actor_id) AS shared_count
    FROM film_actor fa
    WHERE fa.actor_id IN (SELECT actor_id FROM american_circus_actors)
    GROUP BY fa.film_id
    HAVING COUNT(DISTINCT fa.actor_id) >= 2
)
SELECT f.title
FROM film f
JOIN movies_with_shared_actors msa ON f.film_id = msa.film_id
ORDER BY f.title ASC;
