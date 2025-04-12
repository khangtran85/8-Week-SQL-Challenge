WITH LowCTE AS (
    SELECT 0 AS val, 0 AS idx
    UNION ALL
    SELECT val + 30, idx + 1
    FROM LowCTE
    WHERE val + 30 <= 150
),
UpCTE AS (
    SELECT 30 AS val, 0 AS idx
    UNION ALL
    SELECT val + 30, idx + 1
    FROM UpCTE
    WHERE val + 30 <= 180
)
SELECT
    l.val AS low,
    u.val AS up
FROM LowCTE l
JOIN UpCTE u ON l.idx = u.idx
OPTION (MAXRECURSION 100);