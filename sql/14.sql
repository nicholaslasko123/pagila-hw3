/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */
WITH FilmRentalTotals AS (
  SELECT
    cat.category_id,
    cat.name AS category_name,
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rental_count
  FROM film f
  INNER JOIN film_category fc ON f.film_id = fc.film_id
  INNER JOIN category cat ON fc.category_id = cat.category_id
  INNER JOIN inventory i ON f.film_id = i.film_id
  INNER JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY cat.category_id, cat.name, f.film_id, f.title
),
RankedFilms AS (
  SELECT
    category_id,
    category_name,
    film_id,
    title,
    rental_count,
    ROW_NUMBER() OVER (
      PARTITION BY category_id
      ORDER BY rental_count DESC, film_id DESC
    ) AS film_rank
  FROM FilmRentalTotals
)
SELECT
  category_name AS name,
  title AS title,
  rental_count AS "total rentals"
FROM RankedFilms
WHERE film_rank <= 5
ORDER BY category_name, rental_count DESC, film_id ASC;
