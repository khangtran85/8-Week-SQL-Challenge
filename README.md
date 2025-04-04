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
One of the standout queries isn't necessarily complex, but it's powerful in the insight it delivers: it shows how **Window functions** can be elegantly combined within a **CASE WHEN** statement. This technique not only enhances readability but also reduces the overall length of the query significantly.

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
One of the best things about the query is recursion; it is the best solution for the problem, and using this approach has significantly reduced the time spent writing the code.
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
Working through the Clique Bait case study provided practical experience with advanced SQL techniques. I developed a deeper understanding of:
- **Recursive CTEs** for handling hierarchical data and performing complex traversals in self-referencing tables.
- Window functions like ROW_NUMBER(), LEAD() and LAG() for ranking and calculating engagement metrics across multiple data levels.
- Aggregations using GROUP BY to summarize user activity and identify key patterns.
- CASE WHEN logic for segmenting users based on specific behaviors or milestones.

These concepts were applied practically, such as:
- Building recursive queries using CTEs to track user journeys and product recommendations.
- Using window functions to rank and identify significant events in user engagement.
- Applying CASE WHEN for behavior-based segmentation of users.
- Recursive CTEs in SQL Server.

## Week 4: Data Bank
### Introduction
### Dataset
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Data Bank Case Study

## Week 5: Data Mart
### Introduction
### Dataset
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Data Mart Case Study

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
