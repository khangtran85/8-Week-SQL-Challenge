USE CliqueBaitDBUI;
GO
-- C. Campaigns Analysis
-- What metrics can you use to quantify the success or failure of each campaign compared to eachother?
WITH campaign_behavior_metrics_by_campaign_tb AS (
	SELECT
		'Total page views' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 THEN t1.page_views ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 THEN t1.page_views ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 THEN t1.page_views ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name

	UNION ALL

	SELECT
		'Total cart adds' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 THEN t1.cart_adds ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 THEN t1.cart_adds ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 THEN t1.cart_adds ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name

	UNION ALL

	SELECT
		'Total impressions' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 THEN t1.impression ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 THEN t1.impression ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 THEN t1.impression ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name

	UNION ALL

	SELECT
		'Total clicks' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 THEN t1.click ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 THEN t1.click ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 THEN t1.click ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name

	UNION ALL

	SELECT
		'Total purchases' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 AND t1.purchase = 1 THEN t1.cart_adds ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 AND t1.purchase = 1 THEN t1.cart_adds ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 AND t1.purchase = 1 THEN t1.cart_adds ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name

	UNION ALL

	SELECT
		'Total purchases with click' AS campaign_metrics,
		SUM(CASE WHEN t2.campaign_id = 1 AND t1.purchase = 1 AND t1.impression > 0 AND t1.click > 0 THEN t1.cart_adds ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN t2.campaign_id = 2 AND t1.purchase = 1 AND t1.impression > 0 AND t1.click > 0 THEN t1.cart_adds ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN t2.campaign_id = 3 AND t1.purchase = 1 AND t1.impression > 0 AND t1.click > 0 THEN t1.cart_adds ELSE 0 END) AS campaign_id_3
	FROM user_campaign_interaction_summary_tb AS t1
	INNER JOIN campaign_identifier AS t2
		ON t1.campaign_name = t2.campaign_name
),
campaign_target_product_flag_tb AS (
	SELECT
		t1.visit_id,
		t2.event_name,
		t3.product_id,
		t5.campaign_id,
		CASE
			WHEN t3.product_id >=	LEFT(t5.products, CHARINDEX('-', t5.products) - 1) AND t3.product_id <=	RIGHT(t5.products, LEN(t5.products) - CHARINDEX('-', t5.products)) THEN 1
			ELSE 0
		END target_product_id,
		t4.purchase
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	INNER JOIN page_hierarchy AS t3
		ON t1.page_id = t3.page_id
	INNER JOIN user_campaign_interaction_summary_tb AS t4
		ON t1.visit_id = t4.visit_id
	LEFT JOIN campaign_identifier AS t5
		ON t4.campaign_name = t5.campaign_name
	WHERE t3.product_id IS NOT NULL
),
campaign_target_product_purchase_tb AS (
	SELECT
		'Total target products' AS campaign_metrics,
		SUM(CASE WHEN campaign_id = 1 AND event_name = 'Add to Cart' AND target_product_id = 1 AND purchase = 1 THEN 1 ELSE 0 END) AS campaign_id_1,
		SUM(CASE WHEN campaign_id = 2 AND event_name = 'Add to Cart' AND target_product_id = 1 AND purchase = 1 THEN 1 ELSE 0 END) AS campaign_id_2,
		SUM(CASE WHEN campaign_id = 3 AND event_name = 'Add to Cart' AND target_product_id = 1 AND purchase = 1 THEN 1 ELSE 0 END) AS campaign_id_3
	FROM campaign_target_product_flag_tb
	WHERE campaign_id IS NOT NULL
),
campaign_behavior_rate_distribution_tb AS (
	SELECT
		'Page view rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total page views'

	UNION ALL

	SELECT
		'Cart add rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total cart adds'

	UNION ALL

	SELECT
		'Impressions rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total impressions'

	UNION ALL

	SELECT
		'Click rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total clicks'

	UNION ALL

	SELECT
		'Purchase rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total purchases'

	UNION ALL

	SELECT
		'Purchase with click rate' AS campaign_metrics,
		CAST(campaign_id_1 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_1,
		CAST(campaign_id_2 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_2,
		CAST(campaign_id_3 AS FLOAT) / CAST((campaign_id_1 + campaign_id_2 + campaign_id_3) AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb
	WHERE campaign_metrics = 'Total purchases with click'
),
campaign_conversion_rate_by_stage_tb AS (
	SELECT
		'View page to Add cart Conversion rate' AS campaign_metrics,
		CAST(t2.campaign_id_1 AS FLOAT) / CAST(t1.campaign_id_1 AS FLOAT) * 100 AS campaign_id_1,
		CAST(t2.campaign_id_2 AS FLOAT) / CAST(t1.campaign_id_2 AS FLOAT) * 100 AS campaign_id_2,
		CAST(t2.campaign_id_3 AS FLOAT) / CAST(t1.campaign_id_3 AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_campaign_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total cart adds'

	UNION ALL

	SELECT
		'View page to Purchase Conversion rate' AS campaign_metrics,
		CAST(t2.campaign_id_1 AS FLOAT) / CAST(t1.campaign_id_1 AS FLOAT) * 100 AS campaign_id_1,
		CAST(t2.campaign_id_2 AS FLOAT) / CAST(t1.campaign_id_2 AS FLOAT) * 100 AS campaign_id_2,
		CAST(t2.campaign_id_3 AS FLOAT) / CAST(t1.campaign_id_3 AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_campaign_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total purchases'

	UNION ALL

	SELECT
		'Cart add to Purchase Conversion rate' AS campaign_metrics,
		CAST(t2.campaign_id_1 AS FLOAT) / CAST(t1.campaign_id_1 AS FLOAT) * 100 AS campaign_id_1,
		CAST(t2.campaign_id_2 AS FLOAT) / CAST(t1.campaign_id_2 AS FLOAT) * 100 AS campaign_id_2,
		CAST(t2.campaign_id_3 AS FLOAT) / CAST(t1.campaign_id_3 AS FLOAT) * 100 AS campaign_id_3
	FROM campaign_behavior_metrics_by_campaign_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_campaign_tb AS t2
	WHERE t1.campaign_metrics = 'Total cart adds' AND t2.campaign_metrics = 'Total purchases'
)
SELECT
	campaign_metrics,
	ROUND(campaign_id_1, 2) AS campaign_id_1,
	ROUND(campaign_id_2, 2) AS campaign_id_2,
	ROUND(campaign_id_3, 2) AS campaign_id_3
FROM campaign_behavior_metrics_by_campaign_tb

UNION ALL

SELECT *
FROM campaign_target_product_purchase_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(campaign_id_1, 2) AS campaign_id_1,
	ROUND(campaign_id_2, 2) AS campaign_id_2,
	ROUND(campaign_id_3, 2) AS campaign_id_3
FROM campaign_behavior_rate_distribution_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(campaign_id_1, 2) AS campaign_id_1,
	ROUND(campaign_id_2, 2) AS campaign_id_2,
	ROUND(campaign_id_3, 2) AS campaign_id_3
FROM campaign_conversion_rate_by_stage_tb

UNION ALL

SELECT
	'Conversion rage Average' AS campaign_metrics,
	ROUND(AVG(campaign_id_1), 2) AS campaign_id_1,
	ROUND(AVG(campaign_id_2), 2) AS campaign_id_2,
	ROUND(AVG(campaign_id_3), 2) AS campaign_id_3
FROM campaign_conversion_rate_by_stage_tb;