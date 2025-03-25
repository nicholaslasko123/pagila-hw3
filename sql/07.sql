/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
WITH BacallActor AS (
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL'
      AND last_name = 'BACALL'
),
BacallNumber1 AS (
    -- Actors who appeared in a film with Russell Bacall (Bacall Number 1)
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN (
          SELECT film_id
          FROM film_actor
          WHERE actor_id IN (SELECT actor_id FROM BacallActor)
    )
    AND fa.actor_id NOT IN (SELECT actor_id FROM BacallActor)
),
BacallNumber2 AS (
    -- Actors who appeared in a film with someone from Bacall Number 1,
    -- but did NOT appear directly with Russell Bacall
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN (
          SELECT film_id
          FROM film_actor
          WHERE actor_id IN (SELECT actor_id FROM BacallNumber1)
    )
    AND fa.actor_id NOT IN (SELECT actor_id FROM BacallNumber1)
    AND fa.actor_id NOT IN (SELECT actor_id FROM BacallActor)
)
SELECT DISTINCT UPPER(a.first_name || ' ' || a.last_name) AS "Actor Name"
FROM actor a
JOIN BacallNumber2 bn2 ON a.actor_id = bn2.actor_id
ORDER BY "Actor Name";
