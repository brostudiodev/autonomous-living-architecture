---
title: "Automation Specification Template"
type: "automation_spec_template"
status: "active"
updated: "2026-02-10"
---

# Automation Specification Template

This template provides a standardized format for documenting all automations in the autonomous living system.

## File Naming Convention

### n8n Workflows
- **Format:** `WFnnn__descriptive-name.md`
- **Location:** `docs/50_AUTOMATIONS/n8n/workflows/`
- **Example:** `WF103__finance-data-ingestion-pipeline.md`

### Python Scripts
- **Format:** `script-name.md`
- **Location:** `docs/50_AUTOMATIONS/scripts/`
- **Example:** `enhanced-transaction-categorization.md`

### Home Assistant Automations
- **Format:** `automation-name.md`
- **Location:** `docs/50_AUTOMATIONS/home-assistant/`
- **Example:** `smart-lighting-schedules.md`

## Template Structure

Copy this template and fill in the sections for each automation:

```markdown
---
title: "{ID}: {Name}"
type: "automation_spec"
status: "active"
automation_id: "{ID}__{name}"
goal_id: "goal-gXX"
systems: ["SXX", "SYY"]
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# {ID}: {Name}

## Purpose
One-sentence description of what this automation does.

## Triggers
- **When:** Scheduled daily at 23:00 UTC
- **Or:** Webhook from external service
- **Or:** Manual execution via Obsidian hotkey

## Inputs
- Obsidian daily note: `YYYY-MM-DD.md`
- Config file: `config.yaml`
- Environment variables: `GITHUB_TOKEN`, `VAULT_PATH`

## Processing Logic
1. Parse daily note YAML frontmatter
2. Extract checked goals with activity content
3. Generate JSON telemetry
4. Update goal-specific activity logs
5. Commit and push to Git

## Outputs
- JSON log: `_meta/daily-logs/YYYY-MM-DD.json`
- Activity logs: `goal-gXX/ACTIVITY.md` (updated)
- Git commit: `Daily sync: YYYY-MM-DD`

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [S10 Daily Goals Automation](../../20_SYSTEMS/S10_Daily-Goals-Automation/README.md)

### External Services
- GitHub API (authentication via SSH key)
- Obsidian vault (file system access)

### Credentials
- GitHub SSH key (stored: `~/.ssh/id_ed25519`)
- No secrets in code or Git

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Git conflict | `git push` fails | Nuclear reset to `origin/main`, retry | Log warning |
| Parse error | Invalid YAML | Skip file, log error | Notify via Obsidian |
| Missing vault | Path not found | Exit with error code 1 | User must fix path |

## Monitoring
- Success metric: Daily JSON log created
- Alert on: 2 consecutive failures
- Dashboard: (link to monitoring dashboard when available)

## Manual Fallback
If automation fails:
```bash
cd autonomous-living
git pull origin main
# Manually create JSON log from daily note
# Manually update ACTIVITY.md
git add .
git commit -m "Manual sync: YYYY-MM-DD"
git push origin main
```

## Related Documentation
- SOP: Daily Review
- Runbook: Git-Conflict-Resolution
- System: S10 Daily Goals Automation
```

## Quality Checklist

When creating automation documentation, ensure:

- [ ] All sections are filled out
- [ ] Cross-references use correct relative paths
- [ ] Error handling covers main failure scenarios
- [ ] Manual fallback is documented and tested
- [ ] Monitoring metrics are defined
- [ ] Dependencies are clearly listed
- [ ] Goal ID follows `goal-gXX` format
- [ ] System IDs follow `SXX` format
- [ ] Automation ID follows naming convention

## Common Patterns

### Data Processing Automations
- Input: File/API/database
- Processing: Transform/clean/analyze
- Output: Updated database/file/notification
- Error handling: Data validation, retry logic

### Monitoring Automations
- Input: System metrics/logs
- Processing: Threshold checking, alert generation
- Output: Notifications, dashboard updates
- Error handling: Alert delivery failures

### Synchronization Automations
- Input: Source system data
- Processing: Data mapping, conflict resolution
- Output: Target system updates
- Error handling: Network issues, data conflicts

## Integration Points

### With Goals
Every automation should reference the goal(s) it supports in the `goal_id` field.

### With Systems
List all systems that the automation interacts with in the `systems` field.

### With SOPs
Reference relevant Standard Operating Procedures for manual processes.

## Maintenance Guidelines

### Regular Updates
- Update documentation when automation logic changes
- Review error handling quarterly
- Update dependencies when systems change

### Version Control
- Commit documentation changes with automation changes
- Use descriptive commit messages
- Tag releases for major automation updates

## Examples

See these existing automation specifications for examples:

- [WF103__finance-data-ingestion-pipeline.md](../n8n/workflows/WF103__finance-data-ingestion-pipeline.md)
- [WF104__digital-twin-data-ingestion.md](../n8n/workflows/WF104__digital-twin-data-ingestion.md)
- [enhanced-transaction-categorization.md](../scripts/enhanced-transaction-categorization.md)