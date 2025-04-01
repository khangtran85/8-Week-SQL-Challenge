USE PizzaRunnerDBUI;
-- C. Ingredient Optimisation
-- Question 4: Generate an order item for each record in the customers_orders table in the format of one of the following:
--	Meat Lovers
--	Meat Lovers - Exclude Beef
--	Meat Lovers - Extra Bacon
--	Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
IF EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'customer_orders' AND COLUMN_NAME = 'order_details'
)
BEGIN
    ALTER TABLE customer_orders
		DROP COLUMN order_details
END;

ALTER TABLE customer_orders
ADD order_details NVARCHAR(MAX);

GO

WITH order_exclusions_tb AS (
	SELECT
		t1.order_number,
		CONCAT('Exclude ', STRING_AGG(CAST(t3.topping_name AS VARCHAR(MAX)), ', ')) AS toppings_name_exclusions
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.exclusions, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY t1.order_number
),
order_extras_tb AS (
	SELECT
		t1.order_number,
		CONCAT('Extra ', STRING_AGG(CAST(t3.topping_name AS VARCHAR(MAX)), ', ')) AS toppings_name_extras
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.extras, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY t1.order_number
)
UPDATE customer_orders
SET customer_orders.order_details = order_details_tb.order_details
FROM (
	SELECT
		t1.order_number,
		t1.order_id,
		t1.customer_id,
		CONCAT_WS(' - ', t2.pizza_name, t3.toppings_name_exclusions, t4.toppings_name_extras) AS order_details
	FROM customer_orders AS t1
	INNER JOIN pizza_full_info AS t2
		ON t1.pizza_id = t2.pizza_id
	LEFT JOIN order_exclusions_tb AS t3
		ON t1.order_number = t3.order_number
	LEFT JOIN order_extras_tb AS t4
		ON t1.order_number = t4.order_number
) AS order_details_tb
WHERE customer_orders.order_number = order_details_tb.order_number;