USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 3: What is the top selling product for each segment?
WITH segment_product_sales_ranking_tb AS (
	SELECT
		t2.segment_name,
		t2.product_name,
		SUM(t1.qty) AS total_quantity_sold,
		RANK()
			OVER(
				PARTITION BY t2.segment_name
				ORDER BY SUM(t1.qty) DESC
			) AS ranking
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	GROUP BY t2.segment_name, t2.product_name
)
SELECT
	segment_name,
	product_name AS top_selling_product,
	total_quantity_sold
FROM segment_product_sales_ranking_tb
WHERE ranking = 1
ORDER BY top_selling_product DESC;