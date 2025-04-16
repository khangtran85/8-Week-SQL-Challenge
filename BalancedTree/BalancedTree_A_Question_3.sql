USE BalancedTreeDBUI;
GO
-- A. High Level Sales Analysis
-- Question 3: What was the total discount amount for all products?
SELECT SUM(discount) AS total_discount_amount
FROM sales;