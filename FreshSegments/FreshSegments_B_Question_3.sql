USE FreshSegmentsDBUI;
GO
-- B. Interest Analysis
-- Question 3: If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?
DECLARE @TotalMonths AS INT;
SET @TotalMonths = 10;

SELECT COUNT(*) AS total_data_points_to_removing
FROM interest_metrics
WHERE
	interest_id IS NOT NULL AND month_year IS NOT NULL
	AND interest_id NOT IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= @TotalMonths)