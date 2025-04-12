USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 6: What is the number and percentage of customer plans after their initial free trial?
WITH customer_subscription_order_tb AS (
	SELECT
		t1.customer_id,
		t2.plan_name,
		t1.start_date,
		ROW_NUMBER()
			OVER(
				PARTITION BY t1.customer_id
				ORDER BY t1.start_date ASC
			) AS subscription_order
	FROM subscriptions AS t1
	INNER JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
),
trial_to_other_plan_transition_tb AS (
	SELECT
		t2.plan_name,
		COUNT(DISTINCT t1.customer_id) AS total_customers
	FROM customer_subscription_order_tb AS t1
	INNER JOIN customer_subscription_order_tb AS t2
		ON t1.customer_id = t2.customer_id
		AND (t1.subscription_order = 1 AND t2.subscription_order = 2)
		AND t1.plan_name = 'trial'
		AND DATEDIFF(day, t1.start_date, t2.start_date) <= 7
	GROUP BY t2.plan_name
)
SELECT
	plan_name,
	total_customers,
	CAST((
		CAST(total_customers AS FLOAT)
		/ CAST((SUM(total_customers) OVER()) AS FLOAT) * 100
	) AS DECIMAL(5, 2)) AS percentage_customers
FROM trial_to_other_plan_transition_tb;