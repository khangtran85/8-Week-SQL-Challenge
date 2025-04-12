USE DannysDinerDBUI;
GO
-- Question 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
	t1.customer_id,
	SUM(t2.price * CASE WHEN t2.product_name = 'sushi' THEN 20 ELSE 10 END) AS total_points
FROM sales AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
GROUP BY t1.customer_id
ORDER BY customer_id ASC;