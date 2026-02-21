---
title: "WF105__generate-activity-summaries"
type: "automation_spec"
status: "active"
automation_id: "WF105__generate-activity-summaries"
goal_id: "goal-g09"
systems: ["S03", "S08"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-10"
---

# WF105: Generate Activity Summaries

## Purpose
Automatically generate milestone-level Activity.md summaries from daily Activity-log.md entries across all 12 goals in the autonomous-living repository.

## Triggers
- **When:** Scheduled weekly on Sundays at 20:00 UTC (Schedule Trigger)
- **Or:** Manual execution via n8n interface (Manual Trigger)
- **Or:** Manual execution via webhook POST to `/activity-summary` endpoint

## Inputs
- **Source Repository:** brostudiodev/autonomous-living (GitHub)
- **Goal Folders:** 12 predefined goals with paths:
  - G01: Target Body Fat
  - G02: Automationbro Recognition
  - G05: Autonomous Financial Command Center
  - G03: Autonomous Household Operations
  - G04: Digital Twin Ecosystem
  - G06: Certification Exams
  - G07: Predictive Health Management
  - G08: Predictive Smart Home Orchestration
  - G09: Complete Process Documentation
  - G10: Automated Career Intelligence
  - G11: Intelligent Productivity Time Architecture
  - G12: Meta-System Integration Optimization
- **Date Range:** Last 7 days from current date
- **File Format:** Activity-log.md with structured daily entries

## Processing Logic
### Main Workflow Flow
1. **Initialize Goals List:** Create array of 12 goals with IDs, names, and folder paths
2. **Loop Through Goals:** Process each goal individually using Split in Batches
3. **Fetch Activity Log:** Get Activity-log.md from GitHub repository
4. **Extract Text Content:** Use Extract from File node to get readable content
5. **Process Activity Entries:**
   - Parse daily entries with format `## YYYY-MM-DD (Day)`
   - Extract **Action:** items and bullet points
   - Filter entries from last 7 days
   - Generate milestone summary from activities
6. **Check for Activity:** If no activity found, skip to next goal
7. **Handle Activity.md File:**
   - Check if existing Activity.md file exists
   - If exists: Extract content and merge new weekly entry
   - If new: Create complete file with frontmatter and initial entry
8. **Update Repository:** Commit updated content to GitHub with descriptive message
9. **Collect Results:** Track status for each goal (updated/skipped/no_activity)
10. **Generate Final Report:** Create summary statistics and send notification

### Key Processing Features
- **Date Range Calculation:** Automatically calculates last 7 days from execution date
- **Week ID Generation:** Creates YYYY-WXX format for weekly tracking
- **Duplicate Prevention:** Skips if week already processed in Activity.md
- **Error Handling:** Continues processing even if individual goals fail
- **Content Merging:** Inserts new entries after frontmatter in existing files

## Outputs
- **Updated Activity.md files:** `docs/10_Goals/GXX_*/Activity.md` in GitHub repository
- **Weekly Summary Report:** Generated as final workflow output with:
  - Total goals processed
  - Updated goals count
  - Skipped goals count
  - No activity goals count
  - Per-goal status with reasons
- **GitHub Commits:** Individual commits for each updated Activity.md with format `=WF105: Weekly activity summary for GOALID - YYYY-WXX`
- **Webhook Response:** JSON response with full report details for webhook trigger
- **Slack Notification:** (Currently disabled) Summary highlights sent to Slack channel

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - For activity log storage structure
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - For workflow execution

### External Services
- **GitHub API:** For file operations (GET/EDIT) on brostudiodev/autonomous-living repository
- **Slack API:** For summary notifications (currently disabled)
- **n8n Platform:** Workflow execution and scheduling

### Credentials
- **GitHub API Token:** Stored as "GitHub account" credential in n8n
- **Slack Webhook:** Stored in n8n credentials (node disabled)
- **Repository Access:** Read/write permissions to brostudiodev/autonomous-living

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Activity-log.md | GitHub API 404 error | Continue to next goal | Include as "no_activity" in report |
| GitHub API failure | API request error | Use `onError: continueRegularOutput` | Log in final summary |
| Invalid markdown format | Parse error in Code node | Skip malformed entry, continue processing | Log error details in debug |
| File exists check fails | Binary data missing | Route to new file creation | Automatic handling |
| Duplicate week processed | Week ID already exists | Skip update, mark as "skipped" | Include in summary report |
| GitHub commit fails | Git push error | Continue processing other goals | Include error in final report |
| Extract from File fails | Text extraction error | Skip goal, mark as failed | Include in statistics |

### Error Recovery Mechanisms
- **Individual Goal Isolation:** Failed goals don't stop processing of other goals
- **Continuation on Error:** Most nodes configured with `continueRegularOutput`
- **Status Tracking:** Each goal result categorized as updated/skipped/no_activity/failed
- **Final Reporting:** All errors and successes compiled in summary report

## Monitoring
- Success metric: All Activity.md files updated weekly
- Alert on: 3+ consecutive failures
- Dashboard: Link to n8n execution history

## Manual Fallback
If automation fails:
```bash
# 1. Clone or navigate to repository
cd autonomous-living/docs/10_Goals

# 2. For each goal folder (G01, G02, G03, etc.):
#    a. Review last 7 days of Activity-log.md entries
#    b. Look for patterns: ## YYYY-MM-DD (Day) followed by **Action:** items
#    c. Extract significant activities and milestones
#    d. Create or update Activity.md with new weekly section:
#       ## YYYY-WXX: [Milestone Summary]
#       [Detailed description of achievements]
#    e. Add proper frontmatter if creating new file

# 3. Commit changes with standard format:
git add docs/10_Goals/*/Activity.md
git commit -m "Manual: Weekly activity summary updates - YYYY-WXX"
git push origin main
```

### Weekly Summary Template
```markdown
## 2026-W07: Major Platform Integration Milestone

This week marked significant progress in autonomous system integration, with the successful deployment of the [specific achievement]. Key accomplishments include:

- **Architecture Enhancement:** [Specific technical improvement]
- **Process Optimization:** [Workflow or automation improvement] 
- **Documentation Updates:** [Knowledge base advancement]
- **Testing & Validation:** [Quality assurance activities]

The implementation has been validated through [testing method] and is now ready for [next phase].
```

## Related Documentation
- [Goal Documentation Standard](../10_Goals/Documentation-Standard.md)
- [Automation Specification Template](../templates/automation-specification-template.md)
- [S03 Data Layer README](../20_Systems/S03_Data-Layer/README.md)

## Implementation Details

### Node Configuration
**Trigger Nodes:**
- `Manual Trigger` - When clicking 'Execute workflow'
- `Schedule Trigger` - Weekly Sundays 20:00 UTC
- `Webhook Trigger` - POST /activity-summary endpoint

**Core Processing Nodes:**
- `Prepare Goals List` - Defines 12 goals with paths and calculates date range
- `Loop Over Goals` - Split in Batches for individual goal processing
- `GitHub Get Activity Log` - Fetches Activity-log.md from repository
- `Extract from File` - Converts binary data to readable text
- `Process Activity Log` - Parses entries, extracts 7-day activities, generates milestone summary

**File Management Nodes:**
- `GitHub Get Existing Activity.md` - Checks for existing summary file
- `Check File Exists` - Code node determines if binary data present
- `Extract Existing Activity.md` - Gets current content for merging
- `Prepare Update (Existing File)` - Merges new entry with existing content
- `Prepare Update (New File)` - Creates complete file with frontmatter
- `GitHub Update Activity.md` - Commits changes to repository

**Results & Reporting:**
- `Generate Summary Report` - Creates final statistics and overview
- `Send Slack Notification` - (Disabled) Notification delivery
- `Webhook Response` - Returns JSON report for webhook triggers

### Content Processing Logic
**Activity Log Parsing:**
1. Split content by lines and identify date headers (`## YYYY-MM-DD`)
2. Extract **Action:** items and bullet points for each date
3. Filter entries within 7-day date range
4. Combine activities into milestone narrative with achievement descriptions

**File Management Strategy:**
1. Check if Activity.md exists in goal folder
2. If exists: Extract content, locate insertion point after frontmatter, insert new week entry
3. If new: Create file with standard frontmatter and initial entry
4. Prevent duplicate processing by checking for existing week ID

**Frontmatter Template:**
```yaml
---
title: "[Goal Name] - Activity Summary"
type: "activity_summary"
goal_id: "[GOAL_ID]"
updated: "[YYYY-MM-DD]"
---
```

## Success Metrics
- **Coverage**: 100% of goals with activity logs processed
- **Quality**: Generated summaries match manual writing style
- **Timeliness**: Weekly summaries generated within 24 hours of week end
- **Accuracy**: No false milestone identification