USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 1: How many unique transactions were there?
SELECT COUNT(DISTINCT txn_id) AS total_unique_transactions
FROM sales;