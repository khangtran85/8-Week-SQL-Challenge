USE FreshSegmentsDBUI;
GO

DROP VIEW IF EXISTS monthly_counts_by_interest_id_tb;
GO

CREATE VIEW monthly_counts_by_interest_id_tb AS
	SELECT
		interest_id,
		COUNT(month_year) AS total_months_each_interest_id
	FROM interest_metrics
	WHERE interest_id IS NOT NULL AND month_year IS NOT NULL
	GROUP BY interest_id;