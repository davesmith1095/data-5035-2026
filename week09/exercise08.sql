/**
|  Business Process|  Description  |  Date  |  Batch  |  Facility  |  Product  |  Material  |  Labor  |  Quality  |  Cost Category  |
|------------------|---------------|--------|---------|------------|-----------|-----------|---------|-----------|-----------------|
Material Consumption (Material Cost)  |  Cost of Raw Ingredients Consumed               |  X   |   X   |   X   |   X   |   X   |       |       |   X   |
Labor Tracking (Actual Labor Cost)  |  Cost of regular and overtime operator hours      |  X   |   X   |   X   |   X   |       |   X   |       |   X   |
Overhead Allocation (Overhead Cost)  |  Equipment, utility, and holding costs           |  X   |   X   |   X   |   X   |   X   |       |       |   X   |
Quality Testing (QC Cost)  |  Cost of routine tests and failure investigations          |  X   |   X   |   X   |   X   |   X   |       |   X   |   X   |
Batch Completion (Total Actual Cost)  |  Total aggregated cost of production batch      |  X   |   X   |   X   |   X   |   X   |       |       |   X   |
Batch Yield (Total Units Produced)  |  Total finished units successfully manufactured   |  X   |   X   |   X   |   X   |   X   |       |       |       |	
**/

-- Each record/row represents a cost of a single production batch.
CREATE TABLE IF NOT EXISTS FACT_BATCH_COSTS (
    -- Foreign Keys
    batch_id VARCHAR PRIMARY KEY, -- There's a batch dimension table, so Batch ID is both a foreign and primary key
    date_key INT,
    facility_id VARCHAR,
    product_id VARCHAR,
    -- Cost Details
    material_cost NUMBER(10,2),
    labor_cost NUMBER(10,2),
    overhead_cost NUMBER(10,2),
    holding_cost NUMBER(10,2),
    quality_cost NUMBER(10,2),
    total_actual_cost NUMBER(10,2),
    total_units_produced NUMBER(10,2)
);

/** Expanding each cost category into its own table would allow better reporting and analysis
    for avg. material cost per facility, quality cost per product, holding time/cost per product/facility, etc.
**/

CREATE TABLE IF NOT EXISTS DIM_DATE (
    date_key INT PRIMARY KEY,
    date DATE,
    week_of_year INT,
    month_of_year INT,
    quarter_of_year INT,
    year INT
);

CREATE TABLE IF NOT EXISTS DIM_BATCH (
    batch_id VARCHAR PRIMARY KEY,
    batch_name VARCHAR,
    batch_type VARCHAR,
    batch_status VARCHAR,
    batch_date DATE,
    batch_time TIME,
    batch_duration TIME,
    standard_cost_expected NUMBER (10,2),
    standard_hours_expected NUMBER (10,2)
);

CREATE TABLE IF NOT EXISTS DIM_FACILITY (
    facility_id VARCHAR PRIMARY KEY,
    facility_name VARCHAR,
    facility_type VARCHAR,
    location VARCHAR,
    production_line VARCHAR,
    cleanroom_iso_level VARCHAR,
    sterile_environment BOOLEAN,
    cleanroom_certification BOOLEAN
);

CREATE TABLE IF NOT EXISTS DIM_PRODUCT (
    product_id VARCHAR PRIMARY KEY,
    product_name VARCHAR,
    product_type VARCHAR,
    product_category VARCHAR
);