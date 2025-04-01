USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 9: What was the total volume of pizzas ordered for each hour of the day?
WITH hour_in_day AS (
	SELECT 0 AS hour_of_the_day
	UNION ALL
	SELECT hour_of_the_day + 1
	FROM hour_in_day
	WHERE hour_of_the_day + 1 <= 23
),
total_volume_of_pizzas_for_each_hour AS (
	SELECT 
		DATENAME(hour, order_time) AS hour_of_the_day,
		COUNT(order_id) AS total_volume_of_pizzas
	FROM customer_orders
	GROUP BY DATENAME(hour, order_time)
)
SELECT
	t1.hour_of_the_day,
	ISNULL(t2.total_volume_of_pizzas, 0) AS total_volume_of_pizzas
FROM hour_in_day AS t1
LEFT JOIN total_volume_of_pizzas_for_each_hour AS t2
	ON t1.hour_of_the_day = t2.hour_of_the_day
ORDER BY hour_of_the_day ASC;