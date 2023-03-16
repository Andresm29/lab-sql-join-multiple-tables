# In this lab, you will be using the Sakila database of movie rentals.
USE sakila;

# 1. Write a query to display for each store its store ID, city, and country.
SELECT 
    store.store_id, city.city, country.country
FROM
    store
        JOIN
    address ON store.address_id = address.address_id
        JOIN
    city ON address.city_id = city.city_id
        JOIN
    country ON city.country_id = country.country_id;

# 2. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    store.store_id, SUM(payment.amount) AS total_sales
FROM
    store
        JOIN
    staff ON store.store_id = staff.store_id
        JOIN
    payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

# 3. What is the average running time of films by category?
SELECT 
    category.name, AVG(film.length) AS average_running_time
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film_category.film_id = film.film_id
GROUP BY category.name;

# 4. Which film categories are longest?
SELECT 
    category.name, AVG(film.length) AS average_running_time
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    film ON film_category.film_id = film.film_id
GROUP BY category.name
ORDER BY AVG(film.length) DESC;

# 5. Display the most frequently rented movies in descending order.
SELECT 
    film.title, COUNT(rental.rental_id) AS rental_count
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
ORDER BY rental_count DESC;

# 6. List the top five genres in gross revenue in descending order.
SELECT 
    category.name, SUM(payment.amount) AS gross_revenue
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    inventory ON film_category.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        JOIN
    payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY total_revenue DESC
LIMIT 5;

# 7. Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    inventory.inventory_id
FROM
    inventory
        JOIN
    film ON inventory.film_id = film.film_id
        JOIN
    store ON inventory.store_id = store.store_id
        LEFT JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        AND rental.return_date IS NULL
WHERE
    film.title = "Academy Dinosaur"
        AND store.store_id = 1
        AND rental.rental_id IS NULL;