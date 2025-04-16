USE BalancedTreeDBUI;
GO
-- E. Bonus Challenge
-- Question: Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.
--	Hint: you may want to consider using a recursive CTE to solve this problem!
DROP TABLE IF EXISTS BalancedTreeDBUI.dbo.product_details_transformed;
SELECT
	t1.product_id,
	t1.price,
	CONCAT(t2.level_text, ' ', t3.level_text, ' - ', t4.level_text) AS product_name,
	t4.id AS category_id,
	t3.id AS segment_id,
	t2.id AS style_id,
	t4.level_text AS category_name,
	t3.level_text AS segment_name,
	t2.level_text AS style_name
INTO BalancedTreeDBUI.dbo.product_details_transformed
FROM product_prices AS t1
INNER JOIN product_hierarchy AS t2
	ON t1.id = t2.id
INNER JOIN product_hierarchy AS t3
	ON t2.parent_id = t3.id
INNER JOIN product_hierarchy AS t4
	ON t3.parent_id = t4.id
ORDER BY category_id ASC, segment_id ASC, style_id ASC;

SELECT *
FROM product_details

EXCEPT

SELECT *
FROM product_details_transformed;