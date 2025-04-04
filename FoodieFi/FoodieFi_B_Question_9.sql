USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 9: How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
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
)
SELECT ROUND(AVG(CAST(DATEDIFF(day, t1.start_date, t2.start_date) AS FLOAT)), 2) AS avg_days
FROM customer_subscription_order_tb AS t1
INNER JOIN customer_subscription_order_tb AS t2
	ON t1.customer_id = t2.customer_id
	AND t1.subscription_order = 1
	AND t2.plan_name = 'pro annual';