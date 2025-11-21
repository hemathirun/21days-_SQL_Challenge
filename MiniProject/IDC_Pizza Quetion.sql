--Phase 1 
--List all unique pizza categories (DISTINCT).

SELECT DISTINCT category
FROM pizza_types;

--Display pizza_type_id, name, and ingredients, replacing NULL 
--ingredients with "Missing Data". Show first 5 rows.

SELECT
    pizza_type_id,
    name,
    COALESCE(ingredients, 'Missing Data') AS ingredients
FROM pizza_types
LIMIT 5;

--Check for pizzas missing a price

SELECT *
FROM pizzas
WHERE price IS NULL

--Phase 2: Filtering & Exploration

--Orders placed on '2015-01-01'

SELECT *
FROM orders
WHERE date = '2015-01-01';

--List pizzas with price in descending order
SELECT *
FROM pizzas
ORDER BY price DESC;

--Pizzas sold in sizes 'L' or 'XL'
SELECT *
FROM pizzas
WHERE size IN ('L', 'XL');

--Pizzas priced between $15.00 and $17.00

SELECT *
FROM pizzas
WHERE price BETWEEN 15.00 AND 17.00;

--Pizzas with "Chicken" in the name

SELECT *
FROM pizza_types
WHERE name ILIKE '%chicken%';

--Orders on '2015-02-15' OR placed after 8 PM
SELECT *
FROM orders
WHERE date = '2015-02-15'
   OR time > '20:00:00';

---Phase 3: Sales Performance
--Total quantity of pizzas sold (SUM).

SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

--Average pizza price (AVG)
SELECT AVG(price) AS average_pizza_price
FROM pizzas;

--Total order value per order (JOIN, SUM, GROUP BY).
SELECT
    od.order_id,
    SUM(od.quantity * p.price) AS total_order_value
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY od.order_id;

--Total quantity sold per pizza category (JOIN, GROUP BY).
SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_sold DESC;

--Categories with more than 5,000 pizzas sold (HAVING)

SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
HAVING SUM(od.quantity) > 5000
ORDER BY total_quantity_sold DESC;

--Pizzas never ordered (LEFT/RIGHT JOIN).
SELECT 
    p.pizza_id,
    p.pizza_type_id,
    p.size,
    p.price
FROM pizzas p
LEFT JOIN order_details od
    ON p.pizza_id = od.pizza_id
WHERE od.order_details_id IS NULL;

--Price Differences Between Sizes (SELF JOIN)
SELECT
    p1.pizza_type_id,
    p1.size AS size_1,
    p1.price AS price_1,
    p2.size AS size_2,
    p2.price AS price_2,
    (p2.price - p1.price) AS price_difference
FROM pizzas p1
JOIN pizzas p2
    ON p1.pizza_type_id = p2.pizza_type_id
   AND p1.size < p2.size          -- ensures each pair is compared once
ORDER BY p1.pizza_type_id, size_1, size_2;
