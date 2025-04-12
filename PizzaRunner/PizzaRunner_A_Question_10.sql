USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 10: What was the volume of orders for each day of the week?
WITH days_of_week AS (
	SELECT 7 AS day_num, DATENAME(weekday, 7) AS day_name
	UNION ALL
	SELECT day_num + 1, DATENAME(weekday, day_num + 1)
	FROM days_of_week
	WHERE day_num + 1 <= 13
),
total_volumne_of_orders_for_each_day_of_week AS (
	SELECT
		DATENAME(weekday, order_time) AS day_of_week,
		COUNT(DISTINCT order_id) AS total_orders
	FROM customer_orders
	GROUP BY DATENAME(weekday, order_time)
)
SELECT
	t1.day_name,
	ISNULL(t2.total_orders, 0) AS total_orders
FROM days_of_week AS t1
LEFT JOIN total_volumne_of_orders_for_each_day_of_week AS t2
	ON t1.day_name = t2.day_of_week
ORDER BY t1.day_num ASC;