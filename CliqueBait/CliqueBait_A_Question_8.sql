USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 8: What is the number of views and cart adds for each product category?
SELECT
	t3.product_category,
	COUNT(CASE WHEN t2.event_name = 'Page view' THEN t1.visit_id ELSE NULL END) AS total_views,
	COUNT(CASE WHEN t2.event_name = 'Add to Cart' THEN t1.visit_id ELSE NULL END) AS total_add_to_cart_times
FROM events AS t1
INNER JOIN event_identifier AS t2
	ON t1.event_type = t2.event_type
INNER JOIN page_hierarchy AS t3
	ON t1.page_id = t3.page_id
WHERE t3.product_category IS NOT NULL
GROUP BY t3.product_category