USE BalancedTreeDBUI;
GO
-- D. Reporting Challenge
-- Question: Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.
-- Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.
-- He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).
-- Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)
DECLARE @StartReportDate AS DATE;
DECLARE @EndReportDate AS DATE;

SET @StartReportDate = '2021-01-01';
SET @EndReportDate = EOMONTH(@StartReportDate, 0);

-- A. Question 1: What was the total quantity sold for all products?
SELECT
	'Total Quantity' AS metrics,
	SUM(qty) AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL

-- A. Question 2: What is the total generated revenue for all products before discounts?
SELECT
	'Total Generated Revenue' AS metrics,
	SUM(qty * price) AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL

-- A. Question 3: What was the total discount amount for all products?
SELECT
	'Total Discount Amount' AS metrics,
	SUM(discount) AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2);

-- B. Question 1: How many unique transactions were there?
SELECT
	'Total Unique Transactions' AS metrics,
	COUNT(DISTINCT txn_id) AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL

-- B. Question 2: What is the average unique products purchased in each transaction?
SELECT
	'Average Unique Purchased Products' AS metrics,
	ROUND(AVG(CAST(t1.total_unique_purchased_products AS FLOAT)), 2) AS metric_value
FROM (
	SELECT
		txn_id,
		COUNT(DISTINCT prod_id) AS total_unique_purchased_products
	FROM sales
	WHERE
		start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY txn_id
) AS t1

UNION ALL

-- B. Question 3: What are the 25th, 50th and 75th percentile values for the revenue per transaction?
SELECT DISTINCT
	'_25th_percentile_for_revenue' AS metrics,
	PERCENTILE_CONT(0.25) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL

SELECT DISTINCT
	'_50th_percentile_for_revenue' AS metrics,
	PERCENTILE_CONT(0.5) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL

SELECT DISTINCT
	'_75th_percentile_for_revenue' AS metrics,
	PERCENTILE_CONT(0.75) 
		WITHIN GROUP (ORDER BY CAST((qty * price - discount) AS FLOAT) ASC)
		OVER() AS metric_value
FROM sales
WHERE
	start_txn_time >= CAST(@StartReportDate AS DATETIME2)
	AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)

UNION ALL
-- B. Question 4: What is the average discount value per transaction?
SELECT
	'Average Discount Value' AS metrics,
	ROUND(AVG(CAST(t1.total_discount AS FLOAT)), 2) AS metric_value
FROM (
	SELECT
		txn_id,
		SUM(discount) AS total_discount
	FROM sales
	WHERE
		start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY txn_id
) AS t1;

-- B. Question 5: What is the percentage split of all transactions for members vs non-members?
WITH transactions_per_member_tb AS (
	SELECT
		member,
		COUNT(DISTINCT txn_id) AS total_transactions,
		SUM(COUNT(DISTINCT txn_id)) OVER() AS total_transactions_all
	FROM sales
	WHERE
		start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY member
),
percentage_transactions_per_member_tb AS (
	SELECT
		CASE WHEN member = 't' THEN 'member' ELSE 'non-member' END AS member_status,
		ROUND(CAST(total_transactions AS FLOAT) / CAST(total_transactions_all AS FLOAT) * 100, 2) AS percentage_total_transactions
	FROM transactions_per_member_tb
),
-- B. Question 6: What is the average revenue for member transactions and non-member transactions?
member_avg_revenue_tb AS (
	SELECT
		member,
		AVG(CAST(qty AS FLOAT) * CAST(price AS FLOAT) - CAST(discount AS FLOAT)) AS avg_revenue
	FROM sales
	WHERE
		start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY member
),
member_status_avg_revenue_tb AS (
	SELECT
		CASE WHEN member = 't' THEN 'member' ELSE 'non-member' END AS member_status,
		ROUND(avg_revenue, 2) AS avg_revenue
	FROM member_avg_revenue_tb
)
SELECT
	t1.member_status,
	t1.percentage_total_transactions,
	t2.avg_revenue
