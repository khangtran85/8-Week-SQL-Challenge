USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 3: What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.
SELECT
	t2.plan_name,
	COUNT(t1.plan_id) AS count_of_events
FROM subscriptions AS t1
INNER JOIN plans AS t2
	ON t1.plan_id = t2.plan_id
WHERE YEAR(t1.start_date) > 2020
GROUP BY t2.plan_name
ORDER BY count_of_events DESC;