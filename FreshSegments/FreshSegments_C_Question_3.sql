USE FreshSegmentsDBUI;
GO
-- C. Segment Analysis
-- Question 3: Which 5 interests had the largest standard deviation in their percentile_ranking value?
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
)
SELECT
	t1.interest_id,
	t2.interest_name,
	ROUND(t1.stdevp_percentile_ranking, 2) AS stdevp_percentile_ranking
FROM interest_percentile_volatility_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.ranking <= 5
ORDER BY stdevp_percentile_ranking DESC;