USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 7: What is the percentage split of revenue by segment for each category?
WITH segment_product_revenue_summary_tb AS (
	SELECT
		t2.category_name,
		t2.product_name,
		SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
		SUM(SUM(t1.qty * t1.price - t1.discount)) OVER(PARTITION BY t2.category_name) AS total_revenue_all
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	GROUP BY t2.category_name, t2.product_name
)
SELECT
	category_name,
	product_name,
	total_revenue,
	ROUND(CAST(total_revenue AS FLOAT) / CAST(total_revenue_all AS FLOAT) * 100, 2) AS percentage_total_revenuve
FROM segment_product_revenue_summary_tb;