USE DataBankDBUI;
GO
-- B. Customer Transactions
-- Question 5: What is the percentage of customers who increase their closing balance by more than 5%?
WITH customer_first_last_balance_months_tb AS (
	SELECT
		customer_id,
		closing_date,
		closing_balance,
		FIRST_VALUE(closing_date)
			OVER(
				PARTITION BY customer_id
				ORDER BY closing_date ASC
			) AS first_txn_month,
		LAST_VALUE(closing_date)
			OVER(
				PARTITION BY customer_id
				ORDER BY closing_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
			) AS last_txn_month
	FROM customer_monthly_balance_summary_vw
),
customer_monthly_balance_with_previous_tb AS (
	SELECT
		customer_id,
		closing_date AS last_txn_month,
		closing_balance AS last_closing_balance,
		LAG(closing_balance, 1)
			OVER(
				PARTITION BY customer_id
				ORDER BY closing_date ASC
			) AS first_closing_balance
	FROM customer_first_last_balance_months_tb
	WHERE closing_date = first_txn_month OR closing_date = last_txn_month
),
customer_closing_balance_growth_flag_tb AS (
	SELECT
		customer_id,
		last_txn_month,
		first_closing_balance,
		last_closing_balance,
		CASE
			WHEN first_closing_balance = 0 AND (last_closing_balance - first_closing_balance) > 0 THEN 1
			WHEN first_closing_balance <> 0 AND CAST((last_closing_balance - first_closing_balance) AS FLOAT) / CAST(ABS(first_closing_balance) AS FLOAT) * 100 > 5 THEN 1
			ELSE 0
		END AS tickpoint
	FROM customer_monthly_balance_with_previous_tb
	WHERE first_closing_balance IS NOT NULL
)
SELECT
	ROUND(
		CAST(SUM(tickpoint) AS FLOAT)
		/ CAST(COUNT(customer_id) AS FLOAT) * 100,
		2) AS percentage_total_customers
FROM customer_closing_balance_growth_flag_tb