USE DannysDinerDBUI;
GO
-- Question 6: Which item was purchased first by the customer after they became a member?
SELECT
	customer_id,
	product_name,
	order_date
FROM (
	SELECT
		t1.customer_id,
		t2.product_name,
		t1.order_date,
		RANK()
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY t1.order_date ASC
			) AS ranking
	FROM sales AS t1
	INNER JOIN menu AS t2
		ON t1.product_id = t2.product_id
	INNER JOIN members AS t3
		ON t1.customer_id = t3.customer_id
		AND t1.order_date >= t3.join_date
) AS ranking_order_buy_after_become_member_each_customer_tb
WHERE ranking = 1
ORDER BY customer_id ASC;