USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 2: What range of week numbers are missing from the dataset?
WITH recursive_week_number_tb AS (
	-- Anchor Member
	SELECT 1 AS week_number

	-- Recursive Member
	UNION ALL
	SELECT week_number + 1 AS week_number
	FROM recursive_week_number_tb
	WHERE week_number + 1 <= (366 - 1) / 7 + 1
),
missing_weeks_number_with_neighbors_tb AS (
	SELECT
		week_number AS missing_week_number,
		LAG(week_number, 1) OVER(ORDER BY week_number ASC) AS pre_mising_week_number,
		LEAD(week_number, 1) OVER(ORDER BY week_number ASC) AS next_mising_week_number
	FROM recursive_week_number_tb
	WHERE week_number NOT IN (SELECT DISTINCT week_number FROM clean_weekly_sales)
),
missing_week_number_ranges_tb AS (
	SELECT
		missing_week_number,
		CASE
			WHEN pre_mising_week_number IS NULL OR pre_mising_week_number + 1 != missing_week_number THEN 'start_range'
			WHEN next_mising_week_number IS NULL OR missing_week_number + 1 != next_mising_week_number THEN 'end_range'
			ELSE 'mid_range'
		END AS missing_range_position
	FROM missing_weeks_number_with_neighbors_tb
),
missing_week_number_range_groups_tb AS (
	SELECT
		missing_week_number,
		missing_range_position,
		NTILE((SELECT COUNT(*) FROM missing_week_number_ranges_tb WHERE missing_range_position <> 'mid_range') / 2) OVER(ORDER BY missing_week_number ASC) AS range_id
	FROM missing_week_number_ranges_tb
	WHERE missing_range_position <> 'mid_range'
)
SELECT CONCAT(t1.missing_week_number, ' - ', t2.missing_week_number) AS missing_week_number_range
FROM missing_week_number_range_groups_tb AS t1
INNER JOIN missing_week_number_range_groups_tb AS t2
	ON t1.range_id = t2.range_id
	AND (t1.missing_range_position = 'start_range' AND t2.missing_range_position = 'end_range')
ORDER BY t1.range_id ASC;