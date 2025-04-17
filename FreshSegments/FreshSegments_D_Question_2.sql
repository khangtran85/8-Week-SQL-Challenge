USE FreshSegmentsDBUI;
GO
-- D. Index Analysis
-- The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
-- Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.
-- Question 2: For all of these top 10 interests - which interest appears the most often?
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
),
top10_interest_avg_composition_each_month_tb AS (
	SELECT
		month_year,
		interest_id,
		ranking
	FROM interest_avg_composition_monthly_ranking_tb
	WHERE ranking <= 10
),
top_interest_frequency_ranking_tb AS (
	SELECT
		interest_id,
		COUNT(interest_id) AS total_interest_id,
		RANK() OVER(ORDER BY COUNT(interest_id) DESC) AS ranking
	FROM top10_interest_avg_composition_each_month_tb
	GROUP BY interest_id
)
SELECT
	t1.interest_id,
	t2.interest_name
FROM top_interest_frequency_ranking_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.ranking = 1
ORDER BY interest_name ASC;