USE CliqueBaitDBUI;
GO
-- C. Campaigns Analysis
-- Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event.
WITH campaign_behavior_metrics_by_impression_tb AS (
	SELECT
		'Total page views' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 THEN page_views ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 THEN page_views ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb

	UNION ALL

	SELECT
		'Total cart adds' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 THEN cart_adds ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 THEN cart_adds ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb

	UNION ALL

	SELECT
		'Total purchases' AS campaign_metrics,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression > 0 AND purchase = 1 THEN cart_adds ELSE 0 END) AS visit_received_impression_gp,
		SUM(CASE WHEN campaign_name IS NOT NULL AND impression = 0 AND purchase = 1THEN cart_adds ELSE 0 END) AS visit_no_received_impression_gp
	FROM user_campaign_interaction_summary_tb
),
purchase_rate_by_impression_group_tb AS (
	SELECT
		'Purchase rate' AS campaign_metrics,
		CAST(visit_received_impression_gp AS FLOAT) / CAST((visit_received_impression_gp + visit_no_received_impression_gp) AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(visit_no_received_impression_gp AS FLOAT) / CAST((visit_received_impression_gp + visit_no_received_impression_gp) AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb
	WHERE campaign_metrics = 'Total purchases'
),
campaign_conversion_rate_by_impression_tb AS (
	SELECT
		'View page to Add cart Conversion rate' AS campaign_metrics,
		CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total cart adds'

	UNION ALL

	SELECT
		'View page to Purchase Conversion rate' AS campaign_metrics,
		ROUND(CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100, 2) AS visit_received_impression_gp,
		ROUND(CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100, 2) AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total page views' AND t2.campaign_metrics = 'Total purchases'

	UNION ALL

	SELECT
		'Add cart to Purchase Conversion rate' AS campaign_metrics,
		CAST(t2.visit_received_impression_gp AS FLOAT) / CAST(t1.visit_received_impression_gp AS FLOAT) * 100 AS visit_received_impression_gp,
		CAST(t2.visit_no_received_impression_gp AS FLOAT) / CAST(t1.visit_no_received_impression_gp AS FLOAT) * 100 AS visit_no_received_impression_gp
	FROM campaign_behavior_metrics_by_impression_tb AS t1
	CROSS JOIN campaign_behavior_metrics_by_impression_tb AS t2
	WHERE t1.campaign_metrics = 'Total cart adds' AND t2.campaign_metrics = 'Total purchases'
),
avg_campaign_conversion_rate_by_impression_tb AS (
	SELECT
		'Conversion rate Average' AS campaign_metrics,
		AVG(visit_received_impression_gp) AS visit_received_impression_gp,
		AVG(visit_no_received_impression_gp) AS visit_no_received_impression_gp
	FROM campaign_conversion_rate_by_impression_tb
)
SELECT *
FROM campaign_behavior_metrics_by_impression_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(visit_received_impression_gp, 2) AS visit_received_impression_gp,
	ROUND(visit_no_received_impression_gp, 2) AS visit_no_received_impression_gp
FROM purchase_rate_by_impression_group_tb

UNION ALL

SELECT
	campaign_metrics,
	ROUND(visit_received_impression_gp, 2) AS visit_received_impression_gp,
	ROUND(visit_no_received_impression_gp, 2) AS visit_no_received_impression_gp
FROM campaign_conversion_rate_by_impression_tb;