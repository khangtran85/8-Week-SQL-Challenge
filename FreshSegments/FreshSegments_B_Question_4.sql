USE FreshSegmentsDBUI;
GO
-- B. Interest Analysis
-- Question 4: Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.
SELECT
	DATETRUNC(month, CAST(created_at AS DATE)) AS created_at,
	COUNT(id) AS total_interest_id
FROM interest_map
GROUP BY DATETRUNC(month, CAST(created_at AS DATE))
ORDER BY created_at ASC;

--	Because the interest_ids are not created at the same time, and when considering the same time period, some interest_ids do not meet the 14-month requirement.
--	Removing them will result in a database containing only those interest_ids that were created during a specific time frame.
--	The decision to remove them depends on the purpose.
--	For example, if the goal is to analyze which interest_ids have been mentioned the most since the beginning, it makes sense to only consider interest_ids that fall within the same time frame.
--	In this case, removing those that do not meet the time requirement would be reasonable.