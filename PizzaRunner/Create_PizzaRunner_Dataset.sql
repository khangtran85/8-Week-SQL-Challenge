-- Don't execute one more time!
DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.customer_orders;
CREATE TABLE PizzaRunnerDBUI.dbo.customer_orders (
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions VARCHAR(4),
	extras VARCHAR(4),
	order_time DATETIME2(0)
);

ALTER TABLE PizzaRunnerDBUI.dbo.customer_orders
ADD order_number INT IDENTITY(1, 1);

INSERT INTO PizzaRunnerDBUI.dbo.customer_orders
	(order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
	('1', '101', '1', '', '', '2020-01-01 18:05:02'),
	('2', '101', '1', '', '', '2020-01-01 19:00:52'),
	('3', '102', '1', '', '', '2020-01-02 23:51:23'),
	('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
	('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
	('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
	('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
	('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
	('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
	('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
	('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
	('9', '103', '1', '4', '1,5', '2020-01-10 11:22:59'),
	('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
	('10', '104', '1', '2,6', '1,4', '2020-01-11 18:34:49');

-- Update table from Database
-- Update 'exclusions' columns from 'customer_orders' table
UPDATE PizzaRunnerDBUI.dbo.customer_orders
SET exclusions = NULL
WHERE exclusions = '' OR exclusions = 'null';
-- Update 'extras' columns from 'customer_orders' table
UPDATE PizzaRunnerDBUI.dbo.customer_orders
SET extras = NULL
WHERE extras = '' OR extras = 'null';

DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.runner_orders;
CREATE TABLE PizzaRunnerDBUI.dbo.runner_orders (
	order_id INT,
	runner_id INT,
	pickup_time VARCHAR(19),
	distance VARCHAR(7),
	duration VARCHAR(10),
	cancellation VARCHAR(23)
);
INSERT INTO PizzaRunnerDBUI.dbo.runner_orders
	(order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
	('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
	('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
	('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
	('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
	('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
	('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
	('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
	('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
	('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
	('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

-- Update 'pickup_time' columns from 'runner_orders' table
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET
	pickup_time = NULL,
	distance = NULL,
	duration = NULL
WHERE pickup_time = 'null';

ALTER TABLE PizzaRunnerDBUI.dbo.runner_orders
ALTER COLUMN pickup_time DATETIME2(0);

-- Update 'distance' columns from 'runner_orders' table
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET distance = LEFT(distance, CHARINDEX(' ', distance) - 1)
WHERE distance LIKE '% km';
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET distance = LEFT(distance, CHARINDEX('k', distance) - 1)
WHERE distance LIKE '%km';

ALTER TABLE PizzaRunnerDBUI.dbo.runner_orders
ALTER COLUMN distance FLOAT;
-- Update 'duration' columns from 'runner_orders' table
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET duration = LEFT(duration, CHARINDEX(' ', duration) - 1)
WHERE duration LIKE '% m%';
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET duration = LEFT(duration, CHARINDEX('m', duration) - 1)
WHERE duration LIKE '%m%';

ALTER TABLE PizzaRunnerDBUI.dbo.runner_orders
ALTER COLUMN duration FLOAT;
-- Update 'cancellation' columns from 'runner_orders' table
UPDATE PizzaRunnerDBUI.dbo.runner_orders
SET cancellation = NULL
WHERE cancellation = '' OR cancellation = 'null';

DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.pizza_names;
CREATE TABLE PizzaRunnerDBUI.dbo.pizza_names (
	pizza_id INT PRIMARY KEY,
	pizza_name TEXT
);
INSERT INTO PizzaRunnerDBUI.dbo.pizza_names
	(pizza_id, pizza_name)
VALUES
	('1', 'Meatlovers'),
	('2', 'Vegetarian');

DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.pizza_recipes;
CREATE TABLE PizzaRunnerDBUI.dbo.pizza_recipes (
	pizza_id INT PRIMARY KEY,
	toppings TEXT
);
INSERT INTO PizzaRunnerDBUI.dbo.pizza_recipes
	(pizza_id, toppings)
VALUES
	('1', '1,2,3,4,5,6,8,10'),
	('2', '4,6,7,9,11,12');

DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.pizza_toppings;
CREATE TABLE PizzaRunnerDBUI.dbo.pizza_toppings (
	topping_id INT,
	topping_name TEXT
);
INSERT INTO PizzaRunnerDBUI.dbo.pizza_toppings
	(topping_id, topping_name)
VALUES
	('1', 'Bacon'),
	('2', 'BBQ Sauce'),
	('3', 'Beef'),
	('4', 'Cheese'),
	('5', 'Chicken'),
	('6', 'Mushrooms'),
	('7', 'Onions'),
	('8', 'Pepperoni'),
	('9', 'Peppers'),
	('10', 'Salami'),
	('11', 'Tomatoes'),
	('12', 'Tomato Sauce');

DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.runners;
CREATE TABLE PizzaRunnerDBUI.dbo.runners (
	runner_id INT PRIMARY KEY,
	registration_date DATE
);
INSERT INTO PizzaRunnerDBUI.dbo.runners
	(runner_id, registration_date)
VALUES
	('1', '2021-01-01'),
	('2', '2021-01-03'),
	('3', '2021-01-08'),
	('4', '2021-01-15');

-- Set up constraint
DROP TABLE IF EXISTS PizzaRunnerDBUI.dbo.pizza_full_info;
SELECT
	t1.pizza_id,
	t1.pizza_name,
	t2.toppings
INTO PizzaRunnerDBUI.dbo.pizza_full_info
FROM PizzaRunnerDBUI.dbo.pizza_names AS t1
INNER JOIN PizzaRunnerDBUI.dbo.pizza_recipes AS t2
	ON t1.pizza_id = t2.pizza_id;

DROP TABLE PizzaRunnerDBUI.dbo.pizza_names;
DROP TABLE PizzaRunnerDBUI.dbo.pizza_recipes;

ALTER TABLE PizzaRunnerDBUI.dbo.pizza_full_info
ADD CONSTRAINT PK_pizza_full_info PRIMARY KEY (pizza_id);

ALTER TABLE PizzaRunnerDBUI.dbo.pizza_full_info
ALTER COLUMN pizza_name VARCHAR(MAX);

ALTER TABLE PizzaRunnerDBUI.dbo.pizza_full_info
ALTER COLUMN toppings VARCHAR(MAX);

ALTER TABLE PizzaRunnerDBUI.dbo.customer_orders
ADD CONSTRAINT FK_customer_orders_pizza_full_info_pizza_id FOREIGN KEY (pizza_id) REFERENCES pizza_full_info(pizza_id);

ALTER TABLE PizzaRunnerDBUI.dbo.customer_orders
ADD CONSTRAINT PK_customer_orders PRIMARY KEY (order_number);

ALTER TABLE PizzaRunnerDBUI.dbo.runner_orders
ADD CONSTRAINT FK_runner_orders_runners_runner_id FOREIGN KEY (runner_id) REFERENCES runners(runner_id);

ALTER TABLE PizzaRunnerDBUI.dbo.runner_orders
ADD CONSTRAINT FK_runner_orders_customer_orders_order_id FOREIGN KEY (order_id) REFERENCES customer_orders(order_id);