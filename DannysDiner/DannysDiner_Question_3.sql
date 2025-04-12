USE DannysDinerDBUI;
GO
-- Question 3: What was the first item from the menu purchased by each customer?
WITH ranking_order_each_customer_tb AS (
	SELECT
		customer_id,
		product_id,
		order_date,
		RANK()
			OVER(
				PARTITION BY customer_id
				ORDER BY order_date ASC
			) AS ranking
	FROM sales
)
SELECT
	t1.customer_id,
	t1.order_date,
	STRING_AGG(t2.product_name, ', ') AS first_order
FROM ranking_order_each_customer_tb AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
WHERE t1.ranking = 1
GROUP BY t1.customer_id, t1.order_date
ORDER BY t1.customer_id ASC;