USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 6: What is the percentage of visits which view the checkout page but do not have a purchase event?
WITH visit_id_with_purchased_list AS (
	SELECT DISTINCT t1.visit_id
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	WHERE t2.event_name = 'Purchase'
),
checkout_no_purchase_visits_tb AS (
	SELECT COUNT(DISTINCT t1.visit_id) AS total_visits_with_view_checkout_page_but_not_purchaseing
	FROM events AS t1
	INNER JOIN event_identifier AS t2
		ON t1.event_type = t2.event_type
	INNER JOIN page_hierarchy AS t3
		ON t1.page_id = t3.page_id
	WHERE
		t2.event_name = 'Page View' AND t3.page_name = 'Checkout'
		AND t1.visit_id NOT IN (SELECT visit_id FROM visit_id_with_purchased_list)
),
total_distinct_visits_tb AS (
	SELECT COUNT(DISTINCT visit_id) AS total_visits
	FROM events
)
SELECT
	t1.total_visits_with_view_checkout_page_but_not_purchaseing,
	ROUND((
		CAST(t1.total_visits_with_view_checkout_page_but_not_purchaseing AS FLOAT)
		/ CAST(t2.total_visits AS FLOAT) * 100
	), 2) AS percentage_total_visits
FROM checkout_no_purchase_visits_tb AS t1
CROSS JOIN total_distinct_visits_tb AS t2;