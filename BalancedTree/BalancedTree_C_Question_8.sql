USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 8: What is the percentage split of total revenue by category?
WITH category_revenue_summary_tb AS (
	SELECT
		t2.category_name,
		SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
		SUM(SUM(t1.qty * t1.price - t1.discount)) OVER() AS total_revenue_all
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	GROUP BY t2.category_name
)
SELECT
	category_name,
	total_revenue,
	ROUND(CAST(total_revenue AS FLOAT) / CAST(total_revenue_all AS FLOAT) * 100, 2) AS percentage_total_revenue
FROM category_revenue_summary_tb;