USE DataBankDBUI;
GO
-- D. Extra Challenge
-- Question: Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.
-- If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?
-- Special notes: Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!

-- Calculation 1: Simple Interest
-- Method 1: Transaction Interval-Based Allocation Method
DECLARE @YearSimpleInterest AS FLOAT;
DECLARE @DateSimpleInterest AS FLOAT;
DECLARE @LastDate AS DATE;

SET @YearSimpleInterest = 0.06;
SET @DateSimpleInterest = @YearSimpleInterest/365;
SET @LastDate = (SELECT EOMONTH(MAX(txn_date), 0) FROM customer_transactions);

WITH customer_txn_with_next_date_in_month_and_balance_tb AS (
	SELECT
		customer_id,
		txn_date,
		LEAD(txn_date, 1)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
			) AS next_txn_date,
		SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE txn_amount * (-1) END)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS closing_balance
	FROM customer_transactions
),
customer_txn_next_date_capped_tb AS (
		SELECT
		customer_id,
		txn_date,
		CASE
			WHEN COALESCE(next_txn_date, @LastDate) > EOMONTH(txn_date, 0) AND FORMAT(txn_date, 'yyyy-MM') NOT LIKE FORMAT(COALESCE(next_txn_date, @LastDate), 'yyyy-MM') THEN EOMONTH(txn_date, 0)
			WHEN COALESCE(next_txn_date, @LastDate) = @LastDate AND FORMAT(txn_date, 'yyyy-MM') LIKE FORMAT(@LastDate, 'yyyy-MM') THEN @LastDate
			ELSE DATEADD(day, -1, COALESCE(next_txn_date, @LastDate))
		END AS next_date_in_month,
		COALESCE(next_txn_date, @LastDate) AS next_txn_date,
		closing_balance
	FROM customer_txn_with_next_date_in_month_and_balance_tb
),
recursive_customer_segment_date_in_month_and_balance_tb AS (
	-- Anchor Member
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		next_txn_date,
		closing_balance
	FROM customer_txn_next_date_capped_tb

	UNION ALL
	-- Recursive Member
	SELECT
		customer_id,
		DATEADD(month, 1, DATETRUNC(month, txn_date)) AS txn_date,
		CASE
			WHEN EOMONTH(DATEADD(month, 1, txn_date), 0) < next_txn_date AND FORMAT(DATEADD(month, 1, txn_date), 'yyyy-MM') NOT LIKE FORMAT(next_txn_date, 'yyyy-MM') THEN EOMONTH(DATEADD(month, 1, txn_date), 0)
			WHEN (EOMONTH(DATEADD(month, 1, txn_date), 0) >= next_txn_date OR FORMAT(DATEADD(month, 1, txn_date), 'yyyy-MM') LIKE FORMAT(next_txn_date, 'yyyy-MM')) AND next_txn_date = @LastDate THEN next_txn_date
			ELSE DATEADD(day, -1, next_txn_date)
		END AS next_date_in_month,
		next_txn_date,
		closing_balance
	FROM recursive_customer_segment_date_in_month_and_balance_tb
	WHERE DATEADD(day, 1, next_date_in_month) < next_txn_date
),
customer_txn_data_transition_tb AS (
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		DATEDIFF(day, txn_date, next_date_in_month) + 1 AS date_diff,
		closing_balance,
		CASE WHEN closing_balance < 0 THEN 0 ELSE closing_balance END AS data_transition
	FROM recursive_customer_segment_date_in_month_and_balance_tb
),
customer_monthly_data_allocation_tb AS (
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		closing_balance,
		data_transition,
		data_transition * date_diff * (1 + @DateSimpleInterest) AS data_allocation
	FROM customer_txn_data_transition_tb
)
SELECT
	FORMAT(txn_date, 'yyyy-MM') AS activity_month,
	ROUND(SUM(data_allocation), 0) AS total_data
FROM customer_monthly_data_allocation_tb
GROUP BY FORMAT(txn_date, 'yyyy-MM')
ORDER BY activity_month ASC;