USE DataBankDBUI;
GO
-- C. Data Allocation Challenge
-- Question: To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:
--	Option 1: data is allocated based off the amount of money at the end of the previous month
--	Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
--	Option 3: data is updated real-time
-- For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
--	running customer balance column that includes the impact each transaction
--	customer balance at the end of each month
--	minimum, average and maximum values of the running balance for each customer
-- Using all of the data available - how much data would have been required for each option on a monthly basis?

-- Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
WITH customer_activity_total_affect_tb AS (
	SELECT
		customer_id,
		activity_date,
		SUM(balance_affect) AS total_affect
	FROM customer_daily_balance_summary_vw
	WHERE activity_type <> 'monthly_closing'
	GROUP BY customer_id, activity_date
),
customer_running_balance_tb AS (
	SELECT
		customer_id,
		activity_date,
		SUM(total_affect)
			OVER(
				PARTITION BY customer_id
				ORDER BY activity_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS closing_balance
	FROM customer_activity_total_affect_tb
),
customer_daily_balance_with_data_transition_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		CASE WHEN closing_balance < 0 THEN 0 ELSE closing_balance END AS data_transition
	FROM customer_running_balance_tb
),
monthly_data_allocation_summary_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		data_transition,
		AVG(data_transition)
			OVER(
				PARTITION BY customer_id
				ORDER BY activity_date ASC
				ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
			) AS avg_30days_closing_balance
	FROM customer_daily_balance_with_data_transition_tb
)
SELECT
	FORMAT(activity_date, 'yyyy-MM') AS activity_month,
	SUM(avg_30days_closing_balance) AS total_data
FROM monthly_data_allocation_summary_tb
GROUP BY FORMAT(activity_date, 'yyyy-MM')
ORDER BY activity_month ASC
OPTION (MAXRECURSION 200);