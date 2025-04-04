USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 5: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH customer_plan_subscriptions_tb AS (
	SELECT
		t1.customer_id,
		t2.plan_name,
		t1.start_date
	FROM subscriptions AS t1
	INNER JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
),
customers_within_7days_trial_to_churn_tb AS (
	SELECT COUNT(DISTINCT t1.customer_id) AS total_customers_churned_after_7days
	FROM customer_plan_subscriptions_tb AS t1
	INNER JOIN customer_plan_subscriptions_tb AS t2
		ON t1.customer_id = t2.customer_id
		AND (t1.plan_name = 'trial' AND t2.plan_name = 'churn')
		AND DATEDIFF(day, t1.start_date, t2.start_date) <= 7
)
SELECT
	total_customers_churned_after_7days,
	ROUND(
		CAST(total_customers_churned_after_7days AS FLOAT)
		/ CAST((SELECT COUNT(DISTINCT customer_id) FROM subscriptions) AS FLOAT) * 100,
	0) AS percentage_customers_churned_after_7days
FROM customers_within_7days_trial_to_churn_tb;