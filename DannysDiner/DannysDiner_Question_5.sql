USE DannysDinerDBUI;
GO
-- Question 5: Which item was the most popular for each customer?
WITH ranking_product_purchased_each_customer_tb AS (
	SELECT
		t1.customer_id,
		t2.product_name,
		COUNT(t1.product_id) AS total_orders,
		RANK()
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY COUNT(t1.product_id) DESC
			) AS ranking
	FROM sales AS t1
	INNER JOIN menu AS t2
		ON t1.product_id = t2.product_id
	GROUP BY t1.customer_id, t2.product_name
)
SELECT
	customer_id,
	product_name,
	total_orders
FROM ranking_product_purchased_each_customer_tb
WHERE ranking = 1
ORDER BY customer_id ASC;