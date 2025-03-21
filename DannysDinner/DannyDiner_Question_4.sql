USE DannysDinerDBUI;
GO
-- Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH ranking_product_name_tb AS (
	SELECT
		t2.product_name,
		COUNT(t1.product_id) AS total_orders,
		RANK()
			OVER(ORDER BY COUNT(t1.product_id) DESC) AS ranking
	FROM sales AS t1
	INNER JOIN menu AS t2
		ON t1.product_id = t2.product_id
	GROUP BY t2.product_name
)
SELECT
	product_name,
	total_orders
FROM ranking_product_name_tb;