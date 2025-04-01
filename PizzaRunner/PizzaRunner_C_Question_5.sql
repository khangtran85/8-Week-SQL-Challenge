USE PizzaRunnerDBUI;
GO
-- C. Ingredient Optimisation
-- Question 5: Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--	For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
WITH standard_ingredients_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t3.value AS INT) AS topping_id
	FROM customer_orders AS t1
	INNER JOIN pizza_full_info AS t2
		ON t1.pizza_id = t2.pizza_id
	CROSS APPLY STRING_SPLIT(t2.toppings, ',') AS t3
),
exclusions_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t2.value AS INT) AS topping_id
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.exclusions, ',') AS t2
),
extras_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t2.value AS INT) AS topping_id
	FROM customer_orders AS t1
	CROSS APPLY STRING_SPLIT(t1.extras, ',') AS t2
),
combined_pizza_toppings_tb AS (
	SELECT *
	FROM standard_ingredients_pizza_order_tb
	UNION ALL
	SELECT *
	FROM extras_pizza_order_tb
),
topping_details_pizza_order_tb AS (
	SELECT
		t1.order_number,
		t1.topping_id
	FROM combined_pizza_toppings_tb AS t1
	WHERE NOT EXISTS (
			SELECT 1
			FROM exclusions_pizza_order_tb AS t2
			WHERE t2.order_number = t1.order_number
				AND t2.topping_id = t1.topping_id
	)
),
details_pizza_order_tb AS (
	SELECT
		t1.order_number,
		t3.pizza_name,
		CAST(t4.topping_name AS VARCHAR(MAX)) AS topping_name,
		CASE WHEN COUNT(t1.topping_id) = 2 THEN '2x' ELSE NULL END AS total_toppings
	FROM topping_details_pizza_order_tb AS t1
	INNER JOIN customer_orders AS t2
		ON t1.order_number = t2.order_number
	INNER JOIN pizza_full_info AS t3
		ON t2.pizza_id = t3.pizza_id
	INNER JOIN pizza_toppings AS t4
		ON t1.topping_id = t4.topping_id
	GROUP BY t1.order_number, t3.pizza_name, CAST(t4.topping_name AS VARCHAR(MAX))
)
SELECT
	order_number,
	CONCAT(
		pizza_name,
		': ',
		STRING_AGG(CONCAT(total_toppings, topping_name), ', ')
			WITHIN GROUP (ORDER BY topping_name ASC)
	) AS topping_details
FROM details_pizza_order_tb
GROUP BY order_number, pizza_name
ORDER BY order_number ASC;