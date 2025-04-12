USE DannysDinerDBUI;
GO
-- Which item was purchased just before the customer became a member?
WITH ranking_order_buy_before_become_member_each_customer_tb AS (
	SELECT
		t1.customer_id,
		t2.product_name,
		t1.order_date,
		RANK()
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY t1.order_date DESC
			) AS ranking
	FROM sales AS t1
	INNER JOIN menu AS t2
		ON t1.product_id = t2.product_id
	INNER JOIN members AS t3
		ON t1.customer_id = t3.customer_id
		AND t1.order_date < t3.join_date
)
SELECT
	customer_id,
	product_name,
	order_date
FROM ranking_order_buy_before_become_member_each_customer_tb
WHERE ranking = 1
ORDER BY customer_id ASC;