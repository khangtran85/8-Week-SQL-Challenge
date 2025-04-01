USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- Question 3: Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH total_pizzas_each_order_id_tb AS (
	SELECT
		t1.order_id,
		1.00 * COUNT(t1.pizza_id) AS total_pizzas
	FROM customer_orders AS t1
	INNER JOIN runner_orders AS t2
		ON t1.order_id = t2.order_id
	WHERE t2.cancellation IS NULL
	GROUP BY t1.order_id
),
prepare_time_each_order_id_tb AS (
	SELECT DISTINCT
		t1.order_id,
		1.00 * DATEDIFF(minute, t1.order_time, t2.pickup_time) AS total_minutes
	FROM customer_orders AS t1
	INNER JOIN runner_orders AS t2
		ON t1.order_id = t2.order_id
	WHERE t2.cancellation IS NULL
),
pizza_prep_relation_tb AS (
	SELECT
		t1.total_pizzas AS x,
		t2.total_minutes AS y,
		t1.total_pizzas - AVG(t1.total_pizzas) OVER() AS x_minus_avgx,
		t2.total_minutes - AVG(t2.total_minutes) OVER() AS y_minus_avgy
	FROM total_pizzas_each_order_id_tb AS t1
	INNER JOIN prepare_time_each_order_id_tb AS t2
		ON t1.order_id = t2.order_id
)
SELECT
	ROUND(
		AVG(x_minus_avgx * y_minus_avgy)
		/
		(
			SQRT(AVG(POWER(x_minus_avgx, 2)))
			*
			SQRT(AVG(POWER(y_minus_avgy, 2)))
		),
	2) AS corr_xy
FROM pizza_prep_relation_tb;