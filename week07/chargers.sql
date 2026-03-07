/* 
Working Notes:
Consider level 1, 2, and 3 charging: https://sepapower.org/knowledge/ev-charging-infrastructure/

Tables:
data5035.spring26. 
• ROAD_SEGMENTS (103) - 10-mile segments with GEOGRAPHY line strings(group by count, rvw.)
• TRAFFIC_COUNTS (103) - Annual Average Daily Traffic (AADT) with 2-12% EV share, 15-35% trucks
• POWER_INFRA (55) - Substations (30) + transmission (25)
• INTERCHANGES (343) - Denser near STL/Chicago/KC
• ENV_CONSTRAINTS (17) - Wetlands and protected areas as polygons
• WEATHER_RISK (103) - Higher risk in northern IL
• INCIDENTS (103) - Higher crash rates in urban areas

Criteria:
• Maximize Demand based on current level of EV traffic
• Maximize Feasibility based on:
    o Proximity to power infrastructure
    o Low interchange density
    o Suitable road geometry (straight roads)
• Maximize Safety based on:
    o Low existing crash rate
    o Favorable weather risk
    o Manageable traffic speeds
• Pilot Value
    o Strategic visibility
    o Corridor importance
    o Geographic coverage

Connect on SEGMENT_ID:
TRAFFIC_COUNTS
ROAD_SEGMENTS
WEATHER_RISK
INCIDENTS

Connect on GEOM
ROAD_SEGMENTS
POWER_INFRA
INTERCHANGES
ENV_CONSTRAINTS
*/

-- Crash Rate: Flag instances where Crash Rate and Incident Rate are over the average for the entire set
-- SELECT
--     SEGMENT_ID,
--     CRASH_RATE,
--     INCIDENT_RATE,
--     ROUND((INCIDENT_RATE / CRASH_RATE) * 100, 2) AS INCIDENT_PCT_OF_CRASH,
--     CASE
--         WHEN CRASH_RATE > AVG(CRASH_RATE) OVER ()
--          AND INCIDENT_RATE > AVG(INCIDENT_RATE) OVER ()
--         THEN 1
--         ELSE 0
--     END AS HIGH_DANGER_FLAG
-- FROM DATA5035.SPRING26.INCIDENTS
-- ORDER BY HIGH_DANGER_FLAG DESC, CRASH_RATE DESC;

-- Low Weather Risk: Opted for risk <= 65%
-- SELECT
--     r.SEGMENT_ID,
--     r.INTERSTATE,
--     r.START_MILE,
--     r.END_MILE,
--     CASE
--         WHEN w.RISK_SCORE >= .65 THEN 1
--         ELSE 0
--     END AS HIGH_WTHR_RISK
-- FROM DATA5035.SPRING26.ROAD_SEGMENTS r
-- LEFT JOIN DATA5035.SPRING26.WEATHER_RISK w
--     ON w.SEGMENT_ID = r.SEGMENT_ID;

-- Avoiding Wetlands: Road segments that intersect wetland polygons
-- Set flag for environmental conditions
-- SELECT
--     r.SEGMENT_ID,
--     r.INTERSTATE,
--     r.START_MILE,
--     r.END_MILE,
--     CASE
--         WHEN e.CONSTRAINT_ID IS NOT NULL THEN 1
--         ELSE 0
--     END AS ENV_FLAG
-- FROM DATA5035.SPRING26.ROAD_SEGMENTS r
-- LEFT JOIN DATA5035.SPRING26.ENV_CONSTRAINTS e
--     ON ST_INTERSECTS(r.GEOM, e.GEOM)
-- ORDER BY r.INTERSTATE, r.START_MILE;


-- Demand per EV Traffic: Percentage of AADT_EV out of AADT_TOTAL
--  SELECT *, 
--     (AADT_EV/AADT_TOTAL) * 100 AS EV_SHARE_PCT
-- FROM data5035.spring26.TRAFFIC_COUNTS
-- ORDER BY EV_SHARE_PCT DESC;

-- Manageable traffic speeds: Speed limit listed here
-- Maybe weigh the values differently so that the higher the interchange count the less suitable for EV lane


-- Proximity to Power: Check avg dist from plant to road segments
-- Filter for substations because they lower voltage for electricity distr.
-- whereas transmission just moves high voltage
-- SELECT
--     r.SEGMENT_ID,
--     r.INTERSTATE,
--     MIN(ST_DISTANCE(r.GEOM, p.GEOM)) AS nearest_power_m,
--     COUNT(p.ASSET_ID) AS power_infra_count
-- FROM DATA5035.SPRING26.ROAD_SEGMENTS r
-- CROSS JOIN DATA5035.SPRING26.POWER_INFRA p
-- WHERE p.TYPE = 'substation'
-- GROUP BY r.SEGMENT_ID, r.INTERSTATE
-- ORDER BY nearest_power_m ASC;

-- Interchange Density: Joins interchange points on road segments where they fall within 1k meters
-- Interchange Density: Consider count of Interchanges per 10-mile share 
-- SELECT
--     r.SEGMENT_ID,
--     r.INTERSTATE,
--     COUNT(i.INTERCHANGE_ID) AS interchange_count
-- FROM DATA5035.SPRING26.ROAD_SEGMENTS r
-- LEFT JOIN DATA5035.SPRING26.INTERCHANGES i
--     ON ST_DWITHIN(r.GEOM, i.GEOM, 1000)
-- GROUP BY r.SEGMENT_ID, r.INTERSTATE
-- ORDER BY interchange_count DESC;

-- Suitable Geometry, mostly N/S, main changes at highways
-- Suitable Geometry: diff between start/end points to check straightness
-- WITH geom_diffs AS (
--     SELECT 
--         SEGMENT_ID,
--         INTERSTATE,
--         ST_X(ST_POINTN(GEOM, 1)) AS pt1_x,
--         ST_Y(ST_POINTN(GEOM, 1)) AS pt1_y,
--         ST_X(ST_POINTN(GEOM, 2)) AS pt2_x,
--         ST_Y(ST_POINTN(GEOM, 2)) AS pt2_y,
--         ST_X(ST_POINTN(GEOM, 2)) - ST_X(ST_POINTN(GEOM, 1)) AS delta_x,
--         ST_Y(ST_POINTN(GEOM, 2)) - ST_Y(ST_POINTN(GEOM, 1)) AS delta_y,
--         -- Square point deltas and take square root of sum to get Euclidean dist. between line point ends
--         SQRT(POWER(ST_X(ST_POINTN(GEOM, 2)) - ST_X(ST_POINTN(GEOM, 1)), 2) + 
--             POWER(ST_Y(ST_POINTN(GEOM, 2)) - ST_Y(ST_POINTN(GEOM, 1)), 2)) AS segment_length,
--         -- Determines angle and represents in degrees 
--         -- DEGREES(ATAN...Alone gives Cartesian degrees. MOD(CAST... added to display as compass degrees
--         -- N = 0, E = 90, S = 180, W = 270
--                 MOD(CAST(DEGREES(ATAN2(
--                         ST_X(ST_POINTN(GEOM, 2)) - ST_X(ST_POINTN(GEOM, 1)),
--                         ST_Y(ST_POINTN(GEOM, 2)) - ST_Y(ST_POINTN(GEOM, 1))
--                         )) + 360 AS NUMERIC), 360) AS heading_degrees
--     FROM DATA5035.SPRING26.ROAD_SEGMENTS
--     WHERE ST_NPOINTS(GEOM) >= 2
-- )
-- SELECT SEGMENT_ID, INTERSTATE, heading_degrees
-- FROM geom_diffs;

-- Speed Limit: Flag segments with speed limits under 70
-- SELECT
--     r.SEGMENT_ID,
--     r.INTERSTATE,
--     r.SPEED_LIMIT,
--     CASE
--         WHEN r.SPEED_LIMIT < 70 THEN 1
--         ELSE 0
--     END AS LOW_SPEED_FLAG
-- FROM DATA5035.SPRING26.ROAD_SEGMENTS r
-- ORDER BY LOW_SPEED_FLAG DESC, r.SPEED_LIMIT ASC;