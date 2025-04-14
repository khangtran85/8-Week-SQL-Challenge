USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 3: What is the unique number of visits by all users per month?
SELECT
	CAST(DATETRUNC(month, event_time) AS DATE) AS month,
	COUNT(DISTINCT visit_id) AS total_visits
FROM events
GROUP BY CAST(DATETRUNC(month, event_time) AS DATE)
ORDER BY month ASC;