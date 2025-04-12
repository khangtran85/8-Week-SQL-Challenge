USE DataBankDBUI;
GO
-- D. Extra Challenge
-- Question: Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.
-- If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?
-- Special notes: Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!

-- Calculation 1: Simple Interest
-- Method 2: Cumulative Daily Balance Allocation Method
DECLARE @YearSimpleInterest AS FLOAT;
DECLARE @DateSimpleInterest AS FLOAT;

SET @YearSimpleInterest = 0.06;
SET @DateSimpleInterest = @YearSimpleInterest/365;

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
customer_txn_data_transition_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		CASE WHEN closing_balance < 0 THEN 0 ELSE closing_balance END AS data_transition
	FROM customer_running_balance_tb
),
customer_monthly_data_allocation_tb AS (
	SELECT
		customer_id,
		activity_date,
		closing_balance,
		data_transition,
		data_transition * (1 + @DateSimpleInterest) AS data_allocation
	FROM customer_txn_data_transition_tb
)
SELECT
	FORMAT(activity_date, 'yyyy-MM') AS activity_month,
	ROUND(SUM(data_allocation), 0) AS total_data
FROM customer_monthly_data_allocation_tb
GROUP BY FORMAT(activity_date, 'yyyy-MM')
ORDER BY activity_month ASC
OPTION (MAXRECURSION 200);