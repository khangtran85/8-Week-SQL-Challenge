USE FoodieFiDBUI;
GO

DECLARE @TimeSignature AS DATE;
SET @TimeSignature = '2020-12-31';

-- B. Data Analysis Questions
-- Question 7: What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH customer_subscription_last_register_date AS (
	SELECT
		customer_id,
		plan_id,
		start_date,
		LAST_VALUE(start_date)
			OVER(
				PARTITION BY customer_id
				ORDER BY start_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
			) AS last_register_date
	FROM subscriptions
	WHERE start_date <= @TimeSignature
),
plan_customer_count_at_last_registration AS (
	SELECT
		t1.plan_name,
		COUNT(DISTINCT t2.customer_id) AS total_customers
	FROM plans AS t1
	LEFT JOIN customer_subscription_last_register_date AS t2
		ON t1.plan_id = t2.plan_id
	WHERE t2.start_date = t2.last_register_date
	GROUP BY t1.plan_name
)
SELECT
	plan_name,
	total_customers,
	CAST((
		CAST(total_customers AS FLOAT)
		/ CAST((SUM(total_customers) OVER()) AS FLOAT) * 100
	) AS DECIMAL(5, 2)) AS percentage_customers
FROM plan_customer_count_at_last_registration
ORDER BY total_customers DESC;