USE PizzaRunnerDBUI;
GO
-- D. Pricing and Ratings
-- Question 5: If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
WITH order_invoice_summary AS (
	SELECT
		t1.order_id,
		SUM(CASE WHEN t3.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS total_invoice
	FROM runner_orders AS t1
	INNER JOIN customer_orders AS t2
		ON t1.order_id = t2.order_id
	INNER JOIN pizza_full_info AS t3
		ON t2.pizza_id = t3.pizza_id
	WHERE t1.cancellation IS NULL
	GROUP BY t1.order_id
),
delivery_fee_summary AS (
	SELECT
		order_id,
		0.3 * distance AS traveled_fee
	FROM runner_orders
	WHERE cancellation IS NULL
)
SELECT SUM(t1.total_invoice - t2.traveled_fee) AS total_revenue
FROM order_invoice_summary AS t1
INNER JOIN delivery_fee_summary AS t2
	ON t1.order_id = t2.order_id;