-- Set role and schema
-- USE ROLE CHEETAH_DATA5035_ROLE;
-- USE SCHEMA DATA5035.CHEETAH;
/******************************************************************************
 * QUALITY & BATCH CONTROL - SQL EXERCISES
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