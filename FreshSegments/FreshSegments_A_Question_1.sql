-- A. Data Exploration and Cleansing
-- Question 1: Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month.
ALTER TABLE FreshSegmentsDBUI.dbo.interest_metrics
ALTER COLUMN month_year VARCHAR(10);

UPDATE FreshSegmentsDBUI.dbo.interest_metrics
SET month_year = CONCAT(RIGHT(month_year, 4), '-', LEFT(month_year, 2), '-01')
WHERE month_year IS NOT NULL;

ALTER TABLE FreshSegmentsDBUI.dbo.interest_metrics
ALTER COLUMN month_year DATE;

ALTER TABLE FreshSegmentsDBUI.dbo.interest_map
ALTER COLUMN interest_name VARCHAR(MAX);

ALTER TABLE FreshSegmentsDBUI.dbo.interest_map
ALTER COLUMN interest_summary VARCHAR(MAX);