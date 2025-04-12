USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 2: What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value?
SELECT
	DATETRUNC(month, t1.start_date) AS start_date_of_month,
	COUNT(t1.customer_id) AS total_customers
FROM subscriptions AS t1
INNER JOIN plans AS t2
	ON t1.plan_id = t2.plan_id
WHERE t2.plan_name = 'trial'
GROUP BY DATETRUNC(month, t1.start_date)
ORDER BY start_date_of_month ASC;