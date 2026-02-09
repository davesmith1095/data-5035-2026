## Data Engineering - Assignment 04
### Universities Impacted by Severe Winter Weather (January 2026)

#### Process Review and Level-Setting
I started this assignment by picking a general category for universities to research. I opted for five of the states south of Missouri: **Arkansas, Alabama, Mississippi, Georgia, and Louisiana.** As with previous assignments, I bulleted my steps at the onset so that I could think through the process as I was gathering and reviewing data. I could tell immediately that the differences between the websites would be a challenge, so I focused on getting a steady connection (and ingestion) of data from **Open-Meteo** for weather data. 

After that was accomplished, I went through and looked at the Google Chrome "inspect" page for each of my websites. Some elements were very easy to find, not buried in deep structures, while others (like Tulane) used an **iframe** on their website. I was only vaguely familiar with what these were, but realized from reviewing the "inspect" page that this was referencing a PowerBI data source, and that I would not be able to use it for the HTML assignment. Fortunately, I had already requested access to Wikipedia for this assignment, and Tulane's Wiki page had the information I needed. 

I realized quickly that the layering and different structures would be a significant challenge. I went from citing a paragraph (`<p>`) to a list element, to simply relying on a search-word with regular expressions. I used this iterative search approach to find key words that helped me zero-in on the enrollment data, regardless of its location in the page. 

---

### Code Review
The structure of my code isn't exactly where I wanted it, but I'm overall proud. Not all of it was written directly from my brain, but I thought through the process, order, and efficiency with Gemini. 

* **Configuration:** I set up the configuration at the head of the code with a `places` dictionary that allowed fundamental setting of parameters for the weather extraction and university identification.
* **Ingestion:** I made my HTML call to the website and pulled back a high-level summary which had some nested dictionaries and lists for each day in January per school. I formatted the nested data as data frames grouped by their respective schools and concatenated them into a "final" data frame with monthly weather information. 
* **The `fetch_enrollment` Function:** The prized piece of this code is probably the `fetch_enrollment` function that works in combination with a scraping configuration dictionary and `for` loop to zero-in on enrollment information to add it back to the dictionary. 

Final touches on the `final_df` dataframe with my January weather data are adding the student population, state, and full university name from my, now enhanced, `places` dictionary.

---

### Analysis, Results, and Reflection
Analysis for the assignment is done with a function that uses snowfall, precipitation, ice accumulation, and temperature thresholds (**bespoke to southern severe weather standards based on NOAA website information**) to aggregate and display grouped weather data per university. 

This logic calculates the required **"Impacted Student-Days"** as well as the **Severe Dates**. I would have loved more time for this assignment, and I feel like I already sank in at least 8 hours, but I'm beginning to understand where the experience in all of this truly comes in handy.
