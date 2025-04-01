USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- Question 5: What was the difference between the longest and shortest delivery times for all orders?
SELECT
	MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders
WHERE cancellation IS NULL;