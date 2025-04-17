USE FreshSegmentsDBUI;
GO
-- A. Data Exploration and Cleansing
-- Question 7: Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?
SELECT
	t1.id,
	t1.interest_name,
	t1.created_at,
	t1.last_modified,
	t2.month_year
FROM interest_map AS t1
INNER JOIN interest_metrics AS t2
	ON t1.id = t2.interest_id
WHERE t1.created_at > CAST(t2.month_year AS DATETIME2)
ORDER BY month_year ASC;

--	These values may be acceptable, because the original month_year column does not clearly indicate the specific day of the month—it only shows that the data was calculated within that month, so we cannot be certain whether the actions occurred before the corresponding interest_id was created.
--	Additionally, as mentioned in question 1 of part A, the values were adjusted to the first day of the month, which may have unintentionally caused a discrepancy with the actual timeline.
--	However, if we assume that the interest_id entries in the interest_metrics table are aggregated at the beginning of the month by default, then these values would be invalid—since it's only possible to aggregate or analyze something that has already been defined and created.