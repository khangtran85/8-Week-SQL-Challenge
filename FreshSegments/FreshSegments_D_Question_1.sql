USE FreshSegmentsDBUI;
GO
-- D. Index Analysis
-- The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
-- Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.
-- Question 1: What is the top 10 interests by the average composition for each month?
WITH interest_avg_composition_monthly_ranking_tb AS (
	SELECT
		month_year,
		interest_id,
		composition / index_value AS avg_composition,
		DENSE_RANK()
			OVER(
				PARTITION BY month_year
				ORDER BY (composition / index_value) DESC
			) AS ranking
	FROM interest_metrics
	WHERE interest_id IS NOT NULL AND month_year IS NOT NULL
)
SELECT
	ranking AS top_avg_composition,
	t1.month_year,
	t1.interest_id,
	t2.interest_name,
	ROUND(avg_composition, 2) AS avg_composition
FROM interest_avg_composition_monthly_ranking_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.ranking <= 10
ORDER BY month_year ASC, top_avg_composition ASC;