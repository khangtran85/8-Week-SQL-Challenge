USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 4: How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?

-- How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table?
SELECT COUNT(interest_id) AS total_interest_id
FROM interest_metrics
WHERE
	interest_id NOT IN (
		SELECT id
		FROM interest_map
	)
	AND interest_id IS NOT NULL;

-- What about the other way around?
--	Method 1:
SELECT COUNT(id) AS total_interest_id
FROM interest_map
WHERE
	id NOT IN (
		SELECT DISTINCT interest_id
		FROM interest_metrics
		WHERE interest_id IS NOT NULL
	);

--	Method 2:
SELECT COUNT(id) AS total_interest_id
FROM interest_map AS t1
WHERE
	NOT EXISTS (
		SELECT 1 
		FROM interest_metrics AS t2 
		WHERE t2.interest_id = t1.id
	);