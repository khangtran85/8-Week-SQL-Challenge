USE FreshSegmentsDBUI;
GO
-- D. Index Analysis
-- The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
-- Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.
-- Question 3: What is the average of the average composition for the top 10 interests for each month?
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
	month_year,
	ROUND(AVG(avg_composition), 2) AS avg_top_10_avg_composition
FROM interest_avg_composition_monthly_ranking_tb
WHERE ranking <= 10
GROUP BY month_year
ORDER BY month_year ASC;