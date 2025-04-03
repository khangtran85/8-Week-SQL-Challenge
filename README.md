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
``` SQL
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	customer_id VARCHAR(1),
	order_date DATE,
	product_id INT
);
INSERT INTO sales
VALUES
	('A', '2024-01-03', '2'),
	('A', '2024-01-03', '3'),
	('A', '2024-01-07', '2'),
	('A', '2024-01-07', '5'),
	('A', '2024-01-08', '1'),
	('A', '2024-01-11', '1'),
	...
	...
	...
ALTER TABLE sales
ADD CONSTRAINT cusomter_id FOREIGN KEY (customer_id) REFERENCES members(customer_id);
ALTER TABLE sales
ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES menu(product_id);
```
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
``` sql
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions VARCHAR(4),
	extras VARCHAR(4),
	order_time DATETIME2(0)
	...
-- Update table from Database
-- Update 'exclusions' columns from 'customer_orders' table
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = '' OR exclusions = 'null';
-- Update 'extras' columns from 'customer_orders' table
UPDATE customer_orders
SET extras = NULL
WHERE extras = '' OR extras = 'null';

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
	order_id INT,
	runner_id INT,
	pickup_time VARCHAR(19),
	distance VARCHAR(7),
	duration VARCHAR(10),
	cancellation VARCHAR(23)
);
...
-- Update 'pickup_time' columns from 'runner_orders' table
UPDATE runner_orders
SET
	pickup_time = NULL,
	distance = NULL,
	duration = NULL
WHERE pickup_time = 'null';

ALTER TABLE runner_orders
ALTER COLUMN pickup_time DATETIME2(0);

-- Update 'distance' columns from 'runner_orders' table
UPDATE runner_orders
SET distance = LEFT(distance, CHARINDEX(' ', distance) - 1)
WHERE distance LIKE '% km';
UPDATE runner_orders
SET distance = LEFT(distance, CHARINDEX('k', distance) - 1)
WHERE distance LIKE '%km';
...
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
	pizza_id INT PRIMARY KEY,
	pizza_name TEXT
);
...
-- Set up constraint
DROP TABLE IF EXISTS pizza_full_info;
SELECT
	t1.pizza_id,
	t1.pizza_name,
	t2.toppings
INTO pizza_full_info
FROM pizza_names AS t1
INNER JOIN pizza_recipes AS t2
	ON t1.pizza_id = t2.pizza_id;

DROP TABLE pizza_names;
DROP TABLE pizza_recipes;

ALTER TABLE pizza_full_info
ADD CONSTRAINT PK_pizza_full_info PRIMARY KEY (pizza_id);

ALTER TABLE pizza_full_info
ALTER COLUMN pizza_name VARCHAR(MAX);

ALTER TABLE pizza_full_info
ALTER COLUMN toppings VARCHAR(MAX);

ALTER TABLE customer_orders
ADD CONSTRAINT FK_customer_orders_pizza_full_info_pizza_id FOREIGN KEY (pizza_id) REFERENCES pizza_full_info(pizza_id);
...
```
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
  What is the total quantity of each ingredient used in all delivered pizzas, sorted by most frequent first?

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
### Business Goals
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
### Highlighted Query
### Key Learnings from Foodie-Fi Case Study
## Week 4: Data Bank
### Introduction
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Data Bank Case Study
## Week 5: Data Mart
### Introduction
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Data Mart Case Study
## Week 6: Clique Bait
### Introduction
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Clique Bait Case Study
## Week 7: Balanced Tree Clothing Co.
### Introduction
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Balanced Tree Clothing Co. Case Study
## Week 8: Fresh Segments
### Introduction
### Business Goals
### Case Study Questions and SQL Scripts
### Highlighted Query
### Key Learnings from Fresh Segments Case Study
# Consideration
