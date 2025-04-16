USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 3: What are the 25th, 50th and 75th percentile values for the revenue per transaction?
SELECT DISTINCT
	'_25th_percentile_for_revenue' AS percentile,
	PERCENTILE_CONT(0.25) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS percentile_value
FROM sales

UNION ALL

SELECT DISTINCT
	'_50th_percentile_for_revenue' AS percentile,
	PERCENTILE_CONT(0.5) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS percentile_value
FROM sales

UNION ALL

SELECT DISTINCT
	'_75th_percentile_for_revenue' AS percentile,
	PERCENTILE_CONT(0.75) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS percentile_value
FROM sales;