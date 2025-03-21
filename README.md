# 8-Week-SQL-Challenge
8 Week SQL Challenge is a series of SQL exercises designed to enhance data querying skills through real-world scenarios. Each challenge covers key SQL concepts like JOINs, CTEs, and Window Functions. Work with datasets on customer behavior, sales, finance, and more. Clone the repo, explore challenges, and level up your SQL skills!
# Processing
## Week 1: Danny's Diner
### Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 5 favourite foods: sushi, curry, ramen, okononiyaki and yakiniku.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.
### Dataset
![Danny's Diner.png](https://github.com/khangtran85/8-Week-SQL-Challenge/blob/main/Danny's%20Diner.png)

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
View more in the [Create_DannyDiner_Dataset.sql](DannysDinner/Create_DannyDiner_Dataset.sql).
### Business Goals
- *Understand visiting patterns*: Danny wants to learn how often each customer visits the restaurant.

- *Analyze spending and preferences*: He is interested in knowing how much money customers spend and which menu items they prefer.

- *Support loyalty strategy*: These insights will help him decide whether to expand the loyalty program and personalize the experience for loyal customers.

## Case Study Questions
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

## 📂 SQL Scripts

Each question is answered in a separate SQL file stored in the [`DannysDiner/`](DannysDiner/) folder:

- [DannyDiner_Question_1.sql](DannysDiner/DannyDiner_Question_1.sql)  
- [DannyDiner_Question_2.sql](DannysDiner/DannyDiner_Question_2.sql)  
- [DannyDiner_Question_3.sql](DannysDiner/DannyDiner_Question_3.sql)  
- [DannyDiner_Question_4.sql](DannysDiner/DannyDiner_Question_4.sql)  
- [DannyDiner_Question_5.sql](DannysDiner/DannyDiner_Question_5.sql)  
- [DannyDiner_Question_6.sql](DannysDiner/DannyDiner_Question_6.sql)  
- [DannyDiner_Question_7.sql](DannysDiner/DannyDiner_Question_7.sql)  
- [DannyDiner_Question_8.sql](DannysDiner/DannyDiner_Question_8.sql)  
- [DannyDiner_Question_9.sql](DannysDiner/DannyDiner_Question_9.sql)  
- [DannyDiner_Question_10.sql](DannysDiner/DannyDiner_Question_10.sql)

👉 **Explore all solutions in the [`DannysDiner`](DannysDiner/) folder.**

## ✨ Highlighted Query

Example: Finding each customer's most frequently ordered item using `RANK()`:
## Week 2: Pizza Runner
## Week 3: Foodie-Fi
## Week 4: Data Bank
## Week 5: Data Mart
## Week 6: Clique Bait
## Week 7: Balanced Tree Clothing Co.
## Week 8: Fresh Segments
# Consideration
