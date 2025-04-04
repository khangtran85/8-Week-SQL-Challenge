USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 8: How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions AS t1
INNER JOIN plans AS t2
	ON t1.plan_id = t2.plan_id
WHERE YEAR(start_date) = 2020 AND t2.plan_name = 'pro annual';