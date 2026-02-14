
## Wk 5 Assignment
##### David Smith
--

### Problem Space

 During my time as a Florissant, MO resident, I've been inspired to get invovled in local government in a few ways: I did a few projects with the City's GIS Team with their Engineering Department and served a term on the Planning and Zoning Commission. As a student, I put some of my database skills to the test during a previous semester by analyzing traffic accident data. This project mostly fell to the side until one key change in my life: I'll soon be a father for the first time. This means not only will I need to know more about where it's safe to drive, I'll need to know where it's safe to *walk*. 

 My problem space explores where the best and safest spots are to walk in select neighborhoods in St. Louis. I'll choose Florissant as well as a few prospective locations for moving to, especially if we don't make the cut for a safe walk around the block.

---
### Data Inventory

| Data Item | Importance (A/B/C) | Accessibility (1-4) | Why it's important | Why it's accessible (or not) |
| :--- | :---: | :---: | :--- | :--- |
| **Traffic Speed**	| A	| 4	| Speed could correlate with control and accident severity	| Private, state, or county level tracking available. Could be accessible through APIs |
| **Traffic Accidents, Pedestrian**	| A	| 4	| Areas with higher count could be more dangerous	| Incidents reported to law enforcement (MSHP) as tabular and pdf reports. A bit disjointed. |
| **Traffic Activity**	| A	| 4	| Busy traffic unpleasant, potential for danger	| Google or Waze API -- not sure of complexity |
| **Amentities Rest Spot, Bench**	| A	| 4	| Good spot to rest, address baby unknowns	| Open Street Map might have this -- data mining with Overpass QL or analysis with OSMnx (Python) |
| **Environmental Weather**	| A	| 4	| Walking in temperate weather preferred, safer	| NWS, Open-Meteo, or other API. Constantly available. Would need historic and forecasting |
| **Infrastructure Sidewalk, Size, Breaks/Gaps**	| A	| 2	| More gaps means more street crossing	| Open Street Map or local gov geospatial data |
| **Environmental Shade**	| B	| 3	| Babies can't have full sun	| Can check plant cover aerial photos/maps |
| **Infrastructure Sidewalk, Condition, Environment**	| A	| 2	| Env should be suitable for a stroller	| Plant cover aerial photos, nextdoor web scraper |
| **Safety Temporal, Time to walk**	| A	| 1	| Increase confidence, preparation. 	| Mostly determined by other factors, not accessible at onset |
| **Safety Crime Stats, Sex Offenders**	| B	| 4	| Overall safety, staying away from convicted criminals	| Geospatial or API from law enforcement website |
| **Safety Crime Stats, Assault**	| B	| 4	| Safer to avoid high crime areas	| Geospatial or API from law enforcement website |
| **Infrastructure Sidewalk, Dist. From Road**	| B	| 4	| May provide buffer from traffic incidents	| Dist. Measure from aerial photos/maps or local gov right of way maps |
| **Infrastructure Sidewalk, Visibility, Slope**	| B	| 4	| Steepness affects fatigue, visibility during walk	| Geospatial elevation data |
| **Traffic Intersection, Type**	| B	| 4	| More complicated = distracted drivers	| Open Street Map, computer vision/classification |
| **Safety Crosswalks**	| B	| 4	| Option to cross provides path flexibility on walk	| Open Street Map has this |
| **Infrastructure Traffic Signals**	| B	| 4	| Stops may make drivers aware of surrounding pedestrians	| Open Street Map has this |
| **Amentities Parking**	| B	| 4	| Need safe spot if away from home	| Park website, Open Street Map, aerial photo |
| **Amentities Rest Spot, Water fountain**	| B	| 4	| Hydration for parents and baby	| Open Street Map has this |
| **Practical Baby, Mode of Transport**	| B	| 4	| Stroller needs nicer sidewalks; carrier needs shorter walks	| Self-reported data, categorical, two types: carrier or stroller |
| **Environmental Noise pollution**	| B	| 4	| Unpleasant or harmful if too loud	| Fed (BTS, NOAA), private (ArcGIS), crowdsource (NoisePlanet) APIs |
| **Environmental Air Quality**	| B	| 4	| Harmful to parent and baby if too low	| EPA or state/local environmental agencies--API. |
| **Environmental Pollen**	| B	| 4	| Harmful to parent and baby if too high	| Gov (NAB), private (allergy med sites, weather channel). NAB is excel from 2003-present. API may be available for others. |
| **Safety Curb**	| B	| 4	| Barrier between traffic and sidewalk	| Open Street Map, local maps |
| **Safety Incidents, Animal Attacks**	| B	| 3	| Safer to avoid areas with high incident count	| Law enforcement records may be sparsely available, Nextdoor scaper |
| **Safety Loose Animal Reports**	| B	| 3	| Common loose animals could be recurring in an area	| Law enforcement records may be sparsely available, Nextdoor scaper |
| **Infrastructure Sidewalk, Condition, Cracks**	| B	| 2	| Too rough condition not suitable for stroller	| Local Sidewalk Replacement Program requires internal data. |
| **Infrastructure Sidewalk, Size, Width**	| B	| 2	| Wider sidewalk accommodates passing, comfort	| Local code or aerial photos/maps. Calculate avg. width per area. |
| **Outdoors Sidewalk, Foot Traffic**	| B	| 2	| Too busy may be cumbersome, cause pedestrian to take more risks	| Nextdoor, StreetLight data, Placer.ai -- might need to pay |
| **Safety Crime Stats, Robbery**	| C	| 4	| Avoiding high-crime areas for security and safety	| Law enforcement has this data |
| **Traffic Accidents, Property**	| C	| 4	| Implies lower attention from drivers or more dangerous conditions	| Incidents reported to law enforcement (MSHP) |
| **Safety Bollards**	| C	| 4	| Barrier between traffic and sidewalk	| Aerial photos/maps or Open Street Maps |
| **Amentities Rest Spot, Park**	| C	| 4	| Optional fun for a break and community building	| Open Street Maps |
| **Amentities Rest Spot, Covered pavilion**	| C	| 4	| Cover from elements, rest, address unknowns	| Open Street Maps |
| **Internal Parent, Experience**	| C	| 2	| More experience (more children?) might affect readiness for unknowns	| Self-reported, impractical to gather |
| **Infrastructure Activity, Construction**	| C	| 2	| Difficult to navigate, may increase pedestrian risk-taking	| Difficult to get recent data |
| **Infrastructure Sidewalk, Visibility, Turns**	| C	| 1	| Longer line of sight prepares walker for what's next	| Less useful overall, could calculate turns in mapping |
| **Internal Parent, Fatigue**	| C	| 1	| Tired parents are less focused, thoughtful	| Self-reported, impractical to gather |

---
### Importance-Accessibility Matrix

| | **Readily Accessible** | **Difficult to Access** |
| :--- | :--- | :--- |
| **Critically Important** | Traffic Speed<br>Traffic Accidents, Pedestrian<br>Traffic Activity<br>Amenities Rest Spot, Bench<br>Environmental Weather<br>Environmental Shade<br>Safety Crime Stats, Sex Offenders<br>Safety Crime Stats, Assault<br>Infrastructure Sidewalk, Dist. From Road<br>Infrastructure Sidewalk, Visibility, Slope<br>Traffic Intersection, Type<br>Safety Crosswalks<br>Infrastructure Traffic Signals<br>Amenities Parking<br>Amenities Rest Spot, Water fountain<br>Practical Baby, Mode of Transport<br>Environmental Noise pollution<br>Environmental Air Quality<br>Environmental Pollen<br>Safety Curb<br>Safety Incidents, Animal Attacks<br>Safety Loose Animal Reports | Safety Temporal, Time to walk<br>Infrastructure Sidewalk, Condition, Cracks<br>Infrastructure Sidewalk, Size, Width<br>Outdoors Sidewalk, Foot Traffic |
| **Probably Not Needed** | Infrastructure Sidewalk, Size, Breaks/Gaps<br>Environmental Shade<br>Infrastructure Sidewalk, Condition, Environment<br>Safety Incidents, Animal Attacks<br>Safety Loose Animal Reports<br>Safety Crime Stats, Robbery<br>Traffic Accidents, Property<br>Safety Bollards<br>Amenities Rest Spot, Park<br>Amenities Rest Spot, Covered pavilion | Internal Parent, Experience<br>Infrastructure Activity, Construction<br>Infrastructure Sidewalk, Visibility, Turns<br>Internal Parent, Fatigue |
---
### Reflection
This assignment helped prioritize and order what was quickly becoming an overwhelming amount of potential data. I found it was most helpful for me to take time in each break to remind myself what my core objective was and how I thought what I was doing/collecting was getting me there. When dealing with a lot of data it's easy to start to pick apart things that aren't mission-critical. This also puts a specific label on data groups that gives me more confidence in case I think during the project I need something that I don't--I can look at that data (let's say sidewalk construction data) and acknowledge that I've reviewed it and found it non-critical, then get back to focusing on the important work. I struggle with scaling my *own* energy horizontally rather than vertically sometimes, so an exercise like this helps compartmentalize steps in an effortful, strategic way.