FROM percentage_transactions_per_member_tb AS t1
INNER JOIN member_status_avg_revenue_tb AS t2
	ON t1.member_status = t2.member_status;

-- C. Question 1: What are the top 3 products by total revenue before discount?
WITH product_revenue_ranking AS (
	SELECT
		prod_id,
		SUM(qty * price) AS total_revenue_before_discount,
		DENSE_RANK() OVER(ORDER BY SUM(qty * price) DESC) AS ranking
	FROM sales
	WHERE
		start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY prod_id
)
SELECT
	t2.product_name,
	t1.total_revenue_before_discount
FROM product_revenue_ranking AS t1
INNER JOIN product_details AS t2
	ON t1.prod_id = t2.product_id
WHERE t1.ranking <= 3
ORDER BY t1.ranking ASC;

-- C. Question 2: What is the total quantity, revenue and discount for each segment?
SELECT
	'Segment' AS grouping_level,
	t2.segment_name AS group_name,
	SUM(t1.qty) AS total_quantity,
	SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
	SUM(t1.discount) AS total_discount
FROM sales AS t1
INNER JOIN product_details AS t2
	ON t1.prod_id = t2.product_id
WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
GROUP BY t2.segment_name

UNION ALL
-- C. Question 3: What is the total quantity, revenue and discount for each category?
SELECT
	'Category' AS grouping_level,
	t2.category_name AS group_name,
	SUM(t1.qty) AS total_quantity,
	SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
	SUM(t1.discount) AS total_discount
FROM sales AS t1
INNER JOIN product_details AS t2
	ON t1.prod_id = t2.product_id
WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
GROUP BY t2.category_name;

-- C. Question 3: What is the top selling product for each segment?
WITH segment_product_sales_ranking_tb AS (
	SELECT
		t2.segment_name,
		t2.product_name,
		SUM(t1.qty) AS total_quantity_sold,
		RANK()
			OVER(
				PARTITION BY t2.segment_name
				ORDER BY SUM(t1.qty) DESC
			) AS ranking
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.segment_name, t2.product_name
),
top_selling_product_segment_sales_ranking_tb AS (
	SELECT
		'Segment' AS grouping_level,
		segment_name AS group_name,
		product_name AS top_selling_product,
		total_quantity_sold
	FROM segment_product_sales_ranking_tb
	WHERE ranking = 1
),
-- C. Question 5: What is the top selling product for each category?
category_product_sales_ranking_tb AS (
	SELECT
		t2.category_name,
		t2.product_name,
		SUM(t1.qty) AS total_quantity_sold,
		RANK()
			OVER(
				PARTITION BY t2.category_name
				ORDER BY SUM(t1.qty) DESC
			) AS ranking
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.category_name, t2.product_name
),
top_selling_product_category_sales_ranking_tb AS (
	SELECT
		'Category' AS grouping_level,
		category_name AS group_name,
		product_name AS top_selling_product,
		total_quantity_sold
	FROM category_product_sales_ranking_tb
	WHERE ranking = 1
)
SELECT *
FROM top_selling_product_segment_sales_ranking_tb

UNION ALL

SELECT *
FROM top_selling_product_category_sales_ranking_tb
ORDER BY grouping_level ASC, top_selling_product DESC;

-- C. Question 6: What is the percentage split of revenue by product for each segment?
WITH segment_product_revenue_summary_tb AS (
	SELECT
		t2.segment_name,
		t2.product_name,
		SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
		SUM(SUM(t1.qty * t1.price - t1.discount)) OVER(PARTITION BY t2.segment_name) AS total_revenue_all
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.segment_name, t2.product_name
)
SELECT
	segment_name,
	product_name,
	total_revenue,
	ROUND(CAST(total_revenue AS FLOAT) / CAST(total_revenue_all AS FLOAT) * 100, 2) AS percentage_total_revenuve
FROM segment_product_revenue_summary_tb;

