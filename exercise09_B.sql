-- Set role and schema
-- USE ROLE CHEETAH_DATA5035_ROLE;
-- USE SCHEMA DATA5035.CHEETAH;
/******************************************************************************
 * HEALTHCARE DATA - SQL EXERCISES
 ******************************************************************************/

-- Q1: Show each visit with patient and provider details
-- Business Description: Show each visit with patient and provider details
-- Columns Returned: patient name | provider name | visit_date
-- Notes: Only visits that occurred


-- Q2: Show all patients and any visits they may have had
-- Business Description: Show all patients and any visits they may have had
-- Columns Returned: patient name | visit_id
-- Notes: Include patients with no visits


-- Q3: Show all providers and any visits they handled
-- Business Description: Show all providers and any visits they handled
-- Columns Returned: provider name | visit_id
-- Notes: Include providers with no visits


-- Q4: Find patients who have never had a visit
-- Business Description: Find patients who have never had a visit
-- Columns Returned: patient name
-- Notes: Anti-join (patients without visits)


-- Q5: Show visits handled by cardiology providers
-- Business Description: Show visits handled by cardiology providers
-- Columns Returned: patient name | provider name | visit_date
-- Notes: Filter after join