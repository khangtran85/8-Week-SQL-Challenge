USE DataMartDBUI;
GO
-- C. Before & After Analysis
-- This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.
-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
-- We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before
-- Using this analysis approach - answer the following questions:
--	1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
--	2. What about the entire 12 weeks before and after?
--	3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

-- Question 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
DECLARE @BaselineWeek DATE;
SET @BaselineWeek = '2020-06-15';

WITH sales_4weeks_before_baseline_tb AS (
	SELECT
		year_number,
		SUM(
			CASE
				WHEN YEAR(@BaselineWeek) > year_number AND week_date < DATEADD(year, year_number - YEAR(@BaselineWeek), @BaselineWeek) AND week_date >= DATEADD(week, -4, DATEADD(year, year_number - YEAR(@BaselineWeek), @BaselineWeek)) THEN sales
				WHEN YEAR(@BaselineWeek) < year_number AND week_date < DATEADD(year, YEAR(@BaselineWeek) - year_number, @BaselineWeek) AND week_date >= DATEADD(week, -4, DATEADD(year, YEAR(@BaselineWeek) - year_number, @BaselineWeek)) THEN sales
				WHEN YEAR(@BaselineWeek) = year_number AND week_date < @BaselineWeek AND week_date >= DATEADD(week, -4, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_before_baseline_week
	FROM clean_weekly_sales
	GROUP BY year_number
),
sales_4weeks_after_baseline_tb AS (
	SELECT
		year_number,
		SUM(
			CASE
				WHEN YEAR(@BaselineWeek) > year_number AND week_date >= DATEADD(year, year_number - YEAR(@BaselineWeek), @BaselineWeek) AND week_date < DATEADD(week, 4, DATEADD(year, year_number - YEAR(@BaselineWeek), @BaselineWeek)) THEN sales
				WHEN YEAR(@BaselineWeek) < year_number AND week_date >= DATEADD(year, YEAR(@BaselineWeek) -  year_number, @BaselineWeek) AND week_date < DATEADD(week, 4, DATEADD(year, YEAR(@BaselineWeek) - year_number, @BaselineWeek)) THEN sales
				WHEN YEAR(@BaselineWeek) = year_number AND week_date >= @BaselineWeek AND week_date < DATEADD(week, 4, @BaselineWeek) THEN sales
				ELSE 0
			END
		) AS total_sales_after_baseline_week
	FROM clean_weekly_sales
	GROUP BY year_number
)
SELECT
	t1.year_number,
	t1.total_sales_before_baseline_week,
	t2.total_sales_after_baseline_week,
	CASE
		WHEN t1.total_sales_before_baseline_week < t2.total_sales_after_baseline_week THEN 'Growth'
		WHEN t1.total_sales_before_baseline_week > t2.total_sales_after_baseline_week THEN 'Decline'
		ELSE 'Stability'
	END AS sales_trend_type,
	t2.total_sales_after_baseline_week - t1.total_sales_before_baseline_week AS sales_diff,
	ROUND((
		(CAST(t2.total_sales_after_baseline_week AS FLOAT) - CAST(t1.total_sales_before_baseline_week AS FLOAT))
		/ CAST(t1.total_sales_before_baseline_week AS FLOAT) * 100
	), 2) AS percentage_total_sales_change
FROM sales_4weeks_before_baseline_tb AS t1
INNER JOIN sales_4weeks_after_baseline_tb AS t2
	ON t1.year_number = t2.year_number
ORDER BY year_number ASC;