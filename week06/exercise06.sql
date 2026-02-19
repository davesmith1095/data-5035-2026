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

/*  Case 1: Age = 45, Birth Year = 1980, 1
    Case 2: Age = 26, Birth Year = 2005, 1
    Case 3: Age = 26, Birth Year = 2000, 0
*/

-- Check for names missing capitalization
        CASE WHEN NAME != INITCAP(NAME) THEN 1 ELSE 0 END AS LOWER_NAMES,

/*  Case 1: 'tim smith', 1
    Case 2: 'Tim Smith', 0
    Case 3: 'JIM SMITH', 0
*/

-- Check for short ZIPs (truncated 0s biproduct of number datatype) 
        CASE WHEN LENGTH(ZIP) < 5 THEN 1 ELSE 0 END AS SHORT_ZIP,

/*  Case 1: '0054', 1
    Case 2: '00592', 0
    Case 3: '630318501', 0
*/


-- Check where N/A used, nulls already in Category
        CASE WHEN (CATEGORY = 'N/A' OR CATEGORY IS NULL) THEN 1 ELSE 0 END AS NULL_CATS,

/*  Case 1: Category = 'N/A', 1,
    Case 2: Category = NULL, 1,
    Case 3: Category = 'Healthcare', 0
*/

-- Check phone length after all characters removed. > 10 is int'l or has ext.
        CASE WHEN LENGTH(REGEXP_REPLACE(PHONE, '[^0-9]', ''))>10 THEN 1 ELSE 0 END AS PHONE_LEN,
-- From CTE which cites donations csv

/*  Case 1: 1-555, 0
    Case 2: +1/111/555/5252, 0
    Case 3: +125(5932)314-414
*/

FROM YEAR_FIX
