USE CliqueBaitDBUI;
GO
-- C. Campaigns Analysis
-- Generate a table that has 1 single row for every unique visit_id record and has the following columns:
--	user_id
--	visit_id
--	visit_start_time: the earliest event_time for each visit
--	page_views: count of page views for each visit
--	cart_adds: count of product cart add events for each visit
--	purchase: 1/0 flag if a purchase event exists for each visit
--	campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
--	impression: count of ad impressions for each visit
--	click: count of ad clicks for each visit
--	(Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)
DROP TABLE IF EXISTS CliqueBaitDBUI.dbo.user_campaign_interaction_summary_tb;
WITH detailed_user_event_log_tb AS (
	SELECT
		t1.visit_id,
		t2.user_id,
		t1.sequence_number,
		t1.event_time,
		t3.event_name,
		t4.page_name,
		t4.product_category,
		t4.product_id
	FROM events AS t1
	INNER JOIN users AS t2
		ON t1.cookie_id = t2.cookie_id
	INNER JOIN event_identifier AS t3
		ON t1.event_type = t3.event_type
	INNER JOIN page_hierarchy AS t4
		ON t1.page_id = t4.page_id
),
user_session_interactions_tb AS (
	SELECT
		user_id,
		visit_id,
		COUNT(CASE WHEN event_name = 'Page view' THEN visit_id ELSE NULL END) AS page_views,
		COUNT(CASE WHEN event_name = 'Add to Cart' THEN visit_id ELSE NULL END) AS cart_adds,
		COUNT(CASE WHEN event_name = 'Ad Impression' THEN visit_id ELSE NULL END) AS impression,
		COUNT(CASE WHEN event_name = 'Ad Click' THEN visit_id ELSE NULL END) AS click,
		STRING_AGG(CASE WHEN event_name = 'Add to Cart' THEN product_id ELSE NULL END, ',')
			WITHIN GROUP (ORDER BY sequence_number ASC) AS cart_products
	FROM detailed_user_event_log_tb
	GROUP BY user_id, visit_id
),
visit_id_with_purchased_list AS (
	SELECT DISTINCT visit_id
	FROM detailed_user_event_log_tb
	WHERE event_name = 'Purchase'
),
visit_start_and_purchase_flag_tb AS (
	SELECT DISTINCT
		visit_id,
		FIRST_VALUE(event_time)
			OVER(
				PARTITION BY visit_id
				ORDER BY event_time ASC
				) AS visit_start_time,
		CASE WHEN visit_id IN (SELECT visit_id FROM visit_id_with_purchased_list) THEN 1 ELSE 0 END AS purchase
	FROM detailed_user_event_log_tb
),
campaign_details_tb AS (
	SELECT
		campaign_id,
		LEFT(products, CHARINDEX('-', products) - 1) AS product_id_start,
		RIGHT(products, LEN(products) - CHARINDEX('-', products)) AS product_id_end,
		campaign_name,
		CAST(start_date AS DATETIME2) AS start_date,
		CAST(end_date AS DATETIME2) AS end_date
	FROM campaign_identifier
),
visit_campaign_mapping_tb AS (
	SELECT
		t1.visit_id,
		t1.visit_start_time,
		t2.campaign_name,
		t1.purchase
	FROM visit_start_and_purchase_flag_tb AS t1
	LEFT JOIN campaign_details_tb AS t2
		ON t1.visit_start_time >= t2.start_date
		AND t1.visit_start_time <= t2.end_date
)
SELECT
	t1.user_id,
	t1.visit_id,
	t2.visit_start_time,
	t1.page_views,
	t1.cart_adds,
	t2.purchase,
	t2.campaign_name,
	t1.impression,
	t1.click,
	t1.cart_products
INTO CliqueBaitDBUI.dbo.user_campaign_interaction_summary_tb
FROM user_session_interactions_tb AS t1
INNER JOIN visit_campaign_mapping_tb AS t2
	ON t1.visit_id = t2.visit_id
ORDER BY t1.user_id ASC, t1.visit_id ASC;