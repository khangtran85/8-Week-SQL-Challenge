USE PizzaRunnerDBUI;
GO
-- D. Pricing and Ratings
-- Question 4: Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--	customer_id
--	order_id
--	runner_id
--	rating
--	order_time
--	pickup_time
--	Time between order and pickup
--	Delivery duration
--	Average speed
--	Total number of pizzas
WITH order_delivery_details AS (
	SELECT DISTINCT
		t2.customer_id,
		t2.order_id,
		t1.runner_id,
		t3.rating,
		t2.order_time,
		t1.pickup_time,
		DATEDIFF(minute, t2.order_time, t1.pickup_time) AS order_to_pickup_time,
		t1.duration AS deliver_duration
	FROM runner_orders AS t1
	INNER JOIN customer_orders AS t2
		ON t1.order_id = t2.order_id
	INNER JOIN runner_ratings AS t3
		ON t1.order_id = t3.order_id
	WHERE t1.cancellation IS NULL
),
pizza_order_metrics AS (
	SELECT
		t1.order_id,
		CAST(ROUND(AVG(t1.distance / t1.duration * 60), 2) AS DECIMAL(5, 2)) AS avg_speed,
		COUNT(t2.pizza_id) AS total_pizzas
	FROM runner_orders AS t1
	INNER JOIN customer_orders AS t2
		ON t1.order_id = t2.order_id
	WHERE cancellation IS NULL
	GROUP BY t1.order_id
)
SELECT
	t1.*,
	t2.avg_speed,
	t2.total_pizzas
FROM order_delivery_details AS t1
INNER JOIN pizza_order_metrics AS t2
	ON t1.order_id = t2.order_id
ORDER BY order_id ASC;