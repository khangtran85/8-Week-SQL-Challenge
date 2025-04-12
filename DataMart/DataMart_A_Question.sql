-- Execute Query: Create_DataMart_Dataset.sql in 'C:\Users\THIEN KHANG\Documents\Documents\DA\SQL\SQL Server\Data Mart\Create_DataMart_Dataset.sql'
-- A. Data Cleansing Steps
-- In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
DROP TABLE IF EXISTS DataMartDBUI.dbo.clean_weekly_sales;
CREATE TABLE DataMartDBUI.dbo.clean_weekly_sales (
	idx INT,
	week_date VARCHAR(7)
);

--	Convert the week_date to a DATE format.
INSERT INTO DataMartDBUI.dbo.clean_weekly_sales (idx, week_date)
	SELECT
		idx,
		week_date
	FROM DataMartDBUI.dbo.weekly_sales
	ORDER BY idx ASC;

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN week_date VARCHAR(10);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET week_date = 
	CONCAT(
		CASE WHEN CAST(RIGHT(week_date, 2) AS INT) BETWEEN 0 AND 49 THEN '20' + RIGHT(week_date, 2) ELSE '19' + RIGHT(week_date, 2) END,
		'-',
		FORMAT(CAST(SUBSTRING(week_date, CHARINDEX('/', week_date, 0) + 1, CHARINDEX('/', week_date, CHARINDEX('/', week_date, 0) + 1) - CHARINDEX('/', week_date, 0) - 1) AS INT), '00'),
		'-',
		FORMAT(CAST(LEFT(week_date, CHARINDEX('/', week_date) - 1) AS INT), '00')
	);

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN week_date DATE;

GO
--	Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD week_number INT;

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET week_number = (DATEPART(dayofyear, week_date) - 1) / 7 + 1;

--	Add a month_number with the calendar month for each week_date value as the 3rd column.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD month_number INT;

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET month_number = MONTH(week_date);

GO
-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD year_number INT;

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET year_number = YEAR(week_date);

GO

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD
	region VARCHAR(13),
	platform VARCHAR(7),
	segment VARCHAR(4);

GO

UPDATE t1
SET
	t1.region = t2.region,
	t1.platform = t2.platform,
	t1.segment = t2.segment
FROM DataMartDBUI.dbo.clean_weekly_sales AS t1
INNER JOIN DataMartDBUI.dbo.weekly_sales AS t2
	ON t1.idx = t2.idx;

GO
-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD age_brand VARCHAR(12);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET age_brand =
	CASE
		WHEN RIGHT(segment, 1) = '1' THEN 'Young	Adults'
		WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
		WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
		ELSE 'null'
	END;

GO
-- Add a new demographic column using the following mapping for the first letter in the segment values.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD demographic VARCHAR(8);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET demographic =
	CASE
		WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
		WHEN LEFT(segment, 1) = 'F' THEN 'Families'
		ELSE 'null'
	END;

GO
-- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns.
ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ALTER COLUMN segment VARCHAR(7);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET
	segment = 'unknown',
	age_brand = 'unknown',
	demographic = 'unknown'
WHERE demographic LIKE 'null';

GO

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD
	customer_type VARCHAR(8),
	transactions BIGINT,
	sales BIGINT;

GO
-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record.

UPDATE t1
SET
	t1.customer_type = t2.customer_type,
	t1.transactions = t2.transactions,
	t1.sales = t2.sales
FROM DataMartDBUI.dbo.clean_weekly_sales AS t1
INNER JOIN DataMartDBUI.dbo.weekly_sales AS t2
	ON t1.idx = t2.idx;

GO

ALTER TABLE DataMartDBUI.dbo.clean_weekly_sales
ADD avg_transaction DECIMAL(5, 2);

GO

UPDATE DataMartDBUI.dbo.clean_weekly_sales
SET avg_transaction = CAST(sales AS FLOAT) / CAST(transactions AS FLOAT);

GO

SELECT *
FROM DataMartDBUI.dbo.clean_weekly_sales;