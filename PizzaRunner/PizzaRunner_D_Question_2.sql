USE PizzaRunnerDBUI;
GO
-- D. Pricing and Ratings
-- Question 2: hat if there was an additional $1 charge for any pizza extras? Ex: Add cheese is $1 extra.
WITH successfull_delivery_order_tb AS (
	SELECT
		t1.order_number,
		t3.pizza_name,
		t1.extras
	FROM customer_orders AS t1
	INNER JOIN runner_orders AS t2
		ON t1.order_id = t2.order_id
	INNER JOIN pizza_full_info AS t3
		ON t1.pizza_id = t3.pizza_id
	WHERE t2.cancellation IS NULL
),
total_price_each_order_tb AS (
	SELECT
		order_number,
		SUM(CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS total_price
	FROM successfull_delivery_order_tb
	GROUP BY order_number
),
extras_pizza_order_tb AS (
	SELECT
		t1.order_number,
		COUNT(CAST(t2.value AS INT)) AS total_additional_charge
	FROM successfull_delivery_order_tb AS t1
	CROSS APPLY STRING_SPLIT(t1.extras, ',') AS t2
	GROUP BY t1.order_number
)
SELECT SUM(t1.total_price + COALESCE(t2.total_additional_charge, 0)) AS total_revenue
FROM total_price_each_order_tb AS t1
LEFT JOIN extras_pizza_order_tb AS t2
	ON t1.order_number = t2.order_number;