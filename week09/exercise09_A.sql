-- Set role and schema
USE ROLE CHEETAH_DATA5035_ROLE;
USE SCHEMA DATA5035.CHEETAH;
/******************************************************************************
 * RETAIL DATA - SQL QUESTIONS
 ******************************************************************************/

-- Q1: Show all purchases with the customer who made them
-- Business Description: Show all purchases with the customer who made them
-- Columns Returned: customer name | order_id | amount
-- Notes: Only customers with orders


-- Q2: Show all customers and any orders they may have placed
-- Business Description: Show all customers and any orders they may have placed
-- Columns Returned: customer name | order_id
-- Notes: Include customers with no orders 


-- Q3: Identify whether each order was returned
-- Business Description: Identify whether each order was returned
-- Columns Returned: order_id | is_returned
-- Notes: Include all orders; flag TRUE/FALSE


-- Q4: Show only orders that were returned and who made them
-- Business Description: Show only orders that were returned and who made them
-- Columns Returned: customer name | order_id | return_date
-- Notes: Only returned orders 


-- Q5: Find customers who have never made a purchase
-- Business Description: Find customers who have never made a purchase
-- Columns Returned: customer name
-- Notes: Anti-join (customers without orders)

/******************************************************************************
 * SQL EXERCISES
******************************************************************************/

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    "name" VARCHAR NOT NULL,
    state VARCHAR
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS "returns" (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE
);

INSERT INTO customers VALUES
(1, 'Alice', 'MO'),
(2, 'Bob', 'IL'),
(3, 'Carol', 'TX');

INSERT INTO orders VALUES
(101, 1, '2024-01-01', 100),
(102, 1, '2024-01-05', 50),
(103, 2, '2024-01-03', 75);

INSERT INTO "returns" VALUES
(9001, 102, '2024-01-10');


-- Q1
-- INNER JOIN merges orders table to customers table so that we only get records with a match. Started with RIGHT JOIN, but this was easier to read..
SELECT c."name", o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Q2
-- Left Join orders table to customers table to get a full list of customers with or without any potential orders
SELECT c."name", o.order_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id;

-- Q3
-- Used INNER JOIN to match records from both tables at first, then a CASE statement to identify returned orders. Realized this should include ALL orders, so changed to LEFT JOIN.
SELECT o.order_id,
    CASE WHEN r.order_id IS NOT NULL THEN 'TRUE' ELSE 'FALSE' END AS is_returned
FROM orders o 
LEFT JOIN "returns" r ON r.order_id = o.order_id;

--Q4
-- Used INNER JOIN again to get the customers, returns, and orders. Due to the inclusion of this join, only returns were kept if they had a matching order, and only orders if they had a corresponding customer, so there was no need to filter with a CASE or WHERE clause
SELECT c."name", o.order_id, r.return_date
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN "returns" r ON r.order_id = o.order_id;

--Q5
-- Used a LEFT JOIN to only get customers who did not place an order. This effectively puts the customers on the right side of the join and then only selects where orders were null.
SELECT c."name"
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;