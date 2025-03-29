USE DannysDinerDBUI;
GO
-- Question 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer have?
WITH point_each_customer AS (
	SELECT
		t1.customer_id,
		t1.order_date,
		t2.price,
		CASE
			WHEN t2.product_name = 'sushi' THEN 20
			WHEN t2.product_name != 'sushi' AND (t1.order_date >= t3.join_date AND t1.order_date <= DATEADD(day, 6, t3.join_date)) THEN 20
			ELSE 10
		END AS points
	FROM sales AS t1
	INNER JOIN menu AS t2
		ON t1.product_id = t2.product_id
	INNER JOIN members AS t3
		ON t1.customer_id = t3.customer_id
)
SELECT
	customer_id,
	SUM(price * points) AS total_points
FROM point_each_customer
GROUP BY customer_id
ORDER BY customer_id ASC;
