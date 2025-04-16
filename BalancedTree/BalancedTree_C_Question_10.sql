USE BalancedTreeDBUI;
GO
-- C. Product Analysis
-- Question 10: What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
WITH product_transactions_with_counts_tb AS (
	SELECT
		t2.id,
		t1.prod_id,
		t1.txn_id,
		COUNT(t1.prod_id) OVER(PARTITION BY t1.txn_id) AS total_unique_prod_id
	FROM sales AS t1
	INNER JOIN product_prices AS t2
		ON t1.prod_id = t2.product_id
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