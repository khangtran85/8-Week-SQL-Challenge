USE DataBankDBUI;
GO
-- B. Customer Transactions
-- Question 2: What is the average total historical deposit counts and amounts for all customers?
WITH total_deposit_txns_per_customer_tb AS (
	SELECT
		customer_id,
		COUNT(txn_type) AS total_deposit_counts,
		SUM(txn_amount) AS total_deposit_amounts
	FROM customer_transactions
	WHERE txn_type = 'deposit'
	GROUP BY customer_id
)
SELECT
	ROUND(AVG(CAST(total_deposit_counts AS FLOAT)), 2) AS avg_total_deposit_counts,
	ROUND(AVG(CAST(total_deposit_amounts AS FLOAT)), 2) AS avg_total_deposit_amounts
FROM total_deposit_txns_per_customer_tb;