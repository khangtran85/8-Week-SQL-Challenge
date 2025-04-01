USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- Question 7: What is the successful delivery percentage for each runner?
WITH total_delivery_each_runner_tb AS (
	SELECT
		runner_id,
		CAST(COUNT(DISTINCT order_id) AS FLOAT) AS total_delivery
	FROM runner_orders
	GROUP BY runner_id
),
total_successful_delivery_each_runner_tb AS (
	SELECT
		runner_id,
		CAST(COUNT(DISTINCT order_id) AS FLOAT) AS total_successful_delivery
	FROM runner_orders
	WHERE cancellation IS NULL
	GROUP BY runner_id
)
SELECT
	t1.runner_id,
	CAST(100.00 * t1.total_successful_delivery / t2.total_delivery AS DECIMAL(5, 2)) AS percent_sucessfull_delivery
FROM total_successful_delivery_each_runner_tb AS t1
INNER JOIN total_delivery_each_runner_tb AS t2
	ON t1.runner_id = t2.runner_id
ORDER BY t1.runner_id ASC;