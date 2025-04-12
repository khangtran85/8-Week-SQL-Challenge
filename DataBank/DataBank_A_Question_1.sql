USE DataBankDBUI;
GO
-- A. Customer Nodes Exploration
-- Question 1: How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS total_unique_nodes
FROM customer_nodes;