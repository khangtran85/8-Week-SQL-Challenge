# 8-Week-SQL-Challenge
8 Week SQL Challenge is a series of SQL exercises designed to enhance data querying skills through real-world scenarios. Each challenge covers key SQL concepts like JOINs, CTEs, and Window Functions. Work with datasets on customer behavior, sales, finance, and more. Clone the repo, explore challenges, and level up your SQL skills!

# Processing
## Week 1: Danny's Diner
### Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 5 favourite foods: sushi, curry, ramen, okononiyaki and yakiniku.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.
### Dataset
![Danny's Diner.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/Danny's%20Diner.png)

Use SQL Server to create the dataset using the CREATE TABLE and INSERT INTO statements.

View more in the [DannysDinner/Create_DannysDiner_Dataset.sql](DannysDiner/Create_DannysDiner_Dataset.sql).
### Business Goals
- *Understand visiting patterns*: Danny wants to learn how often each customer visits the restaurant.

- *Analyze spending and preferences*: He is interested in knowing how much money customers spend and which menu items they prefer.

- *Support loyalty strategy*: These insights will help him decide whether to expand the loyalty program and personalize the experience for loyal customers.

### Case Study Questions and SQL Scripts
The case study presents 10 real-world business questions that help address the goals above:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?  
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and each sushi has a 2x points multiplier, how many points would each customer have?
10. In the first week after a customer joins the program (including their join date), they earn 2x points on all items — how many points do customer A and B have?

*Each question is answered in a separate SQL file stored in the [`DannysDiner/`](DannysDiner/) folder.*
### Highlighted Query
```sql
USE DannysDinerDBUI;
GO
-- Rank all the things
DROP TABLE IF EXISTS additional_table_2;
SELECT
	t1.customer_id,
	t1.order_date,
	t2.product_name,
	t2.price,
	CASE
		WHEN t1.order_date >= t3.join_date THEN 'Y'
		ELSE 'N'
	END AS member,
	CASE
		WHEN t1.order_date >= t3.join_date THEN DENSE_RANK() OVER(PARTITION BY t1.customer_id ORDER BY t1.order_date ASC)
		ELSE NULL
	END AS ranking
INTO additional_table_2
FROM sales AS t1
INNER JOIN menu AS t2
	ON t1.product_id = t2.product_id
INNER JOIN members AS t3
	ON t1.customer_id = t3.customer_id;
```
### Key Learnings from Danny’s Diner Case Study
Working through the Danny’s Diner case study provided hands-on experience with essential SQL topics. I gained a clearer and deeper understanding of:

- **Common Table Expressions (CTEs)** for simplifying complex queries and improving readability.
- **GROUP BY aggregates** to summarize customer spending and item popularity.
- **Window functions** to rank items, calculate running totals, and apply logic across rows.
- **Table joins** to combine customer, sales, and membership data effectively.
- **Data definition commands** like `CREATE TABLE`, `INSERT INTO`, and `ALTER TABLE` to structure and manage raw datasets in SQL Server.

These concepts were not only studied in theory but also applied in practical ways, such as:

- Building custom datasets from scratch using `CREATE TABLE` and `INSERT INTO`.
- Updating table schemas with `ALTER TABLE` to reflect evolving data needs.
- Identifying the most frequently ordered items using `GROUP BY` and `COUNT(*)`.
- Calculating each customer’s total spend with aggregation and filtering.
- Using `RANK()` and `DENSE_RANK()` (or `ROW_NUMBER()`) window functions to find first-time purchases.
- Tracking customer behavior before and after joining the loyalty program with smart use of `JOIN` and `CASE WHEN`.

This case study helped bridge the gap between foundational SQL knowledge and real-world data problem solving.
## Week 2: Pizza Runner
### Introduction
Did you know that over 115 million kilograms of pizza are consumed daily worldwide? (Well, according to Wikipedia anyway...)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire. So, he had one more genius idea to combine with it - he was going to Uberize it! And thus, Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house). He also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.
### Dataset
![PizzaRunner/Pizza Runner.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/PizzaRunner/Pizza%20Runner.png)

However, there are some changes.
Use SQL Server to create the dataset using the CREATE TABLE and INSERT INTO statements. Additionally, use the UPDATE... SET... WHERE statement to handle incorrect or NULL data, along with other SQL commands to merge tables, define primary and foreign keys, and ensure data integrity.

View more in the [PizzaRunner/Create_PizzaRunner_Dataset.sql](PizzaRunner/Create_PizzaRunner_Dataset.sql).
### Business Goals
- *Optimize delivery efficiency:* Analyze the performance of runners, delivery times, and cancellation patterns.
- *Understand customer preferences:* Identify the most popular pizzas and ordering patterns.
- *Improve operational processes:* Use data to refine order fulfillment and runner assignment.
### Case Study Questions and SQL Scripts
**A. Pizza Metrics**
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers pizzas were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least one change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

**B. Runner and Customer Experience**
1. How many runners signed up for each one-week period? (Week starts from 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance traveled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery, and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

**C. Ingredient Optimization**
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customer_orders table in one of the following formats:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered, comma-separated ingredient list for each pizza order, adding "2x" in front of any relevant ingredients (e.g., "Meat Lovers: 2xBacon, Beef, ... , Salami").
6. What is the total quantity of each ingredient used in all delivered pizzas, sorted by most frequent first?

**D. Pricing and Ratings**
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 (no charge for changes), how much revenue has Pizza Runner made so far (excluding delivery fees)?
2. What if there was an additional $1 charge for any pizza extras? Example: Add cheese as a $1 extra.
3. Design an additional table for a customer rating system for runners, including a schema and sample data for successful orders (ratings from 1 to 5).
4. Using the newly created ratings table, generate a consolidated report with the following:
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza is $12 and a Vegetarian is $10 (fixed prices, no extra charges), and each runner is paid $0.30 per km traveled, how much profit does Pizza Runner have left after these deliveries?

**E. Bonus Questions:** If Danny wants to expand his range of pizzas, how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all toppings was added to the Pizza Runner menu.

*Each question is answered in a separate SQL file stored in the [`PizzaRunner/`](PizzaRunner/) folder.*
### Highlighted Query
```sql
USE PizzaRunnerDBUI;
IF EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'customer_orders' AND COLUMN_NAME = 'order_details'
)
BEGIN
    ALTER TABLE customer_orders
		DROP COLUMN order_details
END;

ALTER TABLE customer_orders
ADD order_details NVARCHAR(MAX);

GO

WITH order_exclusions_tb AS (
	SELECT
		t1.order_number,
		CONCAT('Exclude ', STRING_AGG(CAST(t3.topping_name AS VARCHAR(MAX)), ', ')) AS toppings_name_exclusions
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.exclusions, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY t1.order_number
),
order_extras_tb AS (
	SELECT
		t1.order_number,
		CONCAT('Extra ', STRING_AGG(CAST(t3.topping_name AS VARCHAR(MAX)), ', ')) AS toppings_name_extras
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.extras, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY t1.order_number
)
UPDATE customer_orders
SET customer_orders.order_details = order_details_tb.order_details
FROM (
	SELECT
		t1.order_number,
		t1.order_id,
		t1.customer_id,
		CONCAT_WS(' - ', t2.pizza_name, t3.toppings_name_exclusions, t4.toppings_name_extras) AS order_details
	FROM customer_orders AS t1
	INNER JOIN pizza_full_info AS t2
		ON t1.pizza_id = t2.pizza_id
	LEFT JOIN order_exclusions_tb AS t3
		ON t1.order_number = t3.order_number
	LEFT JOIN order_extras_tb AS t4
		ON t1.order_number = t4.order_number
) AS order_details_tb
WHERE customer_orders.order_number = order_details_tb.order_number;
```
One of the interesting aspects of the query above is that the question is quite challenging and requires the use of several new functions like STRING_SPLIT and CONCAT_WS. Moreover, it is essential to get familiar with the syntax of CROSS APPLY (the key factor for the query to return the desired result) and the issues related to handling string data.
### Key Learnings from Danny’s Diner Case Study
The following topics relevant to the Pizza Runner case study are covered in depth in the Serious SQL course:
- Common table expressions.
- Group by aggregates.
- Table joins.
- String transformations.
- Dealing with null values.
- Regular expressions.
- Understanding and using `CROSS APPLY` with `STRING_SPLIT`.
## Week 3: Foodie-Fi
### Introduction
Danny saw a unique opportunity in the streaming market and launched Foodie-Fi in 2020 — a subscription-based platform dedicated solely to food-related content, offering unlimited access to exclusive cooking shows from around the world through monthly or annual plans.

Built with a data-driven mindset, Foodie-Fi uses subscription data to guide key business decisions. This case study explores how digital subscription data can be analyzed to answer important business questions and support strategic growth.
### Dataset
![FoodieFi/Foodie-Fi.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/FoodieFi/Foodie-Fi.png)

View more in the [FoodieFi/Create_FoodieFi_Dataset.sql](FoodieFi/Create_FoodieFi_Dataset.sql).
### Business Goals
- *Track customer subscriptions:* Understand how customers progress through free trials, paid plans, upgrades, downgrades, and churn.
- *Evaluate revenue impact:* Analyze subscription timing and payment behavior to measure revenue and identify growth opportunities.
- *Improve customer retention:* Identify key drop-off points and develop strategies to encourage plan upgrades and reduce churn.

### Case Study Questions and SQL Scripts
**A. Customer Journey**

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
- *Customer 1:* Started with a free trial. After the 7-day period, the system automatically upgraded the subscription to the Pro monthly plan.
- *Customer 2:* Started with a free trial. As the trial was about to expire, the user directly upgraded to the Pro annual plan.
- *Customer 11:* Started with a free trial. At the end of the trial period, the customer chose to cancel the subscription and leave.
- *Customer 13:* Started with a free trial. As the trial was nearing its end, the customer subscribed to the Basic plan and later upgraded to the Pro monthly plan.
- *Customer 15:* Started with a free trial. When the trial expired, the system automatically subscribed the customer to the Pro monthly plan, but they later chose to cancel and leave.
- *Customer 16:* Started with a free trial. As the trial was about to expire, the customer subscribed to the Basic plan and later upgraded to the Pro annual plan.
- *Customer 18:* Started with a free trial. As the trial was nearing its end, the system automatically subscribed the customer to the Pro monthly plan.
- *Customer 19:* Started with a free trial. As the trial was about to expire, the system automatically subscribed the customer to the Pro monthly plan, which was later upgraded to the Pro annual plan.

**B. Data Analysis Questions**
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods from Question 9 (i.e. 0-30 days, 31-60 days etc).
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

**C. Challenge Payment Question**

The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

- monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- once a customer churns they will no longer make payments

*Each question is answered in a separate SQL file stored in the [`FoodieFi/`](FoodieFi/) folder.*
### Highlighted Query
``` sql
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
)
```
### Key Learnings from Foodie-Fi Case Study
- **Recursive CTEs** for handling hierarchical data and performing complex traversals in self-referencing tables in SQL Server.
- Window functions like ROW_NUMBER(), LEAD() and LAG() for ranking and calculating engagement metrics across multiple data levels.
## Week 4: Data Bank
### Introduction
The rise of Neo-Banks—fully digital financial institutions without physical branches—has sparked innovation across the financial sector. Inspired by this trend, Danny launched Data Bank, a next-generation digital bank that uniquely integrates cryptocurrency, financial services, and secure distributed data storage. Unlike traditional banks, Data Bank links customers' cloud storage capacity to their account balances, creating a dynamic and data-driven ecosystem.

This case study explores how Data Bank leverages data analytics to track customer behavior, forecast storage needs, and support strategic growth. By calculating key business metrics and understanding usage patterns, the company aims to expand its customer base while efficiently managing its innovative service model.
### Dataset
![DataBank/Data Bank.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DataBank/Data%20Bank.png)

View more in the [DataBank/Create_DataBank_Dataset.sql](DataBank/Create_DataBank_Dataset.sql).
### Business Goals
- *Map system structure:* Explore node distribution and customer reallocation patterns.
- *Analyze transaction behavior:* Review deposit trends, balances, and monthly activity.
- *Estimate data needs:* Model data allocation scenarios to forecast storage demand.
### Case Study Questions and SQL Scripts
**A. Customer Nodes Exploration**
1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

**B. Customer Transactions**
1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

**C. Data Allocation Challenge**
1. To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:
- Option 1: data is allocated based off the amount of money at the end of the previous month.
- Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days.
- Option 3: data is updated real-time.

For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
- running customer balance column that includes the impact each transaction.
- customer balance at the end of each month.
- minimum, average and maximum values of the running balance for each customer.

Using all of the data available - how much data would have been required for each option on a monthly basis?

**D. Extra Challenge**

Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?

*Special notes:* Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!

*Each question is answered in a separate SQL file stored in the [`DataBank/`](DataBank/) folder.*
### Highlighted Query
```sql
USE DataBankDBUI;
GO

-- Calculation 1: Simple Interest
-- Method 1: Transaction Interval-Based Allocation Method
DECLARE @YearSimpleInterest AS FLOAT;
DECLARE @DateSimpleInterest AS FLOAT;
DECLARE @LastDate AS DATE;

SET @YearSimpleInterest = 0.06;
SET @DateSimpleInterest = @YearSimpleInterest/365;
SET @LastDate = (SELECT EOMONTH(MAX(txn_date), 0) FROM customer_transactions);

WITH customer_txn_with_next_date_in_month_and_balance_tb AS (
	SELECT
		customer_id,
		txn_date,
		LEAD(txn_date, 1)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
			) AS next_txn_date,
		SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE txn_amount * (-1) END)
			OVER(
				PARTITION BY customer_id
				ORDER BY txn_date ASC
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
			) AS closing_balance
	FROM customer_transactions
),
customer_txn_next_date_capped_tb AS (
		SELECT
		customer_id,
		txn_date,
		CASE
			WHEN COALESCE(next_txn_date, @LastDate) > EOMONTH(txn_date, 0) AND FORMAT(txn_date, 'yyyy-MM') NOT LIKE FORMAT(COALESCE(next_txn_date, @LastDate), 'yyyy-MM') THEN EOMONTH(txn_date, 0)
			WHEN COALESCE(next_txn_date, @LastDate) = @LastDate AND FORMAT(txn_date, 'yyyy-MM') LIKE FORMAT(@LastDate, 'yyyy-MM') THEN @LastDate
			ELSE DATEADD(day, -1, COALESCE(next_txn_date, @LastDate))
		END AS next_date_in_month,
		COALESCE(next_txn_date, @LastDate) AS next_txn_date,
		closing_balance
	FROM customer_txn_with_next_date_in_month_and_balance_tb
),
recursive_customer_segment_date_in_month_and_balance_tb AS (
	-- Anchor Member
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		next_txn_date,
		closing_balance
	FROM customer_txn_next_date_capped_tb

	UNION ALL
	-- Recursive Member
	SELECT
		customer_id,
		DATEADD(month, 1, DATETRUNC(month, txn_date)) AS txn_date,
		CASE
			WHEN EOMONTH(DATEADD(month, 1, txn_date), 0) < next_txn_date AND FORMAT(DATEADD(month, 1, txn_date), 'yyyy-MM') NOT LIKE FORMAT(next_txn_date, 'yyyy-MM') THEN EOMONTH(DATEADD(month, 1, txn_date), 0)
			WHEN (EOMONTH(DATEADD(month, 1, txn_date), 0) >= next_txn_date OR FORMAT(DATEADD(month, 1, txn_date), 'yyyy-MM') LIKE FORMAT(next_txn_date, 'yyyy-MM')) AND next_txn_date = @LastDate THEN next_txn_date
			ELSE DATEADD(day, -1, next_txn_date)
		END AS next_date_in_month,
		next_txn_date,
		closing_balance
	FROM recursive_customer_segment_date_in_month_and_balance_tb
	WHERE DATEADD(day, 1, next_date_in_month) < next_txn_date
),
customer_txn_data_transition_tb AS (
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		DATEDIFF(day, txn_date, next_date_in_month) + 1 AS date_diff,
		closing_balance,
		CASE WHEN closing_balance < 0 THEN 0 ELSE closing_balance END AS data_transition
	FROM recursive_customer_segment_date_in_month_and_balance_tb
),
customer_monthly_data_allocation_tb AS (
	SELECT
		customer_id,
		txn_date,
		next_date_in_month,
		closing_balance,
		data_transition,
		data_transition * date_diff * (1 + @DateSimpleInterest) AS data_allocation
	FROM customer_txn_data_transition_tb
)
SELECT
	FORMAT(txn_date, 'yyyy-MM') AS activity_month,
	ROUND(SUM(data_allocation), 0) AS total_data
FROM customer_monthly_data_allocation_tb
GROUP BY FORMAT(txn_date, 'yyyy-MM')
ORDER BY activity_month ASC;
```
### Key Learnings from Data Bank Case Study
Working through the Data Bank case study provided hands-on experience with advanced SQL techniques. I gained a deeper understanding of:
- Using VIEW in SQL Server to simplify and organize complex query logic for repeated use.
- Recursive queries to efficiently solve multi-step logic problems while saving significant development time.
- Combining recursion with functions and window operations to calculate simple and compound interest dynamically for each customer on a daily basis.
- Using DECLARE and SET to define and assign variables, allowing for flexible adjustments to input values and enabling customized data scenarios.
## Week 5: Data Mart
### Introduction
Data Mart is Danny’s newest project, focused on delivering fresh produce through an international online supermarket. In June 2020, a major operational shift introduced fully sustainable packaging across the entire supply chain. Danny now seeks analytical support to evaluate how this change has affected overall sales performance and its impact across various business segments.
### Dataset
![DataMart/Data Mart.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DataMart/Data%20Mart.png)

View more in the [DataMart/Create_DataMart_Dataset.sql](DataMart/Create_DataMart_Dataset.sql).
### Business Goals
- *Measure impact of change:* Quantify the sales performance impact of the June 2020 sustainability update.
- *Identify affected areas:* Determine which platforms, regions, segments, and customer types were most affected.
- *Guide future actions:* Provide insights to help reduce potential negative impacts from similar changes in the future.
### Case Study Questions and SQL Scripts
**A. Data Cleansing Steps:** In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
- Convert the week_date to a DATE format.
- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc.
- Add a month_number with the calendar month for each week_date value as the 3rd column.
- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values.
- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value.
- Add a new demographic column using the following mapping for the first letter in the segment values.
- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns.
- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record.

**B. Data Exploration**
1. What day of the week is used for each week_date value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform?
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which age_band and demographic values contribute the most to Retail sales?
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

**C. Before & After Analysis**

This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before.

Using this analysis approach - answer the following questions:

- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
- What about the entire 12 weeks before and after?
- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

**D. Bonus Question**

Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
- region
- platform
- age_band
- demographic
- customer_type

*Each question is answered in a separate SQL file stored in the [`DataMart/`](DataMart/) folder.*
### Highlighted Query
```sql
DROP TABLE IF EXISTS DataMartDBUI.dbo.clean_weekly_sales;
CREATE TABLE DataMartDBUI.dbo.clean_weekly_sales (
	idx INT,
	week_date VARCHAR(7)
);

--	Convert the week_date to a DATE format.
INSERT INTO DataMartDBUI.dbo.clean_weekly_sales (idx, week_date)
	SELECT
		idx,
		week_date
	FROM DataMartDBUI.dbo.weekly_sales
	ORDER BY idx ASC;

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN week_date VARCHAR(10);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET week_date = 
	CONCAT(
		CASE WHEN CAST(RIGHT(week_date, 2) AS INT) BETWEEN 0 AND 49 THEN '20' + RIGHT(week_date, 2) ELSE '19' + RIGHT(week_date, 2) END,
		'-',
		FORMAT(CAST(SUBSTRING(week_date, CHARINDEX('/', week_date, 0) + 1, CHARINDEX('/', week_date, CHARINDEX('/', week_date, 0) + 1) - CHARINDEX('/', week_date, 0) - 1) AS INT), '00'),
		'-',
		FORMAT(CAST(LEFT(week_date, CHARINDEX('/', week_date) - 1) AS INT), '00')
	);

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN week_date DATE;

GO
--	Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD week_number INT;

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET week_number = (DATEPART(dayofyear, week_date) - 1) / 7 + 1;

GO

--	Add a month_number with the calendar month for each week_date value as the 3rd column.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD month_number INT;

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET month_number = MONTH(week_date);

GO
-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD year_number INT;

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET year_number = YEAR(week_date);

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD
	region VARCHAR(13),
	platform VARCHAR(7),
	segment VARCHAR(4);

UPDATE t1
SET
	t1.region = t2.region,
	t1.platform = t2.platform,
	t1.segment = t2.segment
FROM DataMartDBUI.dbo.clean_weekly_sales AS t1
INNER JOIN DataMartDBUI.dbo.weekly_sales AS t2
	ON t1.idx = t2.idx;

GO
-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD age_brand VARCHAR(12);

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET age_brand =
	CASE
		WHEN RIGHT(segment, 1) = '1' THEN 'Young	Adults'
		WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
		WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
		ELSE 'null'
	END;

GO
-- Add a new demographic column using the following mapping for the first letter in the segment values.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD demographic VARCHAR(8);

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET demographic =
	CASE
		WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
		WHEN LEFT(segment, 1) = 'F' THEN 'Families'
		ELSE 'null'
	END;

GO
-- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN segment VARCHAR(7);

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET
	segment = 'unknown',
	age_brand = 'unknown',
	demographic = 'unknown'
WHERE demographic LIKE 'null';

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD
	customer_type VARCHAR(8),
	transactions BIGINT,
	sales BIGINT;

GO
-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record.
UPDATE t1
SET
	t1.customer_type = t2.customer_type,
	t1.transactions = t2.transactions,
	t1.sales = t2.sales
FROM DataMartDBUI.dbo.clean_weekly_sales AS t1
INNER JOIN DataMartDBUI.dbo.weekly_sales AS t2
	ON t1.idx = t2.idx;

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD avg_transaction DECIMAL(5, 2);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET avg_transaction = CAST(sales AS FLOAT) / CAST(transactions AS FLOAT);

GO

SELECT *
FROM DataMartDBUI.dbo.clean_weekly_sales;
```
### Key Learnings from Data Mart Case Study
- Gained experience in data cleansing and transformation using SQL commands like UPDATE SET, ALTER TABLE, ALTER COLUMN, and ALTER ADD to modify and structure the dataset.
- Enhanced data quality by creating new calculated columns and applying functions to standardize formats, such as using CONCAT and FORMAT to modify date formats.
- Utilized UPDATE SET for data updates and INNER JOIN to merge data from different sources for more comprehensive analysis.
- Applied ALTER TABLE to add, modify, and drop columns based on the evolving requirements of the dataset, ensuring better structure for analysis.
## Week 6: Clique Bait
### Introduction
Balanced Tree Clothing Company is a modern fashion brand known for its curated range of clothing and lifestyle wear designed for today’s adventurers. Danny, the CEO, has requested support in analyzing sales performance and preparing a financial report to inform broader business decisions.
### Dataset
![CliqueBait/Clique Bait.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/CliqueBait/Clique%20Bait.png)

View more in the [CliqueBait/Create_CliqueBait_Dataset.sql](CliqueBait/Create_CliqueBait_Dataset.sql).
### Business Goals
- *Digital Analysis:* Understand user behavior, event interactions, and key conversion metrics.
- *Product Funnel:* Track product and category performance from view to purchase.
- *Campaign Impact:* Assess how marketing campaigns influence user engagement and sales.
### Case Study Questions and SQL Scripts
**A. Digital Analysis**
1. How many users are there?
2. How many cookies does each user have on average?
3. What is the unique number of visits by all users per month?
4. What is the number of events for each event type?
5. What is the percentage of visits which have a purchase event?
6. What is the percentage of visits which view the checkout page but do not have a purchase event?
7. What are the top 3 pages by number of views?
8. What is the number of views and cart adds for each product category?
9. What are the top 3 products by purchases?

**B. Product Funnel Analysis**

Using a single SQL query - create a new output table which has the following details:
- How many times was each product viewed?
- How many times was each product added to cart?
- How many times was each product added to a cart but not purchased (abandoned)?
- How many times was each product purchased?

Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

Use your 2 new output tables - answer the following questions:
- Which product had the most views, cart adds and purchases?
- Which product was most likely to be abandoned?
- Which product had the highest view to purchase percentage?
- What is the average conversion rate from view to cart add?
- What is the average conversion rate from cart add to purchase?

**C. Campaigns Analysis**

Generate a table that has 1 single row for every unique visit_id record and has the following columns:
- user_id
- visit_id
- visit_start_time: the earliest event_time for each visit
- page_views: count of page views for each visit
- cart_adds: count of product cart add events for each visit
- purchase: 1/0 flag if a purchase event exists for each visit
- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
- impression: count of ad impressions for each visit
- click: count of ad clicks for each visit
- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)

Some ideas you might want to investigate further include:
- Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event.
- Does clicking on an impression lead to higher purchase rates?
- What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just an impression but do not click?
- What metrics can you use to quantify the success or failure of each campaign compared to eachother?

*Each question is answered in a separate SQL file stored in the [`CliqueBait/`](CliqueBait/) folder.*
### Highlighted Query
```sql
USE CliqueBaitDBUI;
GO

WITH campaign_behavior_metrics_by_impression_tb AS (
	SELECT
		'Total page views' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 THEN page_views ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 THEN page_views ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb

	UNION ALL

	SELECT
		'Total cart adds' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 THEN cart_adds ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 THEN cart_adds ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb

	UNION ALL

	SELECT
		'Total purchases' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 AND purchase = 1 THEN cart_adds ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 AND purchase = 1THEN cart_adds ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb
),
purchase_rate_by_impression_group_tb AS (
	SELECT
		'Purchase rate' AS campaign_metrics,
		CAST(visit_received_impression_gp AS FLOAT) / CAST((visit_received_impression_gp + visit_no_received_impression_gp) AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(visit_no_received_impression_gp AS FLOAT) / CAST((visit_received_impression_gp + visit_no_received_impression_gp) AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb
	WHERE campaign_metrics = 'Total purchases'
),
campaign_conversion_rate_by_impression_tb AS (
	SELECT
		'View page to Add cart Conversion rate' AS campaign_metrics,
		CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total cart adds'

	UNION ALL

	SELECT
		'View page to Purchase Conversion rate' AS campaign_metrics,
		ROUND(CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100, 2) AS visit_received_impression_gp,
		ROUND(CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100, 2) AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total purchases'

	UNION ALL

	SELECT
		'Add cart to Purchase Conversion rate' AS campaign_metrics,
		CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total cart adds' AND t2.campaign_metrics = 'Total purchases'
),
avg_campaign_conversion_rate_by_impression_tb AS (
	SELECT
		'Conversion rate Average' AS campaign_metrics,
		AVG(visit_received_impression_gp) AS visit_received_impression_gp,
		AVG(visit_no_received_impression_gp) AS visit_no_received_impression_gp
	FROM campaign_conversion_rate_by_impression_tb
)
SELECT *
FROM campaign_behavior_metrics_by_impression_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(visit_received_impression_gp, 2) AS visit_received_impression_gp,
	ROUND(visit_no_received_impression_gp, 2) AS visit_no_received_impression_gp
FROM purchase_rate_by_impression_group_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(visit_received_impression_gp, 2) AS visit_received_impression_gp,
	ROUND(visit_no_received_impression_gp, 2) AS visit_no_received_impression_gp
FROM campaign_conversion_rate_by_impression_tb;
```
### Key Learnings from Clique Bait Case Study
Learned how to structure query results in a vertical format, where the output table becomes longer rather than wider. This was achieved using UNION ALL instead of multiple JOIN statements, making it easier to compare similar metrics across rows.
## Week 7: Balanced Tree Clothing Co.
### Introduction
Balanced Tree Clothing Company offers a curated range of apparel and lifestyle products tailored for the modern adventurer. To support strategic decision-making, the CEO has requested assistance in analyzing sales performance and developing a financial report to inform broader business discussions.
### Dataset
![BalancedTree/Balanced Tree Clothing Company.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/BalancedTree/Balanced%20Tree%20Clothing%20Company.png)

View more in the [BalancedTree/Create_BalancedTree_Dataset.sql](BalancedTree/Create_BalancedTree_Dataset.sql).
### Business Goals
- *Sales Overview:* Calculate total quantity sold, revenue before discounts, and total discounts.
- *Transaction Insights:* Analyze number of transactions, average items per order, revenue percentiles, and member vs non-member behavior.
- *Product Performance:* Identify top products, segment/category contributions, and common product combinations.
### Case Study Questions and SQL Scripts
**A. High Level Sales Analysis**
1. What was the total quantity sold for all products?
2. What is the total generated revenue for all products before discounts?
3. What was the total discount amount for all products?

**B. Transaction Analysis**
1. How many unique transactions were there?
2. What is the average unique products purchased in each transaction?
3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
4. What is the average discount value per transaction?
5. What is the percentage split of all transactions for members vs non-members?
6. What is the average revenue for member transactions and non-member transactions?

**C. Product Analysis**
1. What are the top 3 products by total revenue before discount?
2. What is the total quantity, revenue and discount for each segment?
3. What is the top selling product for each segment?
4. What is the total quantity, revenue and discount for each category?
5. What is the top selling product for each category?
6. What is the percentage split of revenue by product for each segment?
7. What is the percentage split of revenue by segment for each category?
8. What is the percentage split of total revenue by category?
9. What is the total transaction “penetration” for each product? (Hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

**D. Reporting Challenge**

Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

**E. Bonus Challenge**

Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.

Hint: you may want to consider using a recursive CTE to solve this problem!

*Each question is answered in a separate SQL file stored in the [`BalancedTree/`](BalancedTree/) folder.*
### Highlighted Query
```sql
WITH product_transactions_with_counts_tb AS (
	SELECT
		t2.id,
		t1.prod_id,
		t1.txn_id,
		COUNT(t1.prod_id) OVER(PARTITION BY t1.txn_id) AS total_unique_prod_id
	FROM sales AS t1
	INNER JOIN product_prices AS t2
		ON t1.prod_id = t2.product_id
),
cart_3_product_combinations_tb AS (
	SELECT
		t1.txn_id,
		CONCAT(t1.id, ',', t2.id, ',', t3.id) AS combination_3_id,
		CONCAT(t1.prod_id, ',', t2.prod_id, ',', t3.prod_id) AS combination_3_pro_id_in_cart
	FROM product_transactions_with_counts_tb AS t1
	INNER JOIN product_transactions_with_counts_tb AS t2
		ON t1.txn_id = t2.txn_id
		AND t1.id < t2.id
	INNER JOIN product_transactions_with_counts_tb AS t3
		ON t1.txn_id = t3.txn_id
		AND t2.id < t3.id
	WHERE t1.total_unique_prod_id >= 3
),
frequent_3_product_combinations_tb AS (
	SELECT
		combination_3_id,
		combination_3_pro_id_in_cart,
		COUNT(txn_id) AS frequency_combination,
		RANK() OVER(ORDER BY COUNT(txn_id) DESC) AS ranking
	FROM cart_3_product_combinations_tb
	GROUP BY combination_3_id, combination_3_pro_id_in_cart
)
SELECT
	DENSE_RANK() OVER(ORDER BY t1.combination_3_id ASC) AS combination_id,
	t2.value,
	t3.product_name,
	t1.frequency_combination
FROM frequent_3_product_combinations_tb AS t1
CROSS APPLY STRING_SPLIT(t1.combination_3_pro_id_in_cart, ',') AS t2
INNER JOIN product_details AS t3
	ON t2.value = t3.product_id
WHERE ranking = 1;
```
### Key Learnings from Balanced Tree Clothing Co. Case Study
Learned how to use CROSS JOIN to generate all possible combinations from a list. This approach is especially useful in identifying popular product baskets or top product groupings commonly purchased together in a single transaction.
## Week 8: Fresh Segments
### Introduction
Fresh Segments is a data-driven digital marketing agency established by Danny, aiming to support businesses in understanding their customers’ online behavior—particularly how users interact with digital advertising assets. Clients provide their customer lists to the Fresh Segments team, who then aggregate and analyze interest-based interaction data. This process results in a comprehensive dataset that reflects how different customer segments engage with various online interest categories over time.

In this case study, Danny has requested assistance in analyzing an example client’s dataset. The objective is to generate meaningful insights from the aggregated monthly data, particularly focusing on how customers’ interests are distributed and ranked. This analysis will help the client better understand their audience’s preferences and inform future marketing and content strategies.
### Dataset
![FreshSegments/Fresh Segments.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/FreshSegments/Fresh%20Segments.png)

View more in the [FreshSegments/Create_FreshSegments_Dataset.sql](FreshSegments/Create_FreshSegments_Dataset.sql).
### Business Goals
- *Track Persistent Interests:* Identify interests consistently present across all months to uncover stable patterns in customer engagement.
- *Analyze Segment Trends:* Examine changes in composition and ranking to spot high-performing and volatile interests over time.
- *Use Index Metrics Effectively:* Apply index values to estimate average composition, highlight top monthly interests, and monitor longer-term trends.
### Case Study Questions and SQL Scripts
**A. Data Exploration and Cleansing**
1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month.
2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
3. What do you think we should do with these null values in the fresh_segments.interest_metrics
4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?
5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table
6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.
7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?

**B. Interest Analysis**
1. Which interests have been present in all month_year dates in our dataset?
2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 10 months - which total_months value passes the 90% cumulative percentage value?
3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?
4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.
5. After removing these interests - how many unique interests are there for each month?

**C. Segment Analysis**
1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest
2. composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year
3. Which 5 interests had the lowest average ranking value?
4. Which 5 interests had the largest standard deviation in their percentile_ranking value?
5. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value?
6. an you describe what is happening for these 5 interests?

**D. Index Analysis**

The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.

Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.

1. What is the top 10 interests by the average composition for each month?
2. For all of these top 10 interests - which interest appears the most often?
3. What is the average of the average composition for the top 10 interests for each month?
4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.

*Each question is answered in a separate SQL file stored in the [`FreshSegments/`](FreshSegments/) folder.*
### Highlighted Query
```sql
WITH interest_avg_composition_ranking_each_month_tb AS (
	SELECT
		 month_year,
		 interest_id,
		 composition / index_value AS avg_composition,
		 RANK()
			OVER(
				PARTITION BY month_year
				ORDER BY (composition / index_value) DESC
			) AS ranking
	FROM interest_metrics
	WHERE
		interest_id IS NOT NULL AND month_year IS NOT NULL
		AND month_year BETWEEN DATEADD(month, -2, '2018-09-01') AND '2019-08-01'
),
monthly_top_interest_avg_tb AS (
	SELECT
		t1.month_year,
		t1.interest_id,
		t2.interest_name,
		t1.avg_composition AS max_index_composition,
		CONCAT(t2.interest_name, ': ', ROUND(t1.avg_composition, 2)) AS concat_interest_name_vs_avg_composition,
		AVG(t1.avg_composition)
			OVER(
				ORDER BY t1.month_year ASC
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			) AS _3_month_moving_avg
	FROM interest_avg_composition_ranking_each_month_tb AS t1
	INNER JOIN interest_map AS t2
		ON t1.interest_id = t2.id
	WHERE t1.ranking = 1
)
SELECT
	t1.month_year,
	t1.interest_name,
	ROUND(t1.max_index_composition, 2) AS max_index_composition,
	ROUND(t1._3_month_moving_avg, 2) AS _3_month_moving_avg,
	t2.concat_interest_name_vs_avg_composition AS _1_month_ago,
	t3.concat_interest_name_vs_avg_composition AS _2_month_ago
FROM monthly_top_interest_avg_tb AS t1
INNER JOIN monthly_top_interest_avg_tb AS t2
	ON t1.month_year = DATEADD(month, 1, t2.month_year)
INNER JOIN monthly_top_interest_avg_tb AS t3
	ON t1.month_year = DATEADD(month, 2, t3.month_year)
ORDER BY month_year ASC;
```
### Key Learnings from Fresh Segments Case Study
Learned how to use self-join to display future months relative to the current one - an alternative to using LAG when needing to compare upcoming values in time-based data.
