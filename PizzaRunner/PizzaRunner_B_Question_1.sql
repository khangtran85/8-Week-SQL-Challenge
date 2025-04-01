USE PizzaRunnerDBUI;
GO
-- B. Runner and Customer Experience
-- Question 1: How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
WITH total_runners_for_each_week AS (
SELECT
		DATE_BUCKET(day, 7, registration_date, CASt('2021-01-01' AS DATE)) AS start_date_week,
		COUNT(runner_id) AS total_runners
	FROM runners
	GROUP BY DATE_BUCKET(day, 7, registration_date, CASt('2021-01-01' AS DATE))
)
SELECT
	start_date_week,
	DATEADD(day, 6, start_date_week) AS end_date_week,
	total_runners
FROM total_runners_for_each_week
ORDER BY start_date_week ASC;