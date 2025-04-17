USE FreshSegmentsDBUI;
GO
-- D. Index Analysis
-- The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
-- Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.
-- Question 4: What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
WITH interest_avg_composition_ranking_each_month_tb AS (
	SELECT
		 month_year,
		 interest_id,
		 composition / index_value AS avg_composition,
		 RANK()
			OVER(
				PARTITION BY month_year
				ORDER BY (composition / index_value) DESC
			) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND month_year BETWEEN DATEADD(month, -2, '2018-09-01') AND '2019-08-01'
),
monthly_top_interest_avg_tb AS (
	SELECT
		t1.month_year,
		t1.interest_id,
		t2.interest_name,
		t1.avg_composition AS max_index_composition,
		CONCAT(t2.interest_name, ': ', ROUND(t1.avg_composition, 2)) AS concat_interest_name_vs_avg_composition,
		AVG(t1.avg_composition)
			OVER(
				ORDER BY t1.month_year ASC
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			) AS _3_month_moving_avg
	FROM interest_avg_composition_ranking_each_month_tb AS t1
	INNER JOIN interest_map AS t2
		ON t1.interest_id = t2.id
	WHERE t1.ranking = 1
)
SELECT
	t1.month_year,
	t1.interest_name,
	ROUND(t1.max_index_composition, 2) AS max_index_composition,
	ROUND(t1._3_month_moving_avg, 2) AS _3_month_moving_avg,
	t2.concat_interest_name_vs_avg_composition AS _1_month_ago,
	t3.concat_interest_name_vs_avg_composition AS _2_month_ago
FROM monthly_top_interest_avg_tb AS t1
INNER JOIN monthly_top_interest_avg_tb AS t2
	ON t1.month_year = DATEADD(month, 1, t2.month_year)
INNER JOIN monthly_top_interest_avg_tb AS t3
	ON t1.month_year = DATEADD(month, 2, t3.month_year)
ORDER BY month_year ASC;