USE PizzaRunnerDBUI;
GO
-- D. Pricing and Ratings
-- Question 1: If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
	SUM(CASE WHEN t3.pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) AS total_revenue
FROM customer_orders AS t1
INNER JOIN runner_orders AS t2
	ON t1.order_id = t2.order_id
INNER JOIN pizza_full_info AS t3
	ON t1.pizza_id = t3.pizza_id
WHERE t2.cancellation IS NULL;