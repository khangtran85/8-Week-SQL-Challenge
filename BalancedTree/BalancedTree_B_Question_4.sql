USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 4: What is the average discount value per transaction?
SELECT ROUND(AVG(CAST(t1.total_discount AS FLOAT)), 2) AS avg_discount_value
FROM (
	SELECT
		txn_id,
		SUM(discount) AS total_discount
	FROM sales
	GROUP BY txn_id
) AS t1;