USE DataBankDBUI;
GO
-- B. Customer Transactions
-- Question 4: What is the closing balance for each customer at the end of the month?
SELECT
	customer_id,
	closing_date,
	closing_balance
FROM customer_monthly_balance_summary_vw
ORDER BY customer_id ASC, closing_date ASC;