USE PizzaRunnerDBUI;
GO
-- C. Ingredient Optimisation
-- Question 3: What was the most common exclusion?
WITH non_null_exclusion_tb AS (
	SELECT CAST(exclusions AS NVARCHAR(MAX)) AS exclusion
	FROM customer_orders
	WHERE exclusions IS NOT NULL
),
ranking_exclusion_in_orders_tb AS (
	SELECT
		CAST(t3.topping_name AS VARCHAR(MAX)) AS topping_name,
		COUNT(t2.value) AS total_toppings,
		RANK() OVER(ORDER BY COUNT(t2.value) DESC) AS ranking
	FROM non_null_exclusion_tb AS t1
	CROSS APPLY STRING_SPLIT(t1.exclusion, ',') AS t2
	INNER JOIN pizza_toppings AS t3
		ON CAST(t2.value AS INT) = t3.topping_id
	GROUP BY CAST(t3.topping_name AS VARCHAR(MAX))
)
SELECT
	topping_name,
	total_toppings
FROM ranking_exclusion_in_orders_tb
WHERE ranking = 1;