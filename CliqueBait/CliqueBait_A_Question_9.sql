USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 9: What are the top 3 products by purchases?
WITH visit_id_with_purchased_list AS (
	SELECT DISTINCT t1.visit_id
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	WHERE t2.event_name = 'Purchase'
),
product_cart_additions_for_purchases_tb AS (
	SELECT
		t3.page_name AS product_name,
		COUNT(CASE WHEN t2.event_name = 'Add to Cart' THEN t1.visit_id ELSE NULL END) AS total_purchased_products
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	INNER JOIN page_hierarchy AS t3
		ON t1.page_id = t3.page_id
	WHERE
		t3.product_id IS NOT NULL
		AND t1.visit_id IN (SELECT visit_id FROM visit_id_with_purchased_list)
	GROUP BY t3.page_name
),
ranked_purchased_products_tb AS (
	SELECT
		product_name,
		total_purchased_products,
		DENSE_RANK() OVER(ORDER BY total_purchased_products DESC) AS ranking
	FROM product_cart_additions_for_purchases_tb
)
SELECT
	product_name,
	total_purchased_products
FROM ranked_purchased_products_tb
WHERE ranking <= 3
ORDER BY total_purchased_products DESC;