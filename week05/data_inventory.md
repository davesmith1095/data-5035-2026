| Data Item | Importance (A/B/C) | Accessibility (1-4) | Why it's important | Why it's accessible (or not) |
| :--- | :---: | :---: | :--- | :--- |
| **Traffic Speed** | A | 4 | Speed could correlate with control and accident severity | Private, state, or county level tracking available. Could be accessible through APIs. |
| **Traffic Accidents, Pedestrian** | A | 1 | Areas with higher count could be more dangerous | Incidents reported to law enforcement (MSHP) as tabular and pdf reports. A bit disjointed. |
| **Traffic Activity** | A | 1 | Busy traffic unpleasant, potential for danger | Google or Waze API -- not sure of complexity. |
| **Amenities Rest Spot, Bench** | A | 4 | Good spot to rest, address baby unknown | Open Street Map might have this -- data mining with OVERPASS QL or analysis with OSMnx (python). |
| **Environmental Weather** | A | 4 | Walking in temperate weather preferred, safer | NWS, Open-Meteo, or other API. Constants available. Would need history and forecasting. |
| **Infrastructure Sidewalk, Size, Breaks/Gaps** | A | 2 | More gaps mean more street crossing | Open Street Map or local gov geospatial data. |
| **Environmental Shade** | B | 3 | Babies can't handle full sun | Can check plant cover aerial photos/maps. |
| **Infrastructure Sidewalk, Condition, Environment** | A | 2 | Area should be suitable for a stroller | Plant cover aerial photos, neighbor web scraper. |
| **Safety Temporal, Time to walk** | A | 1 | Increases confidence, preparation | Mostly determined by other factors, not accessible at onset. |
| **Safety Crime Stats, Sex Offenders** | B | 4 | Overall safety, staying away from convicted criminals | Geospatial or API from law enforcement website. |
| **Safety Crime Stats, Assault** | B | 4 | Safer to avoid high crime areas | Geospatial or API from law enforcement website. |
| **Infrastructure Sidewalk, Dist. From Road** | B | 4 | May provide buffer from traffic incidents | Calc. Measure from aerial photos/maps or local gov mgmt warmaps. |
| **Infrastructure Sidewalk, Visibility, Slope** | B | 4 | Steepness affects fatigue, Visibility during walk | Geospatial elevation data. |
| **Traffic Intersection, Type** | B | 4 | More complicated = distracted drivers | Open Street Map, computer vision/classification. |
| **Safety Crosswalks** | B | 4 | Option to cross provides path flexibility on walk | Open Street Map has this. |
| **Infrastructure Traffic Signals** | B | 4 | Stops may make drivers aware of surrounding pedestrians | Open Street Map has this. |
| **Amenities Parking** | B | 4 | Need safe spot if away from home | Park website, Open Street Map, aerial photo. |
| **Amenities Rest Spot, Water fountain** | B | 4 | Hydration for parents and baby | Open Street Map has this. |
| **Practical Baby, Mode of Transport** | B | 4 | Stroller needs nice sidewalks; carrier needs shorter walks | Self-reported data, categorical, two types: carrier or stroller. |
| **Environmental Noise pollution** | B | 4 | Unpleasant or harmful if too loud | HUD/BTS, NOAA, private (ArcGIS), crowd source (Mobile/Safety) API. |
| **Environmental Air Quality** | B | 4 | Harmful to parent and baby if too low | EPA or state/local environmental agencies API. |
| **Environmental Pollen** | B | 4 | Harmful to parent and baby if too high | Gov (WAQI), private (allergy/med sites, weather channel). NAMS is excel main 2023-present; API may be available for others. |
| **Safety Curb** | B | 4 | Barrier between traffic and sidewalk | Open Street Map, Local maps. |
| **Safety Incidents, Animal Attacks** | B | 3 | Safer to avoid areas with high incident count | Law enforcement records may be sparsely available. Nextdoor scraper. |
| **Safety Loose Animal Reports** | B | 3 | Common loose animals could be recurring in an area | Law enforcement records may be sparsely available. Nextdoor scraper. |
| **Infrastructure Sidewalk, Condition, Cracks** | C | 2 | Too rough condition not suitable for stroller | Local Sidewalk Replacement Program requires internal