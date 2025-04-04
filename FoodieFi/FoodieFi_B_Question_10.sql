USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 10: Can you further breakdown the customer count into 30 day periods from Question 9 (i.e. 1-30 days, 31-60 days etc).
WITH customer_subscription_order_tb AS (
	SELECT
		t1.customer_id,
		t2.plan_name,
		t1.start_date,
		ROW_NUMBER()
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY t1.start_date ASC
			) AS subscription_order
	FROM subscriptions AS t1
	INNER JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
),
customer_upgrade_timing_pro_annual_tb AS (
	SELECT
		t1.customer_id,
		t1.start_date AS join_date,
		t2.start_date AS upgraded_pro_annual_date,
		DATEDIFF(day, t1.start_date, t2.start_date) AS days_to_upgrade
	FROM customer_subscription_order_tb AS t1
	INNER JOIN customer_subscription_order_tb AS t2
		ON t1.customer_id = t2.customer_id
		AND t1.subscription_order = 1
		AND t2.plan_name = 'pro annual'
),
max_bin_tb AS (
	SELECT CEILING(CAST(MAX(days_to_upgrade) AS FLOAT) / 30) * 30 AS max_bin
	FROM customer_upgrade_timing_pro_annual_tb
),
days_bins_tb AS (
	SELECT 0 AS bin_id, 1 AS Lowbin, 30 AS UpBin
	UNION ALL
	SELECT bin_id + 1, Lowbin + 30, UpBin + 30
	FROM days_bins_tb
	WHERE UpBin + 30 <= (SELECT max_bin FROM max_bin_tb)
),
edited_days_bins_tb AS (
	SELECT
		CASE WHEN Lowbin = 1 THEN 0 ELSE LowBin END AS LowBin,
		UpBin
	FROM days_bins_tb
)
SELECT
	t1.Lowbin,
	t1.UpBin,
	COUNT(t2.days_to_upgrade) AS total_days
FROM edited_days_bins_tb AS t1
LEFT JOIN customer_upgrade_timing_pro_annual_tb AS t2
	ON t1.Lowbin <= t2.days_to_upgrade
	AND t1.UpBin >= t2.days_to_upgrade
GROUP BY t1.Lowbin, t1.UpBin
ORDER BY t1.LowBin ASC;