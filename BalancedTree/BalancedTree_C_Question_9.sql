USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 9: What is the total and percentage of transactions “penetration” for each product?
--	(Hint: Penetration = Number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
WITH product_transaction_count_tb AS (
	SELECT
		t2.product_name,
		COUNT(t1.txn_id) AS total_transactions
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	GROUP BY t2.product_name
)
SELECT
	product_name,
	total_transactions,
	ROUND(CAST(total_transactions AS FLOAT)
		/ CAST((SELECT COUNT(DISTINCT txn_id) FROM sales) AS FLOAT) * 100, 2)AS percentage_total_txn_penetration
FROM product_transaction_count_tb;