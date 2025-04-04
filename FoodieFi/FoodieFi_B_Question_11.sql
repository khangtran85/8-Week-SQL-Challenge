USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 11: How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH customer_plan_subscriptions_tb AS (
	SELECT
		t1.customer_id,
		t2.plan_name,
		t1.start_date
	FROM subscriptions AS t1
	INNER JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
	WHERE YEAR(t1.start_date) = 2020
)
SELECT COUNT(DISTINCT t1.customer_id) AS total_customers
FROM customer_plan_subscriptions_tb AS t1
INNER JOIN customer_plan_subscriptions_tb AS t2
	ON t1.customer_id = t2.customer_id
	AND (t1.plan_name = 'pro monthly' AND t2.plan_name = 'basic monthly')
	AND t1.start_date <= t2.start_date;