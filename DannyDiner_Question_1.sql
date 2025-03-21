USE DannysDinerDBUI;
GO
-- Question 1: What is the total amount each customer spent at the restaurant?
SELECT
	customer_id,
	SUM(price) AS total_amount
FROM sales AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
GROUP BY customer_id
ORDER BY customer_id ASC;