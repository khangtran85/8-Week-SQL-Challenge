USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 2: What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
SELECT
	month_year,
	COUNT(CASE WHEN month_year IS NOT NULL THEN 1	ELSE 1 END) AS count_of_records
FROM interest_metrics
GROUP BY month_year
ORDER BY month_year ASC;