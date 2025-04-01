USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 6: What was the maximum number of pizzas delivered in a single order?
WITH total_pizzas_delivered_in_single_order AS (
	SELECT
		t1.order_id,
		COUNT(t1.order_id) AS total_pizzas
	FROM customer_orders AS t1
	INNER JOIN runner_orders AS t2
		ON t1.order_id = t2.order_id
	WHERE t2.cancellation IS NULL
	GROUP BY t1.order_id
)
SELECT MAX(total_pizzas) AS max_pizzas
FROM total_pizzas_delivered_in_single_order;