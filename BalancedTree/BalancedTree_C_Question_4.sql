USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 3: What is the total quantity, revenue and discount for each category?
SELECT
	t2.category_name,
	SUM(t1.qty) AS total_quantity,
	SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
	SUM(t1.discount) AS total_discount
FROM sales AS t1
INNER JOIN product_details AS t2
	ON t1.prod_id = t2.product_id
GROUP BY t2.category_name;