/* 
Working Notes:
Consider level 1, 2, and 3 charging: https://sepapower.org/knowledge/ev-charging-infrastructure/
*/

WITH 

-- 1. Demand: Maximize Demand based on current level of EV traffic
traffic_demand AS (
    SELECT 
        SEGMENT_ID,
        (AADT_EV / AADT_TOTAL) * 100 AS EV_SHARE_PCT,
        CASE 
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
        CASE 
            WHEN CRASH_RATE < AVG(CRASH_RATE) OVER () THEN 1 
            ELSE 0 
        END AS SAFE_CRASH_FLAG
    FROM DATA5035.SPRING26.INCIDENTS
),

-- 3. Safety: Favorable weather risk
safety_weather AS (
    SELECT 
        r.SEGMENT_ID,
        CASE 
            WHEN w.RISK_SCORE <= 0.65 THEN 1 
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
            WHEN e.CONSTRAINT_ID IS NULL THEN 1 -- 1 means NO intersection (good)
            ELSE 0 
        END AS SAFE_ENV_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    LEFT JOIN DATA5035.SPRING26.ENV_CONSTRAINTS e
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
    WHERE p.TYPE = 'substation'
    GROUP BY r.SEGMENT_ID
),

-- 6. Feasibility: Low interchange density
feasibility_interchanges AS (
    SELECT 
        r.SEGMENT_ID,
        COUNT(i.INTERCHANGE_ID) AS interchange_count,
        CASE 
            WHEN COUNT(i.INTERCHANGE_ID) < 3 THEN 1 
            ELSE 0 
        END AS LOW_INTERCHANGE_FLAG
    FROM DATA5035.SPRING26.ROAD_SEGMENTS r
    LEFT JOIN DATA5035.SPRING26.INTERCHANGES i
        ON ST_DWITHIN(r.GEOM, i.GEOM, 1000)
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
)

-- FINAL SELECT: Join all CTEs and calculate total suitability score
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
ORDER BY SUITABILITY_SCORE DESC, r.INTERSTATE, r.SEGMENT_ID;
