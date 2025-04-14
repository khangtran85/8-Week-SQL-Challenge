USE CliqueBaitDBUI;
Go
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

-- Use your 2 new output tables - answer the following questions:
--	Which product had the most views, cart adds and purchases?
WITH product_conversion_funnel_with_rankings_tb AS (
	SELECT
		product_name,
		total_views,
		RANK() OVER(ORDER BY total_views DESC) AS total_views_ranking,
		total_add_to_cart_times,
		RANK() OVER(ORDER BY total_add_to_cart_times DESC) AS total_add_to_cart_times_ranking,
		total_purchase_times,
		RANK() OVER(ORDER BY total_purchase_times DESC) AS total_purchase_times_ranking
	FROM product_conversion_funnel_tb
)
SELECT
	'Most views' AS dominant_conversion_stage,
	product_name,
	total_views AS total_times
FROM product_conversion_funnel_with_rankings_tb
WHERE total_views_ranking = 1

UNION ALL

SELECT
	'Most cart adds' AS dominant_conversion_stage,
	product_name,
	total_add_to_cart_times AS total_times
FROM product_conversion_funnel_with_rankings_tb
WHERE total_add_to_cart_times_ranking = 1

UNION ALL

SELECT
	'Most purchases' AS dominant_conversion_stage,
	product_name,
	total_purchase_times AS total_times
FROM product_conversion_funnel_with_rankings_tb
WHERE total_purchase_times_ranking = 1;