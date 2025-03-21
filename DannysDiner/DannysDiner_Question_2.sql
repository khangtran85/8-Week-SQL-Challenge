USE DannysDinerDBUI;
GO
-- Question 2: How many days has each customer visited the restaurant?
SELECT
	customer_id,
	COUNT(DISTINCT order_date) AS total_visited_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id ASC;