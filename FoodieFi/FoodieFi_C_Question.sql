USE FoodieFiDBUI;
GO
-- C. Challenge Payment Question
-- Question: The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:
--	monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
--	upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
--	upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
--	once a customer churns they will no longer make payments
DROP TABLE IF EXISTS payments;
WITH subscription_orders_tb AS (
	SELECT 
		t1.customer_id,
		t1.plan_id,
		t2.plan_name,
		t2.price,
		t1.start_date AS payment_date,
		LAG(t2.plan_name, 1) OVER (PARTITION BY t1.customer_id ORDER BY t1.start_date) AS previous_plan,
		LAG(t1.start_date, 1) OVER (PARTITION BY t1.customer_id ORDER BY t1.start_date) AS previous_payment_date,
		LEAD(t2.plan_name, 1) OVER (PARTITION BY t1.customer_id ORDER BY t1.start_date) AS next_plan,
		LEAD(t1.start_date, 1) OVER (PARTITION BY t1.customer_id ORDER BY t1.start_date) AS next_payment_date
	FROM subscriptions AS t1
	JOIN plans AS t2
		ON t1.plan_id = t2.plan_id
	WHERE t1.start_date < '2021-01-01' AND t2.plan_name <> 'trial'
),
recursive_payments_tb AS (
	SELECT
		customer_id,
		plan_id,
		plan_name,
		price,
		CASE
			WHEN plan_name = 'pro annual' AND previous_plan = 'pro monthly' AND payment_date < DATEADD(month, MONTH(payment_date) - MONTH(previous_payment_date) + 1, previous_payment_date) THEN DATEADD(month, MONTH(payment_date) - MONTH(previous_payment_date), previous_payment_date)
			ELSE payment_date
		END AS payment_date,
		previous_plan,
		previous_payment_date,
		next_plan,
		next_payment_date,
		CASE
			WHEN plan_name = 'pro annual' AND previous_plan = 'pro monthly' AND payment_date < DATEADD(month, MONTH(payment_date) - MONTH(previous_payment_date) + 1, previous_payment_date) THEN 1
			ELSE 0
		END AS reduce_pro_amount_tick
	FROM subscription_orders_tb
	WHERE plan_name NOT LIKE 'churn'
	
	UNION ALL

	SELECT
		customer_id,
		plan_id,
		plan_name,
		price,
		CASE
			WHEN next_payment_date IS NULL AND next_plan IS NULL AND plan_name IN ('basic monthly', 'pro monthly') THEN DATEADD(month, 1, payment_date)
			WHEN next_payment_date IS NULL AND next_plan IS NULL AND plan_name = 'pro annual' THEN DATEADD(year, 1, payment_date)
			WHEN next_payment_date IS NOT NULL AND next_plan IS NOT NULL AND plan_name = 'basic monthly' AND next_plan IN ('pro monthly', 'pro annual') AND DATEADD(month, 1, payment_date) < next_payment_date THEN DATEADD(month, 1, payment_date)
			WHEN next_payment_date IS NOT NULL AND next_plan IS NOT NULL AND plan_name = 'pro monthly' AND next_plan = 'pro annual' AND DATEADD(month, 1, payment_date) < next_payment_date THEN DATEADD(month, 1, payment_date)
			ELSE payment_date
		END AS payment_date,
		previous_plan,
		previous_payment_date,
		next_plan,
		next_payment_date,
		reduce_pro_amount_tick * 1
	FROM recursive_payments_tb
	WHERE
		plan_name NOT LIKE 'churn'
		AND payment_date < '2021-01-01'
		AND ((next_payment_date IS NULL AND next_plan iS NULL AND plan_name IN ('basic monthly', 'pro monthly') AND DATEADD(month, 1, payment_date) < '2021-01-01')
			OR (next_payment_date IS NULL AND next_plan iS NULL AND plan_name LIKE 'pro annual' AND DATEADD(year, 1, payment_date) < '2021-01-01')
			OR (next_payment_date IS NOT NULL AND next_plan IS NOT NULL AND plan_name = 'basic monthly' AND next_plan IN ('pro monthly', 'pro annual') AND DATEADD(month, 1, payment_date) < next_payment_date AND DATEADD(month, 1, payment_date) < '2021-01-01')
			OR (next_payment_date IS NOT NULL AND next_plan IS NOT NULL AND plan_name = 'pro monthly' AND next_plan = 'pro annual' AND DATEADD(month, 1, payment_date) < next_payment_date AND DATEADD(month, 1, payment_date) < '2021-01-01'))
),
initial_payment_schedule_tb AS (
	SELECT
		customer_id,
		plan_id,
		plan_name,
		payment_date,
		price,
		LAG(plan_name, 1) OVER(PARTITION BY customer_id ORDER BY payment_date ASC) AS previous_plan,
		LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date ASC) AS previous_payment_date,
		reduce_pro_amount_tick,
		ROW_NUMBER()
			OVER(
				PARTITION BY customer_id
				ORDER BY payment_date ASC
			) AS payment_order
	FROM recursive_payments_tb
)
SELECT
	customer_id,
	plan_id,
	plan_name,
	payment_date,
	CASE
		WHEN plan_name IN ('pro monthly', 'pro annual') AND previous_plan = 'basic monthly' AND payment_date < DATEADD(month, 1, previous_payment_date) THEN CAST((price - 9.90) AS DECIMAL(5, 2))
		WHEN plan_name = 'pro annual' AND previous_plan = 'pro monthly' AND reduce_pro_amount_tick = 1 THEN CAST((price - 19.90) AS DECIMAL(5, 2))
		ELSE price
	END AS amount,
	payment_order
INTO payments
FROM initial_payment_schedule_tb
ORDER BY customer_id ASC, payment_date ASC;

SELECT *
FROM payments;