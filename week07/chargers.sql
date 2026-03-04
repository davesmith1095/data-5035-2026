/* 
Tables:
• ROAD_SEGMENTS (103) - 10-mile segments with GEOGRAPHY line strings
    -- Interchange Density: Consider count of Interchanges per 10-mile share (group by count, rvw.)
    -- Proximity to Power: Check avg dist from plant to start, mid, end of line segments for rvw
    -- Suitable Geometry: How do we know if a road is straight?
• TRAFFIC_COUNTS (103) - Annual Average Daily Traffic (AADT) with 2-12% EV share, 15-35% trucks
    -- Demand per EV Traffic: Take 8% of AADT to represent EV share and small percentage of trucks
• POWER_INFRA (55) - Substations (30) + transmission (25)
    -- Proximity to Power: Substations DIST power, transmission MAKE power
• INTERCHANGES (343) - Denser near STL/Chicago/KC
• ENV_CONSTRAINTS (17) - Wetlands and protected areas as polygons
• WEATHER_RISK (103) - Higher risk in northern IL
    -- Low Weather Risk: Rvw data, decide what "favorable" is
• INCIDENTS (103) - Higher crash rates in urban areas
    -- Low Crash Rate: Rvw data, decide what "low" is

    -- Double-check tables, seems SPEED is not listed. May set as Constant at 70MPH

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

-- Checking connectivty between tables. These four have different geometries but can likely be joined on them.
-- SELECT TOP 1 (GEOM) FROM data5035.spring26.ROAD_SEGMENTS; --"type": "LineString"
-- SELECT TOP 1 (GEOM) FROM data5035.spring26.POWER_INFRA; --"type": "Point"
-- SELECT TOP 1 (GEOM) FROM data5035.spring26.INTERCHANGES; --"type": "Point"
-- SELECT TOP 1 (GEOM) FROM data5035.spring26.ENV_CONSTRAINTS; --"type": "Polygon"

-- No tables lining up on SEGMENT_ID require 
-- SELECT TOP 1 (SEGMENT_ID) FROM data5035.spring26.TRAFFIC_COUNTS;
-- SELECT TOP 1 (SEGMENT_ID) FROM data5035.spring26.ROAD_SEGMENTS;
-- SELECT TOP 1 (SEGMENT_ID) FROM data5035.spring26.WEATHER_RISK;
-- SELECT TOP 1 (SEGMENT_ID) FROM data5035.spring26.INCIDENTS;