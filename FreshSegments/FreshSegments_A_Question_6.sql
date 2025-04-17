USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 6: What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.
--	FreshSegments.interest_map JOIN TO FreshSegments.interest_metrics with LEFT JOIN.
SELECT
	t1.*,
	t2._month,
	t2._year,
	t2.month_year,
	t2.composition,
	t2.index_value,
	t2.ranking,
	t2.percentile_ranking
FROM interest_map AS t1
LEFT JOIN interest_metrics AS t2
	ON t1.id = t2.interest_id;

--	FreshSegments.interest_metrics JOIN TO FreshSegments.interest_map with INNER JOIN.
SELECT
	t1.*,
	t2.interest_name,
	t2.interest_summary,
	t2.created_at,
	t2.last_modified
FROM interest_metrics AS t1
INNER JOIN interest_map AS t2
	ON t1.interest_id = t2.id
WHERE t1.interest_id IS NOT NULL;

--	Since the interest_map table is a DIM table, it does not have unique interest_id values, while the interest_metrics table is a FACT table that may contain multiple rows for the same interest_id and does not necessarily include all interest_ids.
--	Therefore, when performing a JOIN from interest_map to interest_metrics, a LEFT JOIN should be used to display all interest_ids from the DIM table, including those not present in the FACT table. Conversely, when joining from interest_metrics to interest_map, an INNER JOIN should be used.