USE PizzaRunnerDBUI;
GO
-- C. Ingredient Optimisation
-- Question 2: What was the most commonly added extra?
WITH non_null_extras_tb AS (
	SELECT CAST(extras AS NVARCHAR(MAX)) AS extras
	FROM customer_orders
	WHERE extras IS NOT NULL
),
ranking_added_extras_in_orders_tb AS (
	SELECT
		CAST(t3.topping_name AS VARCHAR(MAX)) AS topping_name,
		COUNT(t2.value) AS total_toppings,
		RANK() OVER(ORDER BY COUNT(t2.value) DESC) AS ranking
	FROM non_null_extras_tb AS t1
	CROSS APPLY STRING_SPLIT(t1.extras, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY CAST(t3.topping_name AS VARCHAR(MAX))
)
SELECT
	topping_name,
	total_toppings
FROM ranking_added_extras_in_orders_tb
WHERE ranking = 1;