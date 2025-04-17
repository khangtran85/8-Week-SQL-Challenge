USE FreshSegmentsDBUI;
GO
-- B. Interest Analysis
-- Question 2: Using this same total_months measure - calculate the cumulative percentage of all records starting at 10 months - which total_months value passes the 90% cumulative percentage value?
DECLARE @TotalMonths AS INT;
SET @TotalMonths = 10;

WITH interest_months_cumulative_summary_tb AS (
	SELECT
		total_months_each_interest_id AS total_months,
		COUNT(interest_id) AS total_interest_id,
		SUM(COUNT(interest_id))
			OVER(
				ORDER BY total_months_each_interest_id ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS total_cummulative_interest_id,
		SUM(COUNT(interest_id)) OVER() AS total_interest_id_all
	FROM monthly_counts_by_interest_id_tb
	WHERE total_months_each_interest_id >= @TotalMonths
	GROUP BY total_months_each_interest_id
),
interest_months_cumulative_percentage_tb AS (
	SELECT
		total_months,
		total_interest_id,
		CAST(total_cummulative_interest_id AS FLOAT) / CAST(total_interest_id_all AS FLOAT) * 100 AS cummulative_percentage
	FROM interest_months_cumulative_summary_tb
)
SELECT *
FROM interest_months_cumulative_percentage_tb
WHERE cummulative_percentage >= 90
ORDER BY total_months;