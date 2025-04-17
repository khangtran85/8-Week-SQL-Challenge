USE FreshSegmentsDBUI;
GO
-- B. Interest Analysis
-- Question 5: After removing these interests - how many unique interests are there for each month?
DECLARE @TotalMonths AS INT;
SET @TotalMonths = 10;

SELECT
	month_year,
	COUNT(DISTINCT interest_id) AS total_unique_interest_id
FROM interest_metrics
WHERE
	interest_id IS NOT NULL AND month_year IS NOT NULL
	AND interest_id IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= @TotalMonths)
GROUP BY month_year
ORDER BY month_year ASC;