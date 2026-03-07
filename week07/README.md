# AI-Driven Paradigm: Prompt Log & Workflow Summary

**Objective:** Utilize Large Language Model (LLM) prompting to accelerate SQL development, debug spatial data anomalies, acquire domain knowledge, and troubleshoot syntax for the EV Pilot Location assignment.

## Part 1: Pair-Programming & Logic Development (Gemini AI)

### Phase 1: Code Explanation & Debugging 
* **The Ask:** I provided a complex spatial SQL Common Table Expression (CTE) calculating Euclidean distance and headings, asking for a line-by-line explanation. I also prompted the AI to debug coordinate data around the St. Louis area that appeared to be off by a factor of 10 (e.g., `-9.0` instead of `-90.0`).
* **The Output:** The AI broke down the `ST_POINTN` and `ATAN2` math. It explained the difference between Cartesian angles and navigational compass headings, providing the mathematical workaround to map directions to a standard 360-degree compass. It also identified the coordinate anomaly as native scientific notation (`e+01`), confirming the data was safe to query without manual modification.

### Phase 2: Domain Knowledge Acquisition
* **The Ask:** To properly score the "Proximity to power infrastructure" criteria, I asked for an explanation of how substations work compared to transmission lines.
* **The Output:** The AI provided an analogy-driven breakdown of the electrical grid, explaining that transmission lines act as high-voltage interstates, while substations act as step-down transformers to make the voltage safe for local distribution. This validated the decision to filter specifically for substations in the SQL logic.

### Phase 3: Code Consolidation (Declarative Development)
* **The Ask:** I supplied a series of disconnected SQL draft queries, my working notes, and the assignment constraints. I asked the AI to consolidate them into a logical order using `CASE` flags to calculate a final suitability score for EV chargers.
* **The Output:** The AI refactored the disparate queries into a single, highly optimized SQL script using CTEs. It applied `COALESCE` to handle nulls and successfully joined data across the Traffic, Incidents, Weather, Environment, Power, and Road tables to generate an aggregated `SUITABILITY_SCORE`.

### Phase 4: Advanced Logic & Iteration
* **The Ask:** I prompted the AI to push the logic further by finding continuous stretches of high-scoring roads (scores of 4 or 5). I later asked to dynamically assign Level 1, Level 2, or Level 3 chargers based on the length of those continuous stretches.
* **The Output:** The AI introduced a "Gaps and Islands" window function technique to group sequential road segments. *Crucially, the AI also provided a physical reality check, noting that driving at 30 mph consumes more energy than Level 1 or Level 2 chargers can output, meaning an in-motion system inherently requires Level 3 DC Fast Charging regardless of lane length.* We ultimately reverted to the base scoring model based on this physical constraint.

### Phase 5: Cross-Paradigm Integration (Imperative Integration)
* **The Ask:** I asked how to combine the finalized declarative SQL script with imperative Python code.
* **The Output:** The AI generated a Python `pandas` pipeline that establishes a database connection, executes the declarative SQL string, explicitly sorts the results in memory to isolate the top 4 locations, and writes the output to the required `SEGMENTS.csv` file.

---

## Part 2: Snowflake Native AI Assistant Log

**Objective:** Utilize Snowflake's native AI assistant to rapidly iterate on specific CTEs, engineer new features, and troubleshoot syntax and data type errors in real-time.

### Feature Engineering (Environmental & Speed Flags)
* **The Ask:** I prompted the AI to update an environmental query to use a `CASE` statement (flagging wetlands/protected areas as `1` and others as `0`) and later asked it to write a standalone query flagging road segments with speed limits under 70 mph. 
* **The Output:** The AI successfully structured the `LEFT JOIN` to ensure all 103 segments were evaluated, creating an `ENV_FLAG`. It also generated a separate query that created a `LOW_SPEED_FLAG`, correctly identifying that the low-speed highway segments clustered near the major urban endpoints (St. Louis, Chicago, KC).

### Refining Safety Metrics (Crash vs. Incident Rates)
* **The Ask:** I initially asked for a column showing the correlation between `CRASH_RATE` and `INCIDENT_RATE`. Realizing the `CORR()` window function returned a static value for the whole dataset, I pivoted and asked the AI to calculate what percentage the incident rate was of the crash rate, and to flag segments where both rates were above average.
* **The Output:** The AI updated the query to calculate `INCIDENT_PCT_OF_CRASH` (revealing incidents were roughly 3-9% of crashes) and created a `HIGH_DANGER_FLAG` to isolate the 34 most dangerous road segments to avoid when placing chargers.

### Syntax & Logic Debugging
* **The Ask:** I fed two specific SQL compilation errors directly into the chat: an `unexpected 'WITH'` syntax error, and a `Numeric value 'I55-004' is not recognized` casting error. 
* **The Output:** The AI accurately diagnosed both issues. For the syntax error, it explained that chained CTEs must be separated by commas rather than repeating the `WITH` keyword. For the casting error, it recognized that the system was trying to perform mathematical subtraction on a string (`I55-004`). It provided the exact `SPLIT_PART()` logic needed to isolate the numeric suffix before casting it as an integer, allowing the window functions to run properly.