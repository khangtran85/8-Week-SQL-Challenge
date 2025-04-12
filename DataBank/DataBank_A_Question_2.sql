USE DataBankDBUI;
GO
-- A. Customer Nodes Exploration
-- Question 2: What is the number of nodes per region?
SELECT
	t2.region_name,
	COUNT(DISTINCT t1.node_id) AS total_nodes
FROM customer_nodes AS t1
INNER JOIN regions AS t2
	ON t1.region_id = t2.region_id
GROUP BY t2.region_name
ORDER BY total_nodes DESC;