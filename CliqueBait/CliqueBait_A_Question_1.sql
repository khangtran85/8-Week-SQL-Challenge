USE CliqueBaitDBUI;
GO
-- B. Digital Analysis
-- Question 1: How many users are there?
SELECT COUNT(DISTINCT user_id) AS total_users
FROM users;