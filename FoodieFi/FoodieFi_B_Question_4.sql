USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 4: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
WITH customer_summary_tb AS (
	SELECT
		COUNT(DISTINCT t1.customer_id) AS total_customers,
		COUNT(DISTINCT CASE WHEN t2.plan_name = 'churn' THEN t1.customer_id ELSE NULL END) AS total_churn_customer
	FROM subscriptions AS t1
	INNER JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
)
SELECT
	total_churn_customer,
	CAST((
		CAST(total_churn_customer AS FLOAT)
		/ CAST(total_customers AS FLOAT) * 100
	) AS DECIMAL(4, 1)) AS percentage_of_churn_customers
FROM customer_summary_tb;