USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 2: How many cookies does each user have on average?
SELECT
	AVG(t1.total_cookie_ids) AS avg_cookie_id
FROM (
	SELECT
		user_id,
		COUNT(cookie_id) AS total_cookie_ids
	FROM users
	GROUP BY user_id
) AS t1;