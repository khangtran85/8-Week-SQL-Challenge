USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 3: How many successful orders were delivered by each runner?
SELECT
	t2.runner_id,
	COUNT(t1.order_id) AS total_successful_orders
FROM customer_orders AS t1
INNER JOIN runner_orders AS t2
	ON t1.order_id = t2.order_id
WHERE t2.cancellation IS NULL
GROUP BY t2.runner_id;