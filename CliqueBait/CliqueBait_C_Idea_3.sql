USE CliqueBaitDBUI;
GO
-- C. Campaigns Analysis
-- What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression?
WITH click_vs_no_impression_comparison_tb AS (
	SELECT
		'Visit with impression and clicking' AS visit_type,
		COUNT(CASE WHEN purchase = 1 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL AND impression > 0 AND click > 0

	UNION ALL

	SELECT
		'Visit with no impression' AS visit_type,
		COUNT(CASE WHEN purchase = 1 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL AND impression = 0
),
click_vs_no_impression_with_total_tb AS (
	SELECT
		*,
		total_purchases + total_no_purchases AS total_visits_in_campaign
	FROM click_vs_no_impression_comparison_tb
),
click_vs_no_impression_purchase_rate_tb AS (
	SELECT
		visit_type,
		ROUND(CAST(total_purchases AS FLOAT) / CAST(total_visits_in_campaign AS FLOAT) * 100, 2) AS purchase_rate,
		ROUND(CAST(total_no_purchases AS FLOAT) / CAST(total_visits_in_campaign AS FLOAT) * 100, 2) AS no_percentage_rate
	FROM click_vs_no_impression_with_total_tb
)
SELECT t2.purchase_rate - t1.no_percentage_rate AS uplift_in_purchase_rate
FROM click_vs_no_impression_purchase_rate_tb AS t1
CROSS JOIN click_vs_no_impression_purchase_rate_tb AS t2
WHERE t1.visit_type = 'Visit with no impression' AND t2.visit_type = 'Visit with impression and clicking';

GO
-- What if we compare them with users who just an impression but do not click?
WITH no_click_vs_impression_comparison_tb AS (
	SELECT
		'Visit with impression and clicking' AS visit_type,
		COUNT(CASE WHEN purchase = 1 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL AND impression > 0 AND click > 0

	UNION ALL

	SELECT
		'Visit with impression and no clicking' AS visit_type,
		COUNT(CASE WHEN purchase = 1 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL AND impression > 0 AND click = 0
),
no_click_vs_impression_with_total_tb AS (
	SELECT
		*,
		total_purchases + total_no_purchases AS total_visits_in_campaign
	FROM no_click_vs_impression_comparison_tb
),
no_click_vs_impression_purchase_rate_tb AS (
	SELECT
		visit_type,
		ROUND(CAST(total_purchases AS FLOAT) / CAST(total_visits_in_campaign AS FLOAT) * 100, 2) AS purchase_rate,
		ROUND(CAST(total_no_purchases AS FLOAT) / CAST(total_visits_in_campaign AS FLOAT) * 100, 2) AS no_percentage_rate
	FROM no_click_vs_impression_with_total_tb
)
SELECT t2.purchase_rate - t1.no_percentage_rate AS uplift_in_purchase_rate
FROM no_click_vs_impression_purchase_rate_tb AS t1
CROSS JOIN no_click_vs_impression_purchase_rate_tb AS t2
WHERE t1.visit_type = 'Visit with impression and no clicking' AND t2.visit_type = 'Visit with impression and clicking';