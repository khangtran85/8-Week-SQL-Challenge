USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 6: What is the percentage of sales for Retail vs Shopify for each month?
WITH platform_sales_monthly_tb AS (
SELECT
	month_number,
	platform,
	SUM(sales) AS total_sales,
	SUM(SUM(sales)) OVER(PARTITION BY month_number) AS monthly_total_sales
FROM clean_weekly_sales
GROUP BY month_number, platform
)
SELECT
	month_number,
	platform,
	CAST((CAST(total_sales AS FLOAT) / CAST(monthly_total_sales AS FLOAT) * 100) AS DECIMAL(5, 2)) AS percentage_total_sales
FROM platform_sales_monthly_tb
ORDER BY month_number ASC, percentage_total_sales DESC;