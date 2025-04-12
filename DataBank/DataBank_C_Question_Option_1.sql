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

-- Option 1: data is allocated based off the amount of money at the end of the previous month
WITH customer_monthly_balance_with_previous_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		LAG(closing_balance, 1)
			OVER(
				PARTITION BY customer_id
				ORDER BY activity_date ASC
			) AS pre_closing_balance
	FROM customer_daily_balance_summary_vw
	WHERE activity_type = 'monthly_closing'
),
customer_monthly_balance_with_data_allocation_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		CASE
			WHEN pre_closing_balance IS NULL OR pre_closing_balance < 0 THEN 0
			ELSE pre_closing_balance
		END AS data_allocation
	FROM customer_monthly_balance_with_previous_tb
),
monthly_data_allocation_summary_tb AS (
	SELECT
		DATETRUNC(month, activity_date) AS activity_month,
		SUM(data_allocation) AS total_data_in_day
	FROM customer_monthly_balance_with_data_allocation_tb
	GROUP BY DATETRUNC(month, activity_date)
)
SELECT
	FORMAT(activity_month, 'yyyy-MM') AS activity_month,
	(total_data_in_day * (DATEDIFF(day, activity_month, EOMONTH(activity_month, 0)) + 1)) AS total_data
FROM monthly_data_allocation_summary_tb
ORDER BY activity_month ASC
OPTION (MAXRECURSION 200);