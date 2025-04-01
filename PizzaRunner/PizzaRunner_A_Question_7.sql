USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
	t1.customer_id,
	COUNT(CASE WHEN t1.exclusions IS NOT NULL OR t1.extras IS NOT NULL THEN t1.pizza_id ELSE NULL END) AS total_pizzas_had_change,
	COUNT(CASE WHEN t1.exclusions IS NULL AND t1.extras IS NULL THEN t1.pizza_id ELSE NULL END) AS total_pizzas_had_no_change
FROM customer_orders AS t1
INNER JOIN runner_orders AS t2
	ON t1.order_id = t2.order_id
WHERE t2.cancellation IS NULL
GROUP BY t1.customer_id
ORDER BY t1.customer_id ASC;