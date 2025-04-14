USE CliqueBaitDBUI;
GO
-- C. Product Funnel Analysis
-- Using a single SQL query - create a new output table which has the following details:
--	How many times was each product viewed?
--	How many times was each product added to cart?
--	How many times was each product added to a cart but not purchased (abandoned)?
--	How many times was each product purchased?
-- Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.
-- Use your 2 new output tables - answer the following questions:
--	Which product had the most views, cart adds and purchases?
--	Which product was most likely to be abandoned?
--	Which product had the highest view to purchase percentage?
--	What is the average conversion rate from view to cart add?
--	What is the average conversion rate from cart add to purchase?

-- Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.
DROP TABLE IF EXISTS CliqueBaitDBUI.dbo.product_category_conversion_funnel_tb;
WITH event_details_with_product_info_tb AS (
	SELECT
		visit_id,
		cookie_id,
		event_time,
		sequence_number,
		event_name,
		page_name,
		product_category,
		product_id
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	INNER JOIN page_hierarchy AS t3
		ON t1.page_id = t3.page_id
),
product_category_view_and_add_to_cart_times_tb AS (
SELECT
	product_category,
	COUNT(CASE WHEN event_name = 'Page view' THEN visit_id ELSE NULL END) AS total_views,
	COUNT(CASE WHEN event_name = 'Add to Cart' THEN visit_id ELSE NULL END) AS total_add_to_cart_times
FROM event_details_with_product_info_tb
WHERE product_id IS NOT NULL
GROUP BY product_category
),
visit_id_with_purchased_list AS (
	SELECT DISTINCT visit_id
	FROM event_details_with_product_info_tb
	WHERE event_name = 'Purchase'
),
product_category_add_to_cart_but_not_purchase_times_tb AS (
	SELECT
		product_category,
		COUNT(CASE WHEN event_name = 'Add to Cart' THEN visit_id ELSE NULL END) AS total_abandoned_times
	FROM event_details_with_product_info_tb
	WHERE
		product_id IS NOT NULL
		AND visit_id NOT IN (SELECT visit_id FROM visit_id_with_purchased_list)
	GROUP BY product_category
),
product_category_purchase_times_tb AS (
	SELECT
		product_category,
		COUNT(CASE WHEN event_name = 'Add to Cart' THEN visit_id ELSE NULL END) AS total_purchase_times
	FROM event_details_with_product_info_tb
	WHERE
		product_id IS NOT NULL
		AND visit_id IN (SELECT visit_id FROM visit_id_with_purchased_list)
	GROUP BY product_category
)
SELECT
	t1.product_category,
	t1.total_views,
	t1.total_add_to_cart_times,
	t2.total_abandoned_times,
	t3.total_purchase_times
INTO CliqueBaitDBUI.dbo.product_category_conversion_funnel_tb
FROM product_category_view_and_add_to_cart_times_tb AS t1
INNER JOIN product_category_add_to_cart_but_not_purchase_times_tb AS t2
	ON t1.product_category = t2.product_category
INNER JOIN product_category_purchase_times_tb AS t3
	ON t1.product_category = t3.product_category
ORDER BY t1.product_category ASC;