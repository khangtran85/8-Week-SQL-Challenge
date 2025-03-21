USE DannysDinerDBUI;
GO
-- What is the total items and amount spent for each member before they became a member?
SELECT
	t1.customer_id,
	COUNT(t2.product_id) AS total_items,
	SUM(t2.price) AS total_amount_spent
FROM sales AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
INNER JOIN members AS t3
	ON t1.customer_id = t3.customer_id
	AND t1.order_date < t3.join_date
GROUP BY t1.customer_id
ORDER BY t1.customer_id ASC;