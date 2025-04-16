USE BalancedTreeDBUI;
GO
-- A. High Level Sales Analysis
-- Question 2: What is the total generated revenue for all products before discounts?
SELECT SUM(qty * price) AS total_generated_revenue
FROM sales;