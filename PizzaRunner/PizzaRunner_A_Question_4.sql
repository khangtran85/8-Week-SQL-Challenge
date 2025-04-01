USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 4: How many of each type of pizza was delivered?
SELECT
	t3.pizza_name,
	COUNT(t1.order_id) AS total_orders
FROM customer_orders AS t1
INNEr JOIN runner_orders AS t2
	ON t1.order_id = t2.order_id
INNER JOIN pizza_full_info AS t3
	ON t1.pizza_id = t3.pizza_id
WHERE t2.cancellation IS NULL
GROUP BY t3.pizza_name;