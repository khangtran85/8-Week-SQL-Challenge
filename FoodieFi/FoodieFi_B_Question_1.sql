USE FoodieFiDBUI;
GO
-- B. Data Analysis Questions
-- Question 1: How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions;