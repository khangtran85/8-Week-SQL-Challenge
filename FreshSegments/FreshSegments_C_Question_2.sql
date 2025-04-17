USE FreshSegmentsDBUI;
GO
-- C. Segment Analysis
-- Question 2: Which 5 interests had the lowest average ranking value?
WITH interest_avg_ranking_tb AS (
	SELECT
		interest_id,
		AVG(CAST(ranking AS FLOAT)) AS avg_ranking,
		RANK() OVER(ORDER BY AVG(CAST(ranking AS FLOAT)) ASC) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND interest_id IN (SELECT interest_id FROM monthly_counts_by_interest_id_tb WHERE total_months_each_interest_id >= 6)
	GROUP BY interest_id
)
SELECT
	t1.interest_id,
	t2.interest_name,
	ROUND(t1.avg_ranking, 2) AS avg_ranking
FROM interest_avg_ranking_tb AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE ranking <= 5
ORDER BY avg_ranking ASC;