USE DataBankDBUI;
GO
-- A. Customer Nodes Exploration
-- Question 3: How many customers are allocated to each region?
SELECT
	t2.region_name,
	COUNT(DISTINCT t1.customer_id) AS total_customers
FROM customer_nodes AS t1
INNER JOIN regions AS t2
	ON t1.region_id = t2.region_id
GROUP BY t2.region_name
ORDER BY total_customers DESC;