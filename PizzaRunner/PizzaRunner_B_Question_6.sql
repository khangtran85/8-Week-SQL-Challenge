USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
	runner_id,
	order_id,
	ROUND(AVG(distance / duration * 60), 2) AS avg_speed
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id, order_id
ORDER BY runner_id ASC, order_id ASC;

-- => "The runners are getting faster."