-- Use CTE to create birth year and later run expression on it
WITH YEAR_FIX AS(
    SELECT *,
-- Need to CAST DOB as int to evaluate as number, not date    
        CASE WHEN CAST(YEAR(DATE_OF_BIRTH) AS INT) <= 7 THEN 
        2000 + CAST(YEAR(DATE_OF_BIRTH) AS INT) ELSE
        1900 + CAST(YEAR(DATE_OF_BIRTH) AS INT) 
        END AS BIRTH_YEAR
    FROM data5035.spring26.donations
    )

-- Query data from CTE, append binary data quality fields
SELECT *,
-- Check Age vs. Birth Year for inaccuracies. Current YR - Age should be Birth Year.
        CASE WHEN YEAR(CURRENT_DATE()) - AGE <> BIRTH_YEAR THEN 1 ELSE 0 END AS AGE_CHECK,
-- Check for names missing capitalization
        CASE WHEN NAME != INITCAP(NAME) THEN 1 ELSE 0 END AS LOWER_NAMES,
-- Check for short ZIPs (truncated 0s biproduct of number datatype) 
        CASE WHEN LENGTH(ZIP) < 5 THEN 1 ELSE 0 END AS SHORT_ZIP,
-- Check where N/A used, nulls already in Category
        CASE WHEN (CATEGORY = 'N/A' OR CATEGORY IS NULL) THEN 1 ELSE 0 END AS NULL_CATS,
-- Check phone length after all characters removed. > 10 is int'l or has ext.
        CASE WHEN LENGTH(REGEXP_REPLACE(PHONE, '[^0-9]', ''))>10 THEN 1 ELSE 0 END AS PHONE_LEN,
-- From CTE which cites donations csv
FROM YEAR_FIX
