USE FreshSegmentsDBUI;
GO
-- C. Segment Analysis
-- Question 4: For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding month_year value?
WITH interest_percentile_volatility_tb AS (
	SELECT
		interest_id,
		STDEVP(percentile_ranking) AS stdevp_percentile_ranking,
		RANK() OVER(ORDER BY STDEVP(percentile_ranking) DESC) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND interest_id IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= 6)
	GROUP BY interest_id
),
interest_max_percentile_rankings_tb AS (
	SELECT
		month_year,
		interest_id,
		percentile_ranking,
		RANK()
			OVER(
				PARTITION BY interest_id
				ORDER BY percentile_ranking DESC
			) AS ranking
	FROM interest_metrics
	WHERE
			interest_id IS NOT NULL AND month_year IS NOT NULL
			AND interest_id IN (SELECT interest_id FROM interest_percentile_volatility_tb WHERE ranking <= 5)
),
interest_min_percentile_rankings_tb AS (
	SELECT
		month_year,
		interest_id,
		percentile_ranking,
		RANK()
			OVER(
				PARTITION BY interest_id
				ORDER BY percentile_ranking ASC
			) AS ranking
	FROM interest_metrics
	WHERE
			interest_id IS NOT NULL AND month_year IS NOT NULL
			AND interest_id IN (SELECT interest_id FROM interest_percentile_volatility_tb WHERE ranking <= 5)
)
SELECT
	'Minimum' AS ranking_extreme,
	interest_id,
	month_year,
	percentile_ranking AS percentile_ranking
FROM interest_min_percentile_rankings_tb
WHERE ranking = 1

UNION ALL

SELECT
	'Maximum' AS ranking_extreme,
	interest_id,
	month_year,
	percentile_ranking AS percentile_ranking
FROM interest_max_percentile_rankings_tb
WHERE ranking = 1
ORDER BY interest_id ASC, ranking_extreme DESC;