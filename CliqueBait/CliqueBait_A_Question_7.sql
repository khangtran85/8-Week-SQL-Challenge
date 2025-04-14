USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 7: What are the top 3 pages by number of views?
WITH page_visit_ranking_tb AS (
	SELECT
		t2.page_name,
		COUNT(t1.visit_id) AS total_visits,
		DENSE_RANK() OVER(ORDER BY COUNT(t1.visit_id) DESC) AS ranking
	FROM events AS t1
	INNER JOIN page_hierarchy AS t2
		ON t1.page_id = t2.page_id
	GROUP BY t2.page_name
)
SELECT
	page_name,
	total_visits
FROM page_visit_ranking_tb
WHERE ranking <= 3
ORDER BY total_visits DESC;