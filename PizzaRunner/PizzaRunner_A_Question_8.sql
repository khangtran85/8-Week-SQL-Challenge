USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 8: How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(CASE WHEN t1.exclusions IS NOT NULL AND t1.extras IS NOT NULL THEN t1.pizza_id ELSE NULL END) AS total_pizzas_had_exclusions_and_extras
FROM customer_orders AS t1
INNER JOIN runner_orders AS t2
	ON t1.order_id = t2.order_id
WHERE t2.cancellation IS NULL;