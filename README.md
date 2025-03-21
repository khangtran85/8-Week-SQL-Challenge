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
DROP TABLE IF EXISTS menu;
CREATE TABLE menu (
	product_id INT PRIMARY KEY,
	product_name VARCHAR(11),
	price INT
);
INSERT INTO menu
VALUES
	('1', 'sushi', '10'),
	('2', 'curry', '15'),
	('3', 'ramen', '12'),
	('4', 'okononiyaki', '15'),
	('5', 'yakiniku', '20');
DROP TABLE IF EXISTS members;
CREATE TABLE members (
	customer_id VARCHAR(1) PRIMARY KEY,
	join_date DATE
);
INSERT INTO members
VALUES
	('A', '2024-08-31'),
	('B', '2024-08-02'),
	('C', '2024-08-26'),
	('D', '2024-07-23'),
	('E', '2024-07-26'),
	('F', '2024-08-27'),
  ...
ALTER TABLE sales
ADD CONSTRAINT cusomter_id FOREIGN KEY (customer_id) REFERENCES members(customer_id);
ALTER TABLE sales
ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES menu(product_id);
```
View more in [Create_DannyDiner_Dataset.sql](DannysDinner/Create_DannyDiner_Dataset.sql)
### Business Goals
- *Understand visiting patterns*: Danny wants to learn how often each customer visits the restaurant.

- *Analyze spending and preferences*: He is interested in knowing how much money customers spend and which menu items they prefer.

- *Support loyalty strategy*: These insights will help him decide whether to expand the loyalty program and personalize the experience for loyal customers.

## Week 2: Pizza Runner
## Week 3: Foodie-Fi
## Week 4: Data Bank
## Week 5: Data Mart
## Week 6: Clique Bait
## Week 7: Balanced Tree Clothing Co.
## Week 8: Fresh Segments
# Consideration
