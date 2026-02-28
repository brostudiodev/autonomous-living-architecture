---
title: "Weekly Milestone Template"
type: "template"
category: "activity_summary"
created: "2026-02-10"
---

# Weekly Milestone Entry Template

## {{ YEAR }}-W{{ WEEK_NUMBER }}: Weekly Progress

### Overview
{{ WEEK_SUMMARY }}

### Key Achievements
{% if MILESTONES.length > 0 %}
{% for milestone in MILESTONES %}
- **{{ milestone.type }}**: {{ milestone.description }}
  {% for example in milestone.examples %}
  - *{{ example.date }}*: {{ example.activity }}
  {% endfor %}
{% endfor %}
{% else %}
Continued development and maintenance activities this week.
{% endif %}

### Activities Summary
{% for activity in ACTIVITIES %}
- **{{ activity.date }}**: {{ activity.activity }}
{% endfor %}

### Metrics
- **Total Activities**: {{ TOTAL_ACTIVITIES }}
- **Major Milestones**: {{ MAJOR_MILESTONES }}
- **Week of**: {{ WEEK_START_DATE }} to {{ WEEK_END_DATE }}

### Next Steps
- [ ] Review weekly progress and adjust priorities
- [ ] Focus on next milestone objectives
- [ ] Update documentation as needed

---
*Generated automatically on {{ GENERATION_DATE }}*