
/******************************************************************************
 * SQL Questions
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
    "name" VARCHAR NOT NULL
    state VARCHAR
)

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
)

CREATE TABLE IF NOT EXISTS "returns" (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE
)

INSERT INTO customers VALUES
(1, 'Alice', 'MO'),
(2, 'Bob', 'IL'),
(3, 'Carol', 'TX')

INSERT INTO orders VALUES
(101, 1, '2024-01-01', 100),
(102, 1, '2024-01-05', 50),
(103, 2, '2024-01-03', 75)

INSERT INTO "returns" VALUES
(9001, 102, '2024-01-10')