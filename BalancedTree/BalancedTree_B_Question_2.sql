USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 2: What is the average unique products purchased in each transaction?
SELECT ROUND(AVG(CAST(t1.total_unique_purchased_products AS FLOAT)), 2) AS avg_unique_purchased_products
FROM (
	SELECT
		txn_id,
		COUNT(DISTINCT prod_id) AS total_unique_purchased_products
	FROM sales
	GROUP BY txn_id
) AS t1;