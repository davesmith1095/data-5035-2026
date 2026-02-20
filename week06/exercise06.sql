-- WITH YEAR_FIX AS(
--     SELECT *,
-- -- Need to CAST DOB as int to evaluate as number, not date    
--         CASE WHEN CAST(YEAR(DATE_OF_BIRTH) AS INT) <= 7 THEN 
--         2000 + CAST(YEAR(DATE_OF_BIRTH) AS INT) ELSE
--         1900 + CAST(YEAR(DATE_OF_BIRTH) AS INT) 
--         END AS BIRTH_YEAR
--     FROM data5035.spring26.donations
--     )

-- -- Query data from CTE, append binary data quality fields
-- SELECT *,
-- -- Check Age vs. Birth Year for inaccuracies. Current YR - Birth Year should be age  or age -1.
--         CASE WHEN AGE = (YEAR(CURRENT_DATE()) - BIRTH_YEAR) THEN 1
--         --added line to account for bdays that haven't yet passed
--         WHEN AGE = (YEAR(CURRENT_DATE()) - BIRTH_YEAR - 1) THEN 1 
--         ELSE 0 END AS AGE_CHECK,

-- /*  Case 1: Age = 45, Birth Year = 1980, 0
--     Case 2: Age = 43, Birth Year = 1980, 1
--     Case 3: Age = 26, Birth Year = 2000, 0
--     Case 4: Age or Birth Year = NULL, 1
-- */

-- -- Check for names missing capitalization
--         CASE WHEN NAME != INITCAP(NAME) THEN 1 ELSE 0 END AS LOWER_NAMES,

-- /*  Case 1: 'tim smith', 1
--     Case 2: 'Tim Smith', 0
--     Case 3: 'JIM SMITH', 1
--     Case 4: NULL, 1
-- */

-- -- Check for short ZIPs (truncated 0s biproduct of number datatype) 
--         CASE WHEN LENGTH(ZIP) < 5 THEN 1 ELSE 0 END AS SHORT_ZIP,

-- /*  Case 1: '0054', 1
--     Case 2: '00592', 0
--     Case 3: '630318501', 0
--     Case 4: NULL, 0
-- */


-- -- Check where N/A used, nulls already in Category
--         CASE WHEN (CATEGORY = 'N/A' OR CATEGORY IS NULL) THEN 1 ELSE 0 END AS NULL_CATS,

-- /*  Case 1: Category = 'N/A', 1,
--     Case 2: Category = NULL, 1,
--     Case 3: Category = 'Healthcare', 0
--     Case 4: Category = '', 1
-- */

-- -- Check phone length after all characters removed. > 10 is int'l or has ext.
--         CASE WHEN LENGTH(REGEXP_REPLACE(PHONE, '[^0-9]', ''))>10 THEN 1 ELSE 0 END AS PHONE_LEN
-- -- From CTE which cites donations csv

-- /*  Case 1: 1-555, 0
--     Case 2: +1/111/555/5252, 1
--     Case 3: +125(5932)314-414, 1
--     Case 4: NULL, 0
-- */

-- FROM YEAR_FIX;



-- Begin Tests --

USE SCHEMA data5035.spring26;

CREATE OR REPLACE TEMPORARY TABLE donations_test(
    testid int,
    test_dob date,
    test_bday_age int,
    test_name varchar,
    test_zip varchar,
    test_category varchar,
    test_phone varchar,
    exp_bday_age int not null,
    exp_name int not null,
    exp_zip int not null,
    exp_cat int not null,
    exp_phone int not null
);

INSERT INTO donations_test

VALUES
-- Name test
(1, '0090-08-21', 35, 'tim smith', '0054', 'N/A', '1-555', 0,0,0,1,1 ),
(2, '0090-08-01', 34, 'Tim Smith', '00592', '', '+1/111/555/5252', 0,0,1,0,0),
(3, '0000-07-22', 26, 'JIM SMITH', '630318501', 'Healthcare', '+125(5932)314-414', 0,0,0,0,0)
(4, '0026-07-38', 26, 'JIM SMITH', '630318501', 'Healthcare', '+125(5932)314-414', 1,1,0,0,0)
(5, '08-21-1990', 36, 'JIM SMITH', '630318501', 'Healthcare', '+125(5932)314-414', 0,0,0,0,0)
(6, '0008-01-01', 18, 'JIM SMITH', '630318501', 'Healthcare', '+125(5932)314-414', 0,0,0,0,0),
(7, NULL, NULL, NULL, NULL, NULL, NULL, 0,0,1,1,0)
;

SELECT
    -- Age / Birth Year Unit Tests
    test_dob,
    test_bday_age,
    (CASE 
        WHEN YEAR(test_dob) <= 7 THEN 2000 + YEAR(test_dob) 
        ELSE 1900 + YEAR(test_dob) 
    END) AS derived_birth_year,
    CASE 
        WHEN ((2026 - test_bday_age) <> derived_birth_year)
            OR ((2026 - test_bday_age - 1) = derived_birth_year) THEN 1
        ELSE 0 
    END AS actual_bday_age,
    exp_bday_age,
    actual_bday_age = exp_bday_age as bday_match,
    
    -- Name Unit Tests
    test_name,
    'LOWER_NAMES' as input_name,
    CASE WHEN test_name != INITCAP(test_name) THEN 1 ELSE 0 END AS actual_name,
    exp_name,
    actual_name = exp_name as name_match,

    -- Zip Code Unit Tests
    test_zip,
    'SHORT_ZIP' as input_zip,
    CASE WHEN LENGTH(test_zip) < 5 THEN 1 ELSE 0 END AS actual_zip,
    exp_zip,
    actual_zip = exp_zip as zip_match,

    -- Category Unit Tests
    test_category,
    'NULL_CATS' as input_cat,
    CASE WHEN (test_category = 'N/A' OR test_category IS NULL) THEN 1 ELSE 0 END AS actual_cat, 
    exp_cat,
    actual_cat = exp_cat as cat_match,

    -- Phone Unit Tests
    test_phone,
    'PHONE_LEN' as input_phone,
    CASE WHEN LENGTH(REGEXP_REPLACE(test_phone, '[^0-9]', ''))>10 THEN 1 ELSE 0 END AS actual_phone,
    exp_phone,
    actual_phone = exp_phone as phone_match

FROM donations_test;


