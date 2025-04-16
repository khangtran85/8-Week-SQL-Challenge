USE BalancedTreeDBUI;
GO
-- B. Transaction Analysis
-- Question 5: What is the percentage split of all transactions for members vs non-members?
WITH transactions_per_member_tb AS (
	SELECT
		member,
		COUNT(DISTINCT txn_id) AS total_transactions,
		SUM(COUNT(DISTINCT txn_id)) OVER() AS total_transactions_all
	FROM sales
	GROUP BY member
)
SELECT
	CASE WHEN member = 't' THEN 'member' ELSE 'non-member' END AS member_status,
	ROUND(CAST(total_transactions AS FLOAT) / CAST(total_transactions_all AS FLOAT) * 100, 2) AS percentage_total_transactions
FROM transactions_per_member_tb;