USE PizzaRunnerDBUI;
GO
-- E. Bonus Questions
-- Question: If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
DELETE FROM PizzaRunnerDBUI.dbo.pizza_full_info
WHERE pizza_name = 'Supreme';

DECLARE @RowCount AS INT;
DECLARE @PizzaToppings AS VARCHAR(MAX);

SET @RowCount = (SELECT COUNT(*) FROM pizza_full_info);
SET @PizzaToppings = (SELECT STRING_AGG(topping_id, ',') FROM pizza_toppings);

INSERT INTO PizzaRunnerDBUI.dbo.pizza_full_info (pizza_id, pizza_name, toppings)
VALUES (@RowCount + 1, 'Supreme', @PizzaToppings);

SELECT *
FROM pizza_full_info;