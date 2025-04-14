USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 4: What is the number of events for each event type?
SELECT
	t2.event_name,
	COUNT(t1.visit_id) AS total_events
FROM events AS t1
INNER JOIN event_identifier AS t2
	ON t1.event_type = t2.event_type
GROUP BY t2.event_name
ORDER BY total_events DESC;