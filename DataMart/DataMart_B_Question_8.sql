USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 8: Which age_band and demographic values contribute the most to Retail sales?
WITH retail_sales_by_age_brand_tb AS (
	SELECT
		age_brand,
		SUM(sales) AS total_sales,
		SUM(SUM(sales)) OVER() AS age_brand_total_sales,
		RANK() OVER(ORDER BY SUM(sales) DESC) AS ranking
	FROM clean_weekly_sales
	WHERE platform = 'Retail' AND age_brand <> 'unknown'
	GROUP BY age_brand
),
retail_age_brand_pct_rank_tb AS (
	SELECT
		age_brand,
		total_sales,
		CAST((CAST(total_sales AS FLOAT) / CAST(age_brand_total_sales AS FLOAT) * 100) AS DECIMAL(5, 2)) AS percentage_total_sales
	FROM retail_sales_by_age_brand_tb
	WHERE ranking = 1
),
retail_sales_by_demographic_tb AS (
	SELECT
		demographic,
		SUM(sales) AS total_sales,
		SUM(SUM(sales)) OVER() AS demographic_total_sales,
		RANK() OVER(ORDER BY SUM(sales) DESC) AS ranking
	FROM clean_weekly_sales
	WHERE platform = 'Retail'AND demographic <> 'unknown'
	GROUP BY demographic
),
retail_demographic_pct_rank_tb AS (
	SELECT
		demographic,
		total_sales,
		CAST((CAST(total_sales AS FLOAT) / CAST(demographic_total_sales AS FLOAT) * 100) AS DECIMAL(5, 2)) AS percentage_total_sales
	FROM retail_sales_by_demographic_tb
	WHERE ranking = 1
)
SELECT *
FROM retail_age_brand_pct_rank_tb AS t1
CROSS JOIN retail_demographic_pct_rank_tb AS t2;