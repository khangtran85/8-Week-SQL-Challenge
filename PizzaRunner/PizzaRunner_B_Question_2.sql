USE PizzaRunnerDBUI;
GO
-- B. Runner and Custoemr Experience
-- Question 2: What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
	ROUND(AVG(DATEDIFF(minute, order_time, pickup_time)), 2) AS avg_runner_to_arrive_at_the_PRHQ
FROM runner_orders AS t1
INNER JOIN customer_orders AS t2
	ON t1.order_id = t2.order_id
WHERE t1.cancellation IS NULL;