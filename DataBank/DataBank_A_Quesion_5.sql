USE DataBankDBUI;
GO
-- A. Customer Nodes Exploration
-- Question 5: What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
SELECT DISTINCT
	t2.region_name,
	PERCENTILE_DISC(0.5)
		WITHIN GROUP (ORDER BY (DATEDIFF(day, t1.start_date, t1.end_date) + 1) ASC)
		OVER(PARTITION BY t2.region_name) AS median_of_days_to_reallocate,
	PERCENTILE_DISC(0.80)
		WITHIN GROUP (ORDER BY (DATEDIFF(day, t1.start_date, t1.end_date) + 1) ASC)
		OVER(PARTITION BY t2.region_name) AS _80th_percentile_of_days_to_reallocate,
	PERCENTILE_DISC(0.95)
		WITHIN GROUP (ORDER BY (DATEDIFF(day, t1.start_date, t1.end_date) + 1) ASC)
		OVER(PARTITION BY t2.region_name) AS _95th_percentile_of_days_to_reallocate
FROM customer_nodes AS t1
INNER JOIN regions AS t2
	ON t1.region_id = t2.region_id
WHERE t1.end_date <> '9999-12-31'
ORDER BY region_name ASC;