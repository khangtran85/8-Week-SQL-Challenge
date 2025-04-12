USE DataMartDBUI;
GO
-- D. Bonus Question
-- Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
--	region
--	platform
--	age_band
--	demographic
--	customer_type
DECLARE @BaselineWeek DATE;
SET @BaselineWeek = '2020-06-15';

WITH sales_12weeks_before_and_after_baseline_each_region_tb AS (
	SELECT
		'region' AS areas,
		region,
		SUM(
			CASE
				WHEN week_date < @BaselineWeek AND week_date >= DATEADD(week, -12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week,
		SUM(
			CASE
				WHEN week_date >= @BaselineWeek AND week_date < DATEADD(week, 12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY region
),
sales_12weeks_before_and_after_baseline_each_platform_tb AS (
	SELECT
		'platform' AS areas,
		platform,
		SUM(
			CASE
				WHEN week_date < @BaselineWeek AND week_date >= DATEADD(week, -12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week,
		SUM(
			CASE
				WHEN week_date >= @BaselineWeek AND week_date < DATEADD(week, 12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY platform
),
sales_12weeks_before_and_after_baseline_each_age_brand_tb AS (
	SELECT
		'age_brand' AS areas,
		age_brand,
		SUM(
			CASE
				WHEN week_date < @BaselineWeek AND week_date >= DATEADD(week, -12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week,
		SUM(
			CASE
				WHEN week_date >= @BaselineWeek AND week_date < DATEADD(week, 12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY age_brand
),
sales_12weeks_before_and_after_baseline_each_demographic_tb AS (
	SELECT
		'demographic' AS areas,
		demographic,
		SUM(
			CASE
				WHEN week_date < @BaselineWeek AND week_date >= DATEADD(week, -12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week,
		SUM(
			CASE
				WHEN week_date >= @BaselineWeek AND week_date < DATEADD(week, 12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY demographic
),
sales_12weeks_before_and_after_baseline_each_customer_type_tb AS (
	SELECT
		'customer_type' AS areas,
		customer_type,
		SUM(
			CASE
				WHEN week_date < @BaselineWeek AND week_date >= DATEADD(week, -12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week,
		SUM(
			CASE
				WHEN week_date >= @BaselineWeek AND week_date < DATEADD(week, 12, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY customer_type
),
combined_sales_impact_by_business_area_tb AS (
	SELECT
		areas,
		region AS area_details,
		total_sales_before_baseline_week,
		total_sales_after_baseline_week
	FROM sales_12weeks_before_and_after_baseline_each_region_tb
	UNION ALL
	SELECT *
	FROM sales_12weeks_before_and_after_baseline_each_platform_tb
	UNION ALL
	SELECT *
	FROM sales_12weeks_before_and_after_baseline_each_age_brand_tb
	UNION ALL
	SELECT *
	FROM sales_12weeks_before_and_after_baseline_each_demographic_tb
	UNION ALL
	SELECT *
	FROM sales_12weeks_before_and_after_baseline_each_customer_type_tb
)
SELECT
	areas,
	area_details,
	total_sales_before_baseline_week,
	ROUND((
		CAST(total_sales_before_baseline_week AS FLOAT)
		/ CAST(SUM(total_sales_before_baseline_week) OVER(PARTITION BY areas) AS FLOAT) * 100
	), 2) AS percentage_total_sales_before_baseline_week,
	total_sales_after_baseline_week,
	ROUND((
		CAST(total_sales_after_baseline_week AS FLOAT)
		/ CAST(SUM(total_sales_after_baseline_week) OVER(PARTITION BY areas) AS FLOAT) * 100
	), 2) AS percentage_total_sales_after_baseline_week,
	total_sales_after_baseline_week - total_sales_before_baseline_week AS sales_diff,
	ROUND((
		(CAST(total_sales_after_baseline_week AS FLOAT) - CAST(total_sales_before_baseline_week AS FLOAT))
		/ CAST(total_sales_before_baseline_week AS FLOAT) * 100
	), 2) AS percentage_total_sales_change
FROM combined_sales_impact_by_business_area_tb;