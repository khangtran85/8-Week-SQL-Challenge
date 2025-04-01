USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 2: How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders;