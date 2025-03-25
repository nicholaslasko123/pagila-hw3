/*
 * Find every documentary film that is rated G.
 * Report the title and the actors.
 *
 * HINT:
 * Getting the formatting right on this query can be tricky.
 * You are welcome to try to manually get the correct formatting.
 * But there is also a view in the database that contains the correct formatting,
 * and you can SELECT from that VIEW instead of constructing the entire query manually.
 */
WITH FormattedFilms AS (
  SELECT
    title,
    regexp_replace(INITCAP(actors), '([A-Za-z]+) ([A-Za-z]+)', '\1\2', 'g') AS formatted_actors,
    category,
    rating
  FROM film_list
)
SELECT title, formatted_actors AS actors
FROM FormattedFilms
WHERE category = 'Documentary'
  AND rating = 'G'
ORDER BY title;
