WITH 

-- 1. Demand: Maximize Demand based on current level of EV traffic
traffic_demand AS (
    SELECT 
        SEGMENT_ID,
        -- Find proportion of EV to total traffic
        (AADT_EV / AADT_TOTAL) * 100 AS EV_SHARE_PCT,
        CASE 
            -- Wherever more than five percent of total traffic is EVs, flag as "high demand"
            WHEN (AADT_EV / AADT_TOTAL) * 100 > 5.0 THEN 1 
            ELSE 0 
        END AS HIGH_DEMAND_FLAG
    FROM DATA5035.SPRING26.TRAFFIC_COUNTS
),

-- 2. Safety: Low existing crash rate
safety_crash AS (
    SELECT 
        SEGMENT_ID,
        CRASH_RATE,
        INCIDENT_RATE,
        CASE 
            -- Find where crash AND incident rates are less than their average overall
            -- later flag as "safe"
            WHEN CRASH_RATE < AVG(CRASH_RATE) OVER () THEN 1
            WHEN INCIDENT_RATE < AVG(INCIDENT_RATE) OVER () THEN 1
            ELSE 0 
        END AS SAFE_CRASH_FLAG
    FROM DATA5035.SPRING26.INCIDENTS
),

-- 3. Safety: Unfavorable weather risk
safety_weather AS (
    SELECT 
        r.SEGMENT_ID,
        CASE 
            -- Find where there's a less than 65% chance of favorable weather 
            WHEN w.RISK_SCORE >= 0.65 THEN 1 
            ELSE 0 
        END AS SAFE_WTHR_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    LEFT JOIN DATA5035.SPRING26.WEATHER_RISK w
        ON w.SEGMENT_ID = r.SEGMENT_ID
),

-- 4. Feasibility: Avoiding Wetlands and Protected Lands (Environmental Constraints)
feasibility_env AS (
    SELECT 
        r.SEGMENT_ID,
        CASE
            -- Check join for more details, NULL means no intersection with restricted area
            WHEN e.CONSTRAINT_ID IS NULL THEN 1
            ELSE 0 
        END AS SAFE_ENV_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    -- Using left join to keep all data for flagging data as appropriate or not
    LEFT JOIN DATA5035.SPRING26.ENV_CONSTRAINTS e
        -- Joining on ST_INTERSECTS checks if the lines from road segment geographies intersect env. polygons
        ON ST_INTERSECTS(r.GEOM, e.GEOM)
),

-- 5. Feasibility: Proximity to power infrastructure
feasibility_power AS (
    SELECT 
        r.SEGMENT_ID,
        MIN(ST_DISTANCE(r.GEOM, p.GEOM)) AS nearest_power_m,
        CASE 
            WHEN MIN(ST_DISTANCE(r.GEOM, p.GEOM)) <= 1000 THEN 1 
            ELSE 0 
        END AS POWER_ACCESS_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    CROSS JOIN DATA5035.SPRING26.POWER_INFRA p
    /* Opted for substation "filter" because they adjust/deliver power rather than
    transmitting between major locations */
    WHERE p.TYPE = 'substation'
    GROUP BY r.SEGMENT_ID
),

-- 6. Feasibility: Low interchange density
feasibility_interchanges AS (
    SELECT 
        r.SEGMENT_ID,
        COUNT(i.INTERCHANGE_ID) AS interchange_count,
        CASE 
            -- Check for when there are less than 5 exits per 10-mile segment
            WHEN COUNT(i.INTERCHANGE_ID) < 5 THEN 1 
            ELSE 0 
        END AS LOW_INTERCHANGE_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    LEFT JOIN DATA5035.SPRING26.INTERCHANGES i
        -- 1mi ~ 1609 meters. Checking exits per mile in 10 mile segments
        ON ST_DWITHIN(r.GEOM, i.GEOM, 16100)
    GROUP BY r.SEGMENT_ID
),

-- 7. Safety: Manageable traffic speeds
safety_speed AS (
    SELECT 
        SEGMENT_ID,
        SPEED_LIMIT,
        CASE 
            WHEN SPEED_LIMIT <= 65 THEN 1 
            ELSE 0 
        END AS SAFE_SPEED_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS
),

-- FINAL SELECT: Join all CTEs and calculate total suitability score
scored_segments AS (
    SELECT
        r.SEGMENT_ID,
        r.INTERSTATE,
        (
            COALESCE(td.HIGH_DEMAND_FLAG, 0) + 
            COALESCE(sc.SAFE_CRASH_FLAG, 0) + 
            COALESCE(sw.SAFE_WTHR_FLAG, 0) + 
            COALESCE(fe.SAFE_ENV_FLAG, 0) + 
            COALESCE(fp.POWER_ACCESS_FLAG, 0) + 
            COALESCE(fi.LOW_INTERCHANGE_FLAG, 0) + 
            COALESCE(ss.SAFE_SPEED_FLAG, 0)
        ) AS SUITABILITY_SCORE
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
LEFT JOIN traffic_demand td ON r.SEGMENT_ID = td.SEGMENT_ID
LEFT JOIN safety_crash sc ON r.SEGMENT_ID = sc.SEGMENT_ID
LEFT JOIN safety_weather sw ON r.SEGMENT_ID = sw.SEGMENT_ID
LEFT JOIN feasibility_env fe ON r.SEGMENT_ID = fe.SEGMENT_ID
LEFT JOIN feasibility_power fp ON r.SEGMENT_ID = fp.SEGMENT_ID
LEFT JOIN feasibility_interchanges fi ON r.SEGMENT_ID = fi.SEGMENT_ID
LEFT JOIN safety_speed ss ON r.SEGMENT_ID = ss.SEGMENT_ID
),

-- 9. Parse and Island Grouping: Extract number and create unique island groups
islands AS (
    SELECT 
        SEGMENT_ID,
        INTERSTATE,
        SUITABILITY_SCORE,
        CAST(SPLIT_PART(SEGMENT_ID, '-', 2) AS INTEGER) AS segment_num,
        -- Subtract row number from segment number to group continuous segments 
        -- that share the same interstate AND the same suitability score
        CAST(SPLIT_PART(SEGMENT_ID, '-', 2) AS INTEGER) - ROW_NUMBER() OVER (
            PARTITION BY INTERSTATE, SUITABILITY_SCORE 
            ORDER BY CAST(SPLIT_PART(SEGMENT_ID, '-', 2) AS INTEGER)
        ) AS island_group
    FROM scored_segments
),

-- 10. Segment Counting: Count the continuous chunks
island_counts AS (
    SELECT 
        SEGMENT_ID,
        INTERSTATE,
        SUITABILITY_SCORE,
        COUNT(*) OVER (
            PARTITION BY INTERSTATE, SUITABILITY_SCORE, island_group
        ) AS consecutive_segment_count
    FROM islands
)

-- FINAL SELECT: Output the list to easily identify the top 4 locations
-- SELECT 
--     SEGMENT_ID,
--     INTERSTATE,
--     SUITABILITY_SCORE,
--     consecutive_segment_count
-- FROM island_counts
-- ORDER BY 
--     consecutive_segment_count DESC, 
--     SUITABILITY_SCORE DESC, 
--     INTERSTATE, 
--     SEGMENT_ID;

-- 11. Find the maximum consecutive segments per interstate (only top 4 per assignment reqs)
SELECT 
    TOP 4 -- comment out to see full list (one per interstate)
    INTERSTATE,
    MAX(consecutive_segment_count) AS MAX_CONSECUTIVE_SEGMENTS,
    MAX(SUITABILITY_SCORE) AS BEST_SCORE_FOR_STRETCH
FROM island_counts
GROUP BY 
    INTERSTATE
ORDER BY 
    MAX_CONSECUTIVE_SEGMENTS DESC,
    BEST_SCORE_FOR_STRETCH DESC;