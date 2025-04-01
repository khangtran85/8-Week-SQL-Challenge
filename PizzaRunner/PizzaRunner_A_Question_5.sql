USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 5: How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
	t1.customer_id,
	COUNT(CASE WHEN t2.pizza_name = 'Vegetarian' THEN 1	ELSE NULL END) AS total_vegetarian_orders,
	COUNT(CASE WHEN t2.pizza_name = 'Meatlovers' THEN 1	ELSE NULL END) AS total_meatlovers_orders
FROM customer_orders AS t1
INNER JOIN pizza_full_info AS t2
	ON t1.pizza_id = t2.pizza_id
GROUP BY t1.customer_id
ORDER BY t1.customer_id ASC;