USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 6: What is the average revenue for member transactions and non-member transactions?
WITH member_avg_revenue_tb AS (
	SELECT
		member,
		AVG(CAST(qty AS FLOAT) * CAST(price AS FLOAT) - CAST(discount AS FLOAT)) AS avg_revenue
	FROM sales
	GROUP BY member
)
SELECT
	CASE WHEN member = 't' THEN 'member' ELSE 'non-member' END AS member_status,
	ROUND(avg_revenue, 2) AS avg_revenue
FROM member_avg_revenue_tb;