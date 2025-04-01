USE PizzaRunnerDBUI;
-- D. Pricing and Ratings
-- Question 3: The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS runner_ratings;

SELECT DISTINCT
	t1.order_id,
	t1.runner_id,
	t2.customer_id,
	t1.duration AS delivery_time,
	DATEADD(minute, t1.duration, t1.pickup_time) AS time_of_receipt
INTO runner_ratings
FROM runner_orders AS t1
INNER JOIN customer_orders AS t2
	ON t1.order_id = t2.order_id
WHERE t1.cancellation IS NULL;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'runner_ratings' AND COLUMN_NAME = 'rating'
)
BEGIN
	ALTER TABLE runner_ratings
	DROP COLUMN rating
END;

ALTER TABLE runner_ratings
ADD rating TINYINT NULL;

DECLARE @RowCount AS INT;
DECLARE @Counter AS INT;

SET @RowCount = (SELECT COUNT(*) FROM runner_ratings);
SET @Counter = 1;

WHILE @Counter <= @RowCount
	BEGIN
		UPDATE runner_ratings
		SET rating = ABS(CHECKSUM(NEWID()) % 5) + 1
		WHERE rating IS NULL;
		SET @Counter = @Counter + 1;
	END;

SELECT *
FROM runner_ratings;