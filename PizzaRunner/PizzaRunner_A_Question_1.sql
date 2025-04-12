USE PizzaRunnerDBUI;
GO
-- A. Pizza Metrics
-- Question 1: How many pizzas were ordered?
SELECT COUNT(order_id) AS total_ordered_pizzas
FROM customer_orders;