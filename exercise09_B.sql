-- Set role and schema
USE ROLE CHEETAH_DATA5035_ROLE;
USE SCHEMA DATA5035.CHEETAH;
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

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT,
    "name" STRING,
    birth_year INT
);

CREATE TABLE IF NOT EXISTS visits (
    visit_id INT,
    patient_id INT,
    visit_date DATE,
    provider_id INT
);

CREATE TABLE IF NOT EXISTS "providers" (
    provider_id INT,
    provider_name STRING,
    speciality STRING
);

INSERT INTO patients (patient_id, "name", birth_year) VALUES 
    (1, 'John', 1980),
    (2, 'Mary', 1975),
    (3, 'Sam', 1990);

INSERT INTO visits (visit_id, patient_id, visit_date, provider_id) VALUES 
    (2001, 1, '2024-02-01', 10),
    (2002, 2, '2024-02-03', 11);

INSERT INTO "providers" (provider_id, provider_name, speciality) VALUES 
    (10, 'Dr. Smith', 'Cardiology'),
    (11, 'Dr. Lee', 'Primary Care'),
    (12, 'Dr. Patel', 'Oncology');

--Q1
-- Using two INNER JOINs to bring together all detail data with a matching visit
SELECT pa."name" AS "patient name", pr.provider_name AS "provider name", v.visit_date
FROM visits v
JOIN patients pa ON v.patient_id = pa.patient_id
JOIN "providers" pr ON v.provider_id = pr.provider_id;

--Q2
-- Used RIGHT JOIN to bring in all patients then bring in visits (null or not)
SELECT pa."name" AS "patient name", v.visit_id
FROM visits v
RIGHT JOIN patients pa ON v.patient_id = pa.patient_id


--Q3
-- Used RIGHT JOIN to bring in all providers then bring in visits (null or not)
SELECT pr.provider_name AS "provider name", v.visit_id
FROM visits v
RIGHT JOIN "providers" pr ON v.provider_id = pr.provider_id

--Q4
-- Used RIGHT JOIN again to bring in all visits records per patients (null or not) but then specified with WHERE statement to ONLY include NULL. This shows patients w/o visits.
SELECT pa."name" AS "patient name"
FROM visits v
RIGHT JOIN patients pa ON v.patient_id = pa.patient_id
WHERE v.visit_id IS NULL

--Q5
-- Same as Q1 but with a WHERE clause to filter for Cardiology
SELECT pa."name" AS "patient name", pr.provider_name AS "provider name", v.visit_date
FROM visits v
JOIN patients pa ON v.patient_id = pa.patient_id
JOIN "providers" pr ON v.provider_id = pr.provider_id
WHERE pr.speciality = 'Cardiology';