-- C. Question 7: What is the percentage split of revenue by segment for each category?
WITH segment_product_revenue_summary_tb AS (
	SELECT
		t2.category_name,
		t2.product_name,
		SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
		SUM(SUM(t1.qty * t1.price - t1.discount)) OVER(PARTITION BY t2.category_name) AS total_revenue_all
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.category_name, t2.product_name
)
SELECT
	category_name,
	product_name,
	total_revenue,
	ROUND(CAST(total_revenue AS FLOAT) / CAST(total_revenue_all AS FLOAT) * 100, 2) AS percentage_total_revenuve
FROM segment_product_revenue_summary_tb;

-- C. Question 8: What is the percentage split of total revenue by category?
WITH category_revenue_summary_tb AS (
	SELECT
		t2.category_name,
		SUM(t1.qty * t1.price - t1.discount) AS total_revenue,
		SUM(SUM(t1.qty * t1.price - t1.discount)) OVER() AS total_revenue_all
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.category_name
)
SELECT
	category_name,
	total_revenue,
	ROUND(CAST(total_revenue AS FLOAT) / CAST(total_revenue_all AS FLOAT) * 100, 2) AS percentage_total_revenue
FROM category_revenue_summary_tb;

-- C. Question 9: What is the total and percentage of transactions “penetration” for each product?
WITH product_transaction_count_tb AS (
	SELECT
		t2.product_name,
		COUNT(t1.txn_id) AS total_transactions
	FROM sales AS t1
	INNER JOIN product_details AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
	GROUP BY t2.product_name
)
SELECT
	product_name,
	total_transactions,
	ROUND(CAST(total_transactions AS FLOAT)
		/ CAST((SELECT COUNT(DISTINCT txn_id) FROM sales) AS FLOAT) * 100, 2)AS percentage_total_txn_penetration
FROM product_transaction_count_tb;

-- C. Question 10: What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
WITH product_transactions_with_counts_tb AS (
	SELECT
		t2.id,
		t1.prod_id,
		t1.txn_id,
		COUNT(t1.prod_id) OVER(PARTITION BY t1.txn_id) AS total_unique_prod_id
	FROM sales AS t1
	INNER JOIN product_prices AS t2
		ON t1.prod_id = t2.product_id
	WHERE
		t1.start_txn_time >= CAST(@StartReportDate AS DATETIME2)
		AND t1.start_txn_time <= CAST(@EndReportDate AS DATeTIME2)
),
cart_3_product_combinations_tb AS (
	SELECT
		t1.txn_id,
		CONCAT(t1.id, ',', t2.id, ',', t3.id) AS combination_3_id,
		CONCAT(t1.prod_id, ',', t2.prod_id, ',', t3.prod_id) AS combination_3_pro_id_in_cart
	FROM product_transactions_with_counts_tb AS t1
	INNER JOIN product_transactions_with_counts_tb AS t2
		ON t1.txn_id = t2.txn_id
		AND t1.id < t2.id
	INNER JOIN product_transactions_with_counts_tb AS t3
		ON t1.txn_id = t3.txn_id
		AND t2.id < t3.id
	WHERE t1.total_unique_prod_id >= 3
),
frequent_3_product_combinations_tb AS (
	SELECT
		combination_3_id,
		combination_3_pro_id_in_cart,
		COUNT(txn_id) AS frequency_combination,
		RANK() OVER(ORDER BY COUNT(txn_id) DESC) AS ranking
	FROM cart_3_product_combinations_tb
	GROUP BY combination_3_id, combination_3_pro_id_in_cart
)
SELECT
	DENSE_RANK() OVER(ORDER BY t1.combination_3_id ASC) AS combination_id,
	t2.value,
	t3.product_name,
	t1.frequency_combination
FROM frequent_3_product_combinations_tb AS t1
CROSS APPLY STRING_SPLIT(t1.combination_3_pro_id_in_cart, ',') AS t2
INNER JOIN product_details AS t3
	ON t2.value = t3.product_id
WHERE ranking = 1;