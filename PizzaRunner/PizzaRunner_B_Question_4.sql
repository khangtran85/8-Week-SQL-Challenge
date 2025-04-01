USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- Question 4: What was the average distance travelled for each runner?
SELECT
	runner_id,
	ROUND(AVG(distance), 2) AS avg_distance
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY runner_id ASC;