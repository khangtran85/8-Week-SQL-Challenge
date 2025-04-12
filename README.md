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
- **Optimize delivery efficiency:** Analyze the performance of runners, delivery times, and cancellation patterns.

- **Understand customer preferences:** Identify the most popular pizzas and ordering patterns.

- **Improve operational processes:** Use data to refine order fulfillment and runner assignment.

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

- I*mprove customer retention:* Identify key drop-off points and develop strategies to encourage plan upgrades and reduce churn.

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

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

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
### Dataset
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Clique Bait Case Study

## Week 7: Balanced Tree Clothing Co.
### Introduction
### Dataset
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Balanced Tree Clothing Co. Case Study

## Week 8: Fresh Segments
### Introduction
### Dataset
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Fresh Segments Case Study
# Consideration
