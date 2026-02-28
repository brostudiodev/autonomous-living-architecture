# G02 Automationbro Recognition - Content Performance Data

This directory stores data related to the performance of published content on platforms like Substack and LinkedIn.

## `performance.csv`

This CSV file is intended to manually record key metrics for content performance.

### Structure:
| Date       | Platform   | Article Title / ID | Open Rate (%) | New Subscribers | Article Views | Post Reach | Engagement Rate | Notes                           |
|------------|------------|--------------------|---------------|-----------------|---------------|------------|-----------------|---------------------------------|
| YYYY-MM-DD | Substack   | My Article Title   | 25.5          | 10              | -             | -          | -               | Initial data capture            |
| YYYY-MM-DD | LinkedIn   | Post about X       | -             | -               | 1200          | 5000       | 0.05            | Manual entry from LinkedIn stats|

### Manual Data Collection Process:
1.  **Weekly/Bi-weekly:** Log into Substack and LinkedIn analytics dashboards.
2.  **Extract Data:** Manually copy the relevant metrics (Open Rate, New Subscribers for Substack; Article Views, Post Reach, Engagement Rate for LinkedIn) for each published piece of content.
3.  **Record:** Enter the data into the `performance.csv` file, ensuring to fill in the correct `Date`, `Platform`, and `Article Title / ID`. Use "-" for metrics not applicable to a given platform.

## Automation (Future/Stretch Goal)

The long-term goal is to automate this data collection process. This will involve:
- Investigating API access for Substack and LinkedIn analytics.
- Developing n8n workflows to fetch data periodically.
- Storing the data in a more structured format (e.g., database) if volume increases.

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
