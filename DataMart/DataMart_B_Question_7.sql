USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 7: What is the percentage of sales by demographic for each year in the dataset?
WITH platform_sales_yearly_tb AS (
SELECT
	year_number,
	demographic,
	SUM(sales) AS total_sales,
	SUM(SUM(sales)) OVER(PARTITION BY year_number) AS yearly_total_sales
FROM clean_weekly_sales
GROUP BY year_number, demographic
)
SELECT
	year_number,
	demographic,
	CAST((CAST(total_sales AS FLOAT) / CAST(yearly_total_sales AS FLOAT) * 100) AS DECIMAL(5, 2)) AS percentage_total_sales
FROM platform_sales_yearly_tb
ORDER BY year_number ASC, percentage_total_sales DESC;