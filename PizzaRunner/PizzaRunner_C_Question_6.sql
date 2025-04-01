USE PizzaRunnerDBUI;
GO
-- C. Ingredient Optimisation
-- Question 6: What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
WITH successfull_delivery_order_tb AS (
	SELECT t1.*
	FROM customer_orders AS t1
	INNER JOIN runner_orders AS t2
		ON t1.order_id = t2.order_id
	WHERE t2.cancellation IS NULL
),
standard_ingredients_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t3.value AS INT) AS topping_id
	FROM successfull_delivery_order_tb AS t1
	INNER JOIN pizza_full_info AS t2
		ON t1.pizza_id = t2.pizza_id
	CROSS APPLY STRING_SPLIT(t2.toppings, ',') AS t3
),
exclusions_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t2.value AS INT) AS topping_id
	FROM successfull_delivery_order_tb AS t1
	CROSS APPLY STRING_SPLIT(t1.exclusions, ',') AS t2
),
extras_pizza_order_tb AS (
	SELECT
		t1.order_number,
		CAST(t2.value AS INT) AS topping_id
	FROM successfull_delivery_order_tb AS t1
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
)
SELECT
	CAST(t2.topping_name AS VARCHAR(MAX)) AS topping_name,
	COUNT(t1.topping_id) AS total_toppings,
	DENSE_RANK() OVER(ORDER BY COUNT(t1.topping_id) DESC) AS ranking
FROM topping_details_pizza_order_tb AS t1
INNER JOIN pizza_toppings AS t2
	ON t1.topping_id = t2.topping_id
GROUP BY CAST(t2.topping_name AS VARCHAR(MAX));