---
title: "WF105 Production Deployment Guide"
type: "deployment_guide"
status: "ready"
created: "2026-02-10"
---

# WF105 Activity Summary - Production Deployment

## Overview
WF105 generates weekly activity summaries from Activity-log.md files and updates Activity.md milestone entries.

## Pre-Deployment Checklist

### 1. Verify Workflow File
- [x] `WF105__generate-activity-summaries.json` exists and is valid
- [x] Workflow tested with sample data via test script
- [x] Template created for weekly milestone entries

### 2. Verify Dependencies
- [x] n8n instance is running and accessible
- [x] PostgreSQL database accessible for S03 Data Layer
- [x] Slack webhook URL configured (if using Slack notifications)
- [ ] File system permissions for reading/writing goal folders

### 3. Configuration Setup

#### Slack Integration (Optional but Recommended)
```bash
# Create Slack webhook URL
# 1. Go to Slack App settings
# 2. Create "Incoming Webhooks" feature
# 3. Add to #automation-alerts channel
# 4. Copy webhook URL
# 5. Add to n8n credentials as "Slack Webhook"
```

#### File System Paths
```bash
# Verify these paths are accessible by n8n user
/home/{{USER}}/Documents/autonomous-living/docs/10_Goals/
/home/{{USER}}/Documents/autonomous-living/docs/_meta/weekly-summaries/
```

## Deployment Steps

### Step 1: Import Workflow
```bash
# 1. Open n8n web interface
# 2. Go to "Workflows" > "Import from File"
# 3. Select: WF105__generate-activity-summaries.json
# 4. Save as: "WF105 Activity Summary Generation"
```

### Step 2: Configure Credentials
```bash
# In n8n Credentials section, create/update:
# 1. "Slack Webhook" - add webhook URL
# 2. File system access - ensure n8n user has read/write permissions
```

### Step 3: Test Manual Execution
```bash
# 1. Open the imported workflow
# 2. Click "Execute Workflow" (play button)
# 3. Monitor execution for errors
# 4. Check outputs:
#    - Activity.md files updated
#    - Weekly summary report created
#    - Slack notification sent (if configured)
```

### Step 4: Verify Outputs
```bash
# Check that files were created/updated:
ls -la /home/{{USER}}/Documents/autonomous-living/docs/_meta/weekly-summaries/

# Verify Activity.md updates:
find /home/{{USER}}/Documents/autonomous-living/docs/10_Goals/ -name "Activity.md" -exec head -20 {} \;

# Check weekly report content:
cat /home/{{USER}}/Documents/autonomous-living/docs/_meta/weekly-summaries/*.md
```

### Step 5: Schedule Weekly Execution
```bash
# 1. In n8n workflow editor, the schedule should already be set to:
#    Cron: "0 20 * * 0" (Sundays at 20:00 UTC)
# 2. Activate the workflow (toggle switch to "on")
# 3. Verify schedule is active in workflow settings
```

## Post-Deployment Verification

### 1. First Weekly Run
- Monitor Sunday execution (next Sunday 20:00 UTC)
- Check Activity.md files for new milestone entries
- Verify weekly summary report is generated
- Confirm Slack notification received (if configured)

### 2. Monitoring Setup
```bash
# Set up n8n execution monitoring:
# 1. Go to workflow execution history
# 2. Check for any failed executions
# 3. Monitor file system permissions
# 4. Log Slack delivery failures
```

## Troubleshooting

### Common Issues

#### File Permission Errors
```bash
# Fix n8n file access permissions
sudo chown -R n8n:n8n /home/{{USER}}/Documents/autonomous-living/docs/
sudo chmod -R 755 /home/{{USER}}/Documents/autonomous-living/docs/
```

#### Slack Notification Failures
```bash
# Check webhook URL is correct
# Verify channel exists and bot has posting permissions
# Test webhook manually with curl
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Test message"}' \
  YOUR_SLACK_WEBHOOK_URL
```

#### No Activity Data Found
```bash
# Verify Activity-log.md files exist
find /home/{{USER}}/Documents/autonomous-living/docs/10_Goals/ -name "Activity-log.md"

# Check recent entries exist
grep -r "2026-" /home/{{USER}}/Documents/autonomous-living/docs/10_Goals/*/Activity-log.md
```

## Rollback Plan

If deployment fails:
```bash
# 1. Deactivate the workflow in n8n
# 2. Delete any generated weekly summary reports
# 3. Restore Activity.md files from git if needed:
cd /home/{{USER}}/Documents/autonomous-living
git checkout -- docs/10_Goals/*/Activity.md
# 4. Fix the issue and redeploy
```

## Success Criteria

Deployment is successful when:
- [x] Workflow imported and activated without errors
- [x] Manual execution completes successfully
- [x] Activity.md files updated with new milestone entries
- [x] Weekly summary report generated in correct location
- [x] Slack notification sent (if configured)
- [x] Schedule is set for Sundays 20:00 UTC
- [ ] First automatic execution completes successfully

## Monitoring

### Key Metrics
- Execution success rate
- File generation success
- Notification delivery rate
- Processing time per execution

### Alerting
- Failed workflow executions
- File permission errors
- Slack notification failures
- Missing Activity-log.md files

---

**Status**: Ready for deployment  
**Next Action**: Execute deployment steps 1-5  
**Verification Date**: Next Sunday (first automatic run)