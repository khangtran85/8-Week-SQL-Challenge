USE DataBankDBUI;
GO

DROP VIEW IF EXISTS customer_monthly_balance_summary_vw;
GO

CREATE VIEW customer_monthly_balance_summary_vw AS
	WITH customer_monthly_balance_summary_tb AS (
		SELECT
			customer_id,
			EOMONTH(txn_date, 0) AS closing_date,
			SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END) AS total_cash_in,
			SUM(CASE WHEN txn_type IN ('purchase', 'withdrawal') THEN txn_amount ELSE 0 END) AS total_cash_out
		FROM customer_transactions
		GROUP BY customer_id, EOMONTH(txn_date, 0)
	),
	eomonth_tb AS (
		SELECT DISTINCT EOMONTH(txn_date, 0) AS closing_date
		FROM customer_transactions
	),
	distinct_customer_id_tb AS (
		SELECT DISTINCT customer_id
		FROM customer_nodes
	),
	customer_eomonth_combinations_tb AS (
		SELECT
			t2.customer_id,
			t1.closing_date
		FROM eomonth_tb AS t1
		CROSS JOIN distinct_customer_id_tb AS t2
	),
	first_txn_month_customer_tb AS (
		SELECT DISTINCT
			customer_id,
			FIRST_VALUE(EOMONTH(txn_date, 0))
				OVER(
					PARTITION BY customer_id
					ORDER BY txn_date ASC
				) AS first_txn_month
		FROM customer_transactions
	)
	SELECT
		t1.customer_id,
		t1.closing_date,
		COALESCE(t2.total_cash_in, 0) AS total_cash_inflow,
		COALESCE(t2.total_cash_out, 0) AS total_cash_outflow,
		COALESCE(t2.total_cash_in, 0) - COALESCE(t2.total_cash_out, 0) AS net_total_cash_flow,
		SUM(COALESCE(t2.total_cash_in, 0) - COALESCE(t2.total_cash_out, 0))
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY t1.closing_date
			) AS closing_balance
	FROM customer_eomonth_combinations_tb AS t1
	LEFT JOIN customer_monthly_balance_summary_tb AS t2
		ON t1.customer_id = t2.customer_id
		AND t1.closing_date = t2.closing_date
	INNER JOIN first_txn_month_customer_tb AS t3
		ON t1.customer_id = t3.customer_id
	WHERE t1.closing_date >= t3.first_txn_month;

GO

DROP VIEW IF EXISTS customer_daily_balance_summary_vw;
GO

CREATE VIEW customer_daily_balance_summary_vw AS 
	WITH customer_running_balance_tb AS (
	SELECT
		customer_id,
		txn_date,
		txn_type,
		txn_amount,
		CASE
			WHEN txn_type = 'deposit' THEN txn_amount
			ELSE txn_amount * (-1)
		END AS balance_affect,
		SUM(
			CASE
				WHEN txn_type = 'deposit' THEN txn_amount
				ELSE txn_amount * (-1)
			END
		)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS closing_balance,
		LEAD(txn_date, 1)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
			) AS next_txn_date
	FROM customer_transactions
	),
	eomonth_last_txn_date_tb AS (
		SELECT MAX(txn_date) AS max_date
		FROM customer_transactions
	),
	recursive_customer_running_balance_tb AS (
		-- Anchor Member
		SELECT
			customer_id,
			txn_date,
			txn_type,
			txn_amount,
			balance_affect,
			closing_balance,
			next_txn_date,
			1 AS nper
		FROM customer_running_balance_tb

		UNION ALL
		-- Recursive Member
		SELECT
			customer_id,
			DATEADD(day, 1, txn_date) AS txn_date,
			CAST('none' AS VARCHAR(10)) AS txn_type,
			0 AS txn_amount,
			0 AS balance_affect,
			closing_balance,
			next_txn_date,
			nper + 1 AS nper
		FROM recursive_customer_running_balance_tb
		WHERE
			(next_txn_date IS NOT NULL AND DATEADD(day, 1, txn_date) < next_txn_date)
			OR (next_txn_date IS NULL AND DATEADD(day, 1, txn_date) <= EOMONTH((SELECT max_date FROM eomonth_last_txn_date_tb), 0))
	),
	customer_combined_activity_tb AS (
		SELECT
			customer_id,
			txn_date AS activity_date,
			nper,
			txn_type AS activity_type,
			txn_amount,
			balance_affect,
			closing_balance
		FROM recursive_customer_running_balance_tb

		UNION ALL

		SELECT
			customer_id,
			closing_date AS activity_date,
			'none' AS nper,
			'monthly_closing' AS activity_type,
			0 AS txn_amount,
			net_total_cash_flow AS balance_affect,
			closing_balance
		FROM customer_monthly_balance_summary_vw
	),
	customer_monthly_running_balance_stats_tb AS (
		SELECT
			customer_id,
			EOMONTH(activity_date, 0) AS activity_date,
			nper,
			MIN(closing_balance) AS min_running_balance,
			AVG(closing_balance) AS avg_running_balance,
			MAX(closing_balance) AS max_running_balance
		FROM customer_combined_activity_tb
		WHERE activity_type NOT IN ('monthly_closing', 'none')
		GROUP BY customer_id, EOMONTH(activity_date, 0), nper
	)
	SELECT
		t1.*,
		CASE
			WHEN t2.min_running_balance IS NOT NULL THEN t2.min_running_balance
			WHEN t2.min_running_balance IS NULL AND t1.activity_type = 'monthly_closing' THEN t1.closing_balance
			ELSE NULL
		END AS min_running_balance,
		CASE
			WHEN t2.avg_running_balance IS NOT NULL THEN t2.avg_running_balance
			WHEN t2.avg_running_balance IS NULL AND t1.activity_type = 'monthly_closing' THEN t1.closing_balance
			ELSE NULL
		END AS avg_running_balance,
		CASE
			WHEN t2.max_running_balance IS NOT NULL THEN t2.max_running_balance
			WHEN t2.max_running_balance IS NULL AND t1.activity_type = 'monthly_closing' THEN t1.closing_balance
			ELSE NULL
		END AS max_running_balance
	FROM customer_combined_activity_tb AS t1
	LEFT JOIN customer_monthly_running_balance_stats_tb AS t2
		ON t1.customer_id = t2.customer_id
		AND t1.activity_date = t2.activity_date
		AND t1.activity_type <> 'none';