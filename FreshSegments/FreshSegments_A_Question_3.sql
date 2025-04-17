USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 3: What do you think we should do with these null values in the fresh_segments.interest_metrics?
SELECT
	'Total NULL records in "_month" column' AS metric,
	COUNT(*) AS total_records
FROM interest_metrics
WHERE _month IS NULL

UNION ALL

SELECT
	'Total NULL records in "_year" column' AS metric,
	COUNT(*) AS total_records
FROM interest_metrics
WHERE _year IS NULL

UNION ALL

SELECT
	'Total NULL records in "month_year" column' AS metric,
	COUNT(*) AS total_records
FROM interest_metrics
WHERE month_year IS NULL

UNION ALL

SELECT
	'Total NULL records in "interest_id" column' AS metric,
	COUNT(*) AS total_records
FROM interest_metrics
WHERE interest_id IS NULL

UNION ALL

SELECT
	'Total NULL records in "table" column' AS metric,
	COUNT(*) AS total_records
FROM interest_metrics
WHERE _month IS NULL OR _year IS NULL OR month_year IS NULL OR interest_id IS NULL;