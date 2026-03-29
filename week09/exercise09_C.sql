-- Set role and schema
USE ROLE CHEETAH_DATA5035_ROLE;
USE SCHEMA DATA5035.CHEETAH;
/******************************************************************************
 * QUALITY & BATCH CONTROL - SQL QUESTIONS
 ******************************************************************************/

-- Q1: Show all batches and their quality test results
-- Business Description: Show all batches and their quality test results
-- Columns Returned: batch_id | test_type | result
-- Notes: Only batches with tests 


-- Q2: Show all batches, including those without tests
-- Business Description: Show all batches, including those without tests
-- Columns Returned: batch_id | test_type | result
-- Notes: Include batches with no tests


-- Q3: Find batches with both failed tests and deviations
-- Business Description: Find batches with both failed tests and deviations
-- Columns Returned: batch_id
-- Notes: Requires aggregation or multiple joins


-- Q4: Show batch-level counts of tests and deviations
-- Business Description: Show batch-level counts of tests and deviations
-- Columns Returned: batch_id | test_count | deviation_count
-- Notes: Join + aggregation


-- Q5: Find batches with no deviations
-- Business Description: Find batches with no deviations
-- Columns Returned: batch_id
-- Notes: Anti-join (batches without deviations)

/******************************************************************************
 * SQL EXERCISES
******************************************************************************/

-- Set up database tables and load test data
-- Batches table
CREATE TABLE IF NOT EXISTS batches (
    batch_id VARCHAR PRIMARY KEY,
    product VARCHAR,
    facility VARCHAR
);

-- Quality Tests table
CREATE TABLE IF NOT EXISTS quality_tests (
    test_id VARCHAR PRIMARY KEY,
    batch_id VARCHAR FOREIGN KEY REFERENCES batches(batch_id),
    test_type VARCHAR,
    "result" VARCHAR
);

-- Deviations table
CREATE TABLE IF NOT EXISTS deviations (
    deviation_id VARCHAR PRIMARY KEY,
    batch_id VARCHAR FOREIGN KEY REFERENCES batches(batch_id),
    description VARCHAR
);

-- create sample records for batch table
INSERT INTO batches (batch_id, product, facility) VALUES
('B1', 'DrugA', 'Plant1'),
('B2', 'DrugA', 'Plant2'),
('B3', 'DrugB', 'Plant1');

-- create sample records for quality tests table
INSERT INTO quality_tests (test_id, batch_id, test_type, "result") VALUES
('T1', 'B1', 'purity', 'pass'),
('T2', 'B1', 'stability', 'fail'),
('T3', 'B2', 'purity', 'pass');

-- create sample records for deviations table
INSERT INTO deviations (deviation_id, batch_id, description) VALUES
('D1', 'B1', 'temperature excursion');



-- Q1: Show all batches and their quality test results	batch_id 
-- Uses INNER JOIN because we want batch and quality test data that appears on both tables, without nulls.
-- Left the "results" in quotes because it's a reserved word, but this was in the table in the assignment
SELECT b.batch_id, qt.test_type, qt."result"
FROM batches b
JOIN quality_tests qt ON b.batch_id = qt.batch_id;

-- Q2: Show all batches, including those without tests	batch_id 
-- Uses LEFT JOIN because we want all batches, even those without quality test data.
SELECT b.batch_id, qt.test_type, qt."result"
FROM batches b
LEFT JOIN quality_tests qt ON b.batch_id = qt.batch_id;

-- Q3: Find batches with both failed tests and deviations	batch_id
-- Uses INNER JOIN twice to include batches that have quality tests and batches with deviation ids, then filters on the quality test result for failures.
SELECT DISTINCT b.batch_id
FROM batches b
JOIN quality_tests qt ON b.batch_id = qt.batch_id
JOIN deviations d ON b.batch_id = d.batch_id
WHERE qt."result" = 'fail';

-- Q4: Show batch-level counts of tests and deviations	batch_id | test_count | deviation_count
-- Using LEFT JOIN to capture all of the Batches that have quality tests and deviations, then grouping by 
-- batch ID so that the tests and deviations can be aggregated by COUNT
SELECT b.batch_id, COUNT(qt.test_id) AS test_count, COUNT(d.deviation_id) AS deviation_count
FROM batches b
LEFT JOIN quality_tests qt ON b.batch_id = qt.batch_id
LEFT JOIN deviations d ON b.batch_id = d.batch_id
GROUP BY b.batch_id;

-- Q5: Find batches with no deviations	batch_id
-- Use LEFT JOIN to get any batch and deviation overlap, then selecting where the right table (deviations) is NULL to find those without deviations
SELECT b.batch_id
FROM batches b
LEFT JOIN deviations d ON b.batch_id = d.batch_id
WHERE d.deviation_id IS NULL;