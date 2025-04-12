USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 9: Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
SELECT
	year_number,
	platform,
	AVG(transactions) AS avg_transaction_size
FROM clean_weekly_sales
GROUP BY year_number, platform
ORDER BY year_number ASC, avg_transaction_size DESC;
