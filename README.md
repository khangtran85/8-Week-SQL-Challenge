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

### Case Study Questions
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

### SQL Scripts
Each question is answered in a separate SQL file stored in the [`DannysDiner/`](DannysDiner/) folder:

- [DannysDinner/DannysDiner_Question_1.sql](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_1.sql)
- [DannysDiner/DannysDiner_Question_2.sql](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_2.sql)
- [DannysDiner/DannysDiner_Question_3.sql](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_3.sql)
- [DannysDiner/DannysDiner_Question_4.sql](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_4.sql)
- [[DannysDiner/DannysDiner_Question_5.sql](DannysDiner/DannysDiner_Question_5.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_5.sql)
- [[DannysDiner/DannysDiner_Question_6.sql](DannysDiner/DannysDiner_Question_6.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_6.sql)
- [[DannysDiner/DannysDiner_Question_7.sql](DannysDiner/DannysDiner_Question_7.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_7.sql)
- [[DannysDiner/DannysDiner_Question_8.sql](DannysDiner/DannysDiner_Question_8.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_8.sql)
- [[DannysDiner/DannysDiner_Question_9.sql](DannysDiner/DannysDiner_Question_9.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_9.sql)
- [[DannysDiner/DannysDiner_Question_10.sql](DannysDiner/DannysDiner_Question_10.sql)](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/DannysDiner/DannysDiner_Question_10.sql)

**Explore all solutions in the [`DannysDiner`](DannysDiner/) folder.**
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
## Week 3: Foodie-Fi
## Week 4: Data Bank
## Week 5: Data Mart
## Week 6: Clique Bait
## Week 7: Balanced Tree Clothing Co.
## Week 8: Fresh Segments
# Consideration
