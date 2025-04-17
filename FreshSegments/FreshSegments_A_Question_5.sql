USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 5: Summarise the id values in the fresh_segments.interest_map by its total record count in this table.
SELECT
	t1.total_records AS number_of_record,
	COUNT(id) AS total_id
FROM (
	SELECT
		id,
		COUNT(id) AS total_records
	FROM interest_map
	GROUP BY id
) AS t1
GROUP BY t1.total_records;