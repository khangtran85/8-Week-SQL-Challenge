USE FreshSegmentsDBUI;
GO
-- B. Interest Analysis
-- Question 1: Which interests have been present in all month_year dates in our dataset?
WITH valid_month_counts_tb AS (
	SELECT COUNT(DISTINCT month_year) AS total_months
	FROM interest_metrics
	WHERE month_year IS NOT NULL AND interest_id IS NOT NULL
)
SELECT
	t1.interest_id,
	t2.interest_name
FROM monthly_counts_by_interest_id_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.total_months_each_interest_id = (SELECT total_months FROM valid_month_counts_tb)
ORDER BY t2.interest_name ASC;