USE DannysDinerDBUI;
GO
-- Join all the things
DROP TABLE IF EXISTS DannysDinerDBUI.dbo.additional_table_1;
SELECT
	t1.customer_id,
	t1.order_date,
	t2.product_name,
	t2.price,
	CASE
		WHEN t1.order_date >= t3.join_date THEN 'Y'
		ELSE 'N'
	END AS member
INTO DannysDinerDBUI.dbo.additional_table_1
FROM sales AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
INNER JOIN members AS t3
	ON t1.customer_id = t3.customer_id
ORDER BY customer_id ASC, order_date ASC;