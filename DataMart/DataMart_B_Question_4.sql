USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 4: What is the total sales for each region for each month?
SELECT
	month_number,
	region,
	SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number,region
ORDER BY month_number ASC, total_sales DESC;