USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 1: What are the top 3 products by total revenue before discount?
WITH product_revenue_ranking AS (
	SELECT
		prod_id,
		SUM(qty * price) AS total_revenue_before_discount,
		DENSE_RANK() OVER(ORDER BY SUM(qty * price) DESC) AS ranking
	FROM sales
	GROUP BY prod_id
)
SELECT
	t2.product_name,
	t1.total_revenue_before_discount
FROM product_revenue_ranking AS t1
INNER JOIN product_details AS t2
	ON t1.prod_id = t2.product_id
WHERE t1.ranking <= 3
ORDER BY t1.ranking ASC;