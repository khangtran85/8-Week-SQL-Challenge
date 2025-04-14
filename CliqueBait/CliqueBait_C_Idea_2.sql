USE CliqueBaitDBUI;
GO
-- C. Campaigns Analysis
-- Does clicking on an impression lead to higher purchase rates?
WITH visit_clicking_comparison_tb AS (
	SELECT
		'Visit with clicking' AS visit_type,
		COUNT(CASE WHEN purchase = 1 AND click > 0 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 AND click > 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL

	UNION ALL

	SELECT
		'Visit with no clicking' AS visit_type,
		COUNT(CASE WHEN purchase = 1 AND click = 0 THEN visit_id ELSE NULL END) AS total_purchases,
		COUNT(CASE WHEN purchase = 0 AND click = 0 THEN visit_id ELSE NULL END) AS total_no_purchases
	FROM user_campaign_interaction_summary_tb
	WHERE campaign_name IS NOT NULL
),
visit_clicking_with_totals_tb AS (
	SELECT
		*,
		total_purchases + total_no_purchases AS total_visits
	FROM visit_clicking_comparison_tb
)
SELECT
	visit_type,
	ROUND(CAST(total_purchases AS FLOAT) / CAST(total_visits AS FLOAT) * 100, 2) AS purchase_rate,
	ROUND(CAST(total_no_purchases AS FLOAT) / CAST(total_visits AS FLOAT) * 100, 2) AS no_purchase_rate
FROM visit_clicking_with_totals_tb;