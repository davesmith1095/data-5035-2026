USE SCHEMA data5035.spring26;

-- Create table for testing output --
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

-- Insert test and expected values --
INSERT INTO donations_test

VALUES
-- | ID | DOB | Age | Name | Zip | Cat | Phone | exp_age | exp_name | exp_zip | exp_cat | exp_phone |
(1, '0090-08-21', 35, 'tim smith', '0054', 'N/A', '1-555', 0,1,1,1,0 ),
(2, '0090-08-01', 34, 'Zach Pyatt', '00592', '', '+1/111/555/5252', 1,0,0,0,1),
(3, '0090-08-21', 36, 'IAN LEE', '630318501', 'Healthcare', '+125(5932)314-414', 0,1,0,0,1),
(4, '0026-07-28', 26, 'DrEwShAw', '1', 'NULL', '317-555-2938 EXT. 334', 1,1,1,0,1),
(5, '0000-07-22', 26, '  Alex Parks', '6A', 'Not Interested', '555/5555', 0,0,1,0,0),
(6, '0008-01-01', 18, 'Madonna', '99950-9100', 'Dynamic...', '555-555-5555', 0,0,0,0,0),
-- Note: Not requiring zip code or phone, so NULLS ok
(7, NULL, NULL, NULL, NULL, NULL, NULL, 1,1,0,1,0)
;

-- Begin Unit Tests -- 
SELECT
    -- Age - Birth Year = Derived Birth Year (-1 if bday not yet reached)
    test_dob,
    test_bday_age,
    -- Need to convert DOB values ('0091-01-02') to usable year
    (CASE 
        -- Birth Year 0008 --> 2008; 0009 --> 1909 - Age range 17-117
        WHEN CAST(YEAR(test_dob) AS INT) <= 8 
        THEN 2000 + YEAR(test_dob) 
        ELSE 1900 + YEAR(test_dob) 
    END) AS derived_birth_year,
    -- If year - age <> derived birth year, fail. Include -1 buffer if bday not yet reached.
    CASE
    WHEN (YEAR(CURRENT_DATE()) - test_bday_age) = derived_birth_year THEN 0
    WHEN (YEAR(CURRENT_DATE()) - test_bday_age - 1) = derived_birth_year THEN 0 
    ELSE 1
    END AS actual_bday_age,
    exp_bday_age,
    actual_bday_age = exp_bday_age as bday_match,
    
    -- Only accepting proper-case names
    test_name,
    'LOWER_NAMES' as input_name,
    CASE WHEN test_name != INITCAP(test_name) OR test_name IS NULL THEN 1 ELSE 0 END AS actual_name,
    exp_name,
    actual_name = exp_name as name_match,

    -- Zip Codes must be >5 (catches dropped leading zeroes)
    test_zip,
    'SHORT_ZIP' as input_zip,
    CASE WHEN LENGTH(test_zip) < 5 THEN 1 ELSE 0 END AS actual_zip,
    exp_zip,
    actual_zip = exp_zip as zip_match,

    -- Category can't be N/A or NULL
    test_category,
    'NULL_CATS' as input_cat,
    CASE WHEN (test_category = 'N/A' OR test_category IS NULL) THEN 1 ELSE 0 END AS actual_cat, 
    exp_cat,
    actual_cat = exp_cat as cat_match,

    -- Need to identify phones >10 numbers as int'l or #s with extension
    test_phone,
    'PHONE_LEN' as input_phone,
    CASE WHEN LENGTH(REGEXP_REPLACE(test_phone, '[^0-9]', ''))>10 THEN 1 ELSE 0 END AS actual_phone,
    exp_phone,
    actual_phone = exp_phone as phone_match

FROM donations_test;


