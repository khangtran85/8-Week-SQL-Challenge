USE PizzaRunnerDBUI;
GO
-- C: Ingredient Optimisation
-- Question 1: What are the standard ingredients for each pizza?
WITH standard_toppings_per_pizza_tb AS (
	SELECT
		t1.pizza_name,
		CAST(t2.value AS INT) AS topping_id
	FROM pizza_full_info AS t1
	CROSS APPLY STRING_SPLIT(t1.toppings, ',') AS t2
)
SELECT
	t1.pizza_name,
	STRING_AGG(CAST(t2.topping_name AS VARCHAR(MAX)), ', ') AS standard_ingredients
FROM standard_toppings_per_pizza_tb AS t1
INNER JOIN pizza_toppings AS t2
	ON t1.topping_id = t2.topping_id
GROUP BY t1.pizza_name
ORDER BY t1.pizza_name ASC;