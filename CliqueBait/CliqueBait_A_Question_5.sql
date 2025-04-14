USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 5: What is the percentage of visits which have a purchase event?
WITH purchase_conversion_summary_tb AS (
	SELECT
		COUNT(CASE WHEN t2.event_name = 'Purchase' THEN t1.visit_id ELSE NULL END) AS total_purchase_events,
		COUNT(DISTINCT t1.visit_id) AS total_visits
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
)
SELECT
	total_purchase_events,
	ROUND((
		CAST(total_purchase_events AS FLOAT)
		/ CAST(total_visits AS FLOAT) * 100
	), 2) AS percentage_total_visits
FROM purchase_conversion_summary_tb;