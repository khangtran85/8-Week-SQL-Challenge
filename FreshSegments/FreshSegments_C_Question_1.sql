USE FreshSegmentsDBUI;
GO
-- C. Segment Analysis
-- Question 1: Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year.
WITH interest_max_composition_ranking_tb AS (
	SELECT
		interest_id,
		month_year,
		composition,
		DENSE_RANK() OVER(ORDER BY composition DESC) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND interest_id IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= 6)
),
interest_min_composition_ranking_tb AS (
	SELECT
		interest_id,
		month_year,
		composition,
		DENSE_RANK() OVER(ORDER BY composition ASC) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND interest_id IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= 6)
)
SELECT
	CONCAT('Top ', FORMAT(t1.ranking, '00')) AS ranking_label,
	t1.interest_id,
	t2.interest_name,
	t1.month_year,
	t1.composition
FROM interest_max_composition_ranking_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.ranking <= 10

UNION ALL

SELECT
	CONCAT('Bottom ', FORMAT(t1.ranking, '00')) AS ranking_label,
	t1.interest_id,
	t2.interest_name,
	t1.month_year,
	t1.composition
FROM interest_min_composition_ranking_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.ranking <= 10
ORDER BY ranking_label ASC;