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


/**

This assignment reiterated a few important lessons in data science and problem solving. Primarily, I found it was important to keep myself grounded to the purpose of the assigment (denoting data quality issues) and that this is data represents something in the real world. It's easy to quickly abstract from what the data represents and to get lost in minutia. For example, as I started down the rabbit-hole of data discovery between the DATE_OF_BIRTH and AGE fields--I kept the query that confirmed these two didn't always align--I had to stop myself from finding several ways to justify a reason to drop one or both of these because of their misalignment. I needed to ground myself with a question about the value of these fields: This is donation data for organizations with information about the donors--does it matter how old they are? If it does, the fields can stay but they need to align. If not, drop them. Metadata kept me grounded to the reality of this data and, luckily, it was well documented metadata. This reiterates the importance of metadata. There were a few other tells about table composition that I liked exploring--were the right datatypes used (e.g. ZIPs as numbers drops crucial leading zeroes)? Were the parameters around them too restrictive or not restrictive enough (String fields allowed WAY too mcuh data)? I have a list of these observations in the notes.txt file, but the main lesson was that metadata can speak to the role it has in establishing and enforcing data quality. Lots to learn. I'm excited to continue working on this and other datasets. I was disappointed to not be able to wrap up some geocoding work on this in time.
**/