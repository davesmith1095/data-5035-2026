# Project Reflection

## Paradigm Selection & Justification
* **Declarative (SQL):** I used SQL for my main data transformations and for establishing a suitability score for EV charging lanes. This paradigm is interpretable and segments project requirements (or business logic) in a way that that is pragmatic to rearrange, implement, review, update, and compile.
* **AI-Driven (LLM Prompting):** AI was my co-worker in programming: Snowflake AI helped debug work within my workspace, particularly issues that were caused by rearranging or updating code; Gemini helped with reviewing my draft code as a whole and reordering it into a logical structure for compilation

## Challenges Encountered
I write a lot of notes in my brainstorming and drafting before my code is ever written. I was disappointed to find that, after I asked Gemini to reorder my SQL statements from my draft, it dropped out (or replaced) much of my own words in the comments. While my notes are sometimes too verbose, I went back through and made sure all comments were rewritten in a way that makes sense to me and seems "user friendly". 

AI (or I) also had some challenges with incorporating context into the work. Some of the intent or implication in certain words like "risk" were lost. For example, Snowflake AI assumed the "weather risk" score meant that it was risk for...good(?) weather. I had to make some logical updates to the sql statement that misinterpretted this. Also, when I attempted to calculate the direction of road segments with some basic math on the points from the line segments, the returned value was in a planar/Cartesian (0-270) format rather than a more familiar compass (0-360) format. I think the Cartesian format was just more complicated than I needed to tell whether something was changing its angle. 

## Operational Risks & Independent Research

I did some independent research to gain more domain knowledge about electric vehicles and charging them. I referenced data from [SEPA](https://sepapower.org/knowledge/ev-charging-infrastructure/) and [Consumer Reports](https://www.consumerreports.org/cars/hybrids-evs/fastest-charging-electric-vehicles-a4112188427/). 

An operational risk that I considered but was unable to implement in the code was the rate of charge versus rate of consumption for EVs in their new lane. Different cars charge at different rates and I settled on assuming cars would charge about 7 miles-worth of kW per minute driving. This led to two more questions worth exploring: 1. What is the best level charge we can provide at scale? Levels 1 or 2 are lower grade charges but more stable, whereas a Level 3 is a faster charge but less available to most drivers. 2. How many sequential lanes can we get with a high suitability score? The more sequential lanes, the more flexibility we have with the type of charge that's offered, and could make implementation (and reputation) of the project more successful.

!! Last minute note: I had time to prompt AI to rework the very end of this and implement some of the segmented idea so that I could refine our final 4 site locations. 