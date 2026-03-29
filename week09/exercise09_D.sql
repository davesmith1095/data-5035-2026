/******************************************************************************
 * CAMPAIGN & MARKETING - SQL EXERCISES
 ******************************************************************************/

-- Q1: Show all campaign sends with customer emails
-- Business Description: Show all campaign sends with customer emails
-- Columns Returned: email | campaign_id | send_date
-- Notes: Only sends that exist 


-- Q2: Identify whether each campaign send resulted in a click
-- Business Description: Identify whether each campaign send resulted in a click
-- Columns Returned: send_id | clicked
-- Notes: Include all sends; flag TRUE/FALSE


-- Q3: Show all customers and any campaigns they received
-- Business Description: Show all customers and any campaigns they received
-- Columns Returned: email | campaign_id
-- Notes: Include customers with no sends 


-- Q4: Find campaign sends that were never clicked
-- Business Description: Find campaign sends that were never clicked
-- Columns Returned: send_id
-- Notes: Anti-join (sends without clicks)


-- Q5: Find customers who have never received a campaign
-- Business Description: Find customers who have never received a campaign
-- Columns Returned: email
-- Notes: Anti-join (customers without sends)

/******************************************************************************
 * SQL EXERCISES
 ******************************************************************************/
 
 -- Set role and schema
USE ROLE CHEETAH_DATA5035_ROLE;
USE SCHEMA DATA5035.CHEETAH;

-- Opted for Create or Replace because I already had a customers table

CREATE OR REPLACE TABLE customers (
    customer_id INT PRIMARY KEY,
    email VARCHAR(255)
);
 CREATE OR REPLACE TABLE campaign_sends (
    send_id VARCHAR PRIMARY KEY,
    customer_id INT,
    campaign_id VARCHAR,
    send_date DATE
);

CREATE OR REPLACE TABLE clicks (
    click_id VARCHAR PRIMARY KEY,
    send_id VARCHAR,
    click_date DATE
);

INSERT INTO customers (customer_id, email) VALUES 
    (1, 'a@email.com'),
    (2, 'b@email.com'), 
    (3, 'c@email.com');

INSERT INTO campaign_sends (send_id, customer_id, campaign_id, send_date) VALUES 
    ('S1', 1, 'C1', '2024-01-01'),
    ('S2', 2, 'C1', '2024-01-01'),
    ('S3', 1, 'C2', '2024-02-01');

INSERT INTO clicks (click_id, send_id, click_date) VALUES 
    ('CL1', 'S1', '2024-01-02');

-- Q1
-- Went with INNER JOIN so that only sends with matching customers showed.
SELECT c.email, cs.campaign_id, cs.send_date
FROM customers c
JOIN campaign_sends cs ON c.customer_id = cs.customer_id;

-- Q2
-- Need all campaigns sends and click details (even if null) so going with a RIGHT JOIN where campaign_sends is on the right
SELECT cs.send_id,
CASE WHEN c.click_id IS NULL THEN 'FALSE' ELSE 'TRUE' END AS clicked
FROM clicks c
RIGHT JOIN campaign_sends cs ON cs.send_id = c.send_id;

-- Q3
-- Doing a RIGHT JOIN with customers to the right of campaign_sends to get all customers
SELECT c.email, cs.campaign_id
FROM campaign_sends cs
RIGHT JOIN customers c ON c.customer_id = cs.customer_id;

--Q4
-- Used LEFT JOIN to get all campaign sends then added WHERE clause to only select sends without clicks
SELECT cs.send_id
FROM campaign_sends cs
LEFT JOIN clicks c ON cs.send_id = c.send_id
WHERE c.send_id IS NULL;

--Q5
-- Tried a similar method to Q4, just with a RIGHT JOIN instead. To me it somehow makes more sense to think that the table we want to see nulls for is the one we pull from, even if the select statement doesn't include a value from it.
SELECT c.email 
FROM campaign_sends cs
RIGHT JOIN customers c ON c.customer_id = cs.customer_id
WHERE cs.customer_id IS NULL;