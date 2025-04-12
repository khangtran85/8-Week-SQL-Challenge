USE DataMartDBUI;
GO
-- B. Data Exploration
-- Question 1: What day of the week is used for each week_date value?
SELECT DISTINCT
	week_date,
	DATENAME(weekday, week_date) AS day_of_week
FROM clean_weekly_sales
ORDER BY week_date ASC;