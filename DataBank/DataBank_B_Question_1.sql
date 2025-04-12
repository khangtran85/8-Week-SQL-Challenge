USE DataBankDBUI;
GO
-- B. Customer Transactions
-- Question 1: What is the unique count and total amount for each transaction type?
SELECT
	txn_type,
	COUNT(*) AS total_unique_txn,
	SUM(txn_amount) AS total_amount
FROM customer_transactions
GROUP BY txn_type
ORDER BY total_amount DESC;