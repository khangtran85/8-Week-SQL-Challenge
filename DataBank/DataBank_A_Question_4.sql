USE DataBankDBUI;
GO
-- A. Customer Nodes Exploration
-- Question 4: How many days on average are customers reallocated to a different node?
SELECT ROUND(AVG(CAST((DATEDIFF(day, start_date, end_date) + 1) AS FLOAT)), 2) AS avg_days_to_reallocate
FROM customer_nodes
WHERE end_date <> '9999-12-31';