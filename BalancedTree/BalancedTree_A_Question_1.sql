USE BalancedTreeDBUI;
GO
-- A. High Level Sales Analysis
-- Question 1: What was the total quantity sold for all products?
SELECT SUM(qty) AS total_quantity
FROM sales;