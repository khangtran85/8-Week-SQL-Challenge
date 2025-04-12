USE DataBankDBUI;
GO
-- B. Customer Transactions
-- Question 3: For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
WITH customer_txn_breakdown_by_month_tb AS (
	SELECT
		customer_id,
		DATETRUNC(month, txn_date) AS txn_month,
		COUNT(CASE WHEN txn_type = 'deposit' THEN txn_type ELSE NULL END) AS total_deposit_txns,
		COUNT(CASE WHEN txn_type = 'purchase' THEN txn_type ELSE NULL END) AS total_purchase_txns,
		COUNT(CASE WHEN txn_type = 'withdrawal' THEN txn_type ELSE NULL END) AS total_withdrawal_txns
	FROM customer_transactions
	GROUP BY customer_id, DATETRUNC(month, txn_date)
)
SELECT
	txn_month,
	COUNT(customer_id) AS total_customers
FROM customer_txn_breakdown_by_month_tb
WHERE total_deposit_txns > 1 AND (total_purchase_txns = 1 OR total_withdrawal_txns = 1)
GROUP BY txn_month
ORDER BY txn_month ASC;