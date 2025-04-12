USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 5: What is the total count of transactions for each platform?
SELECT
	platform,
	SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform
ORDER BY platform ASC;