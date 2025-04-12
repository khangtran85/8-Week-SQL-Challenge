USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 3: How many total transactions were there for each year in the dataset?
SELECT
	year_number,
	SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY year_number
ORDER BY year_number ASC;