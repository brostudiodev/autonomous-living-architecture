---
title: "Sync-to-Public System Documentation"
type: "system_documentation"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Sync-to-Public System

## **Purpose**

Automated synchronization system that transforms the private `autonomous-living` repository into the public `autonomous-living-architecture` repository by preserving architectural documentation while removing sensitive operational data and personal information.

## **Architecture Overview**

┌─────────────────────────────────────────────────────────┐
│ Private: autonomous-living                              │
│ • Full implementation details                           │
│ • Personal data and metrics                             │
│ • Production configurations                             │
│ • Daily activity logs                                   │
└────────────────┬────────────────────────────────────────┘
                 │
                 │ sync-to-public.py
                 │ • Content filtering
                 │ • Data sanitization
                 │ • Structure preservation
                 ▼
┌─────────────────────────────────────────────────────────┐
│ Public: autonomous-living-architecture                  │
│ • Architectural patterns                                │
│ • Design documentation                                  │
│ • Generic examples                                      │
│ • Educational content                                   │
└─────────────────────────────────────────────────────────┘


## **Security Model - Defense in Depth (Updated 2026-02-19)**

**Layer 1 - Path Exclusion:** Inherently private directories (logs, credentials, `.env`) are never copied.  
**Layer 2 - Global Content Sanitization:** Mandatory regex-based stripping for all `.md`, `.yml`, `.py`, and `.json` files.  
**Layer 3 - Keyword Protection:** Case-insensitive detection of `password`, `secret`, `token`, and `IPs`.  
**Layer 4 - Automated Compliance:** The script itself enforces these rules on every run.

## **Exclusion Policy**

### **Complete Path Exclusions**

The system follows a "Deny-by-Default" approach for known sensitive artifacts:

```python
EXCLUDE_PATHS = [
    '.git/',                    # Private history
    '.venv/',                   # Local environment
    '_meta/',                   # Daily logs/backups
    '.env',                     # Secrets
    'scripts/withings_tokens.json', # Auth tokens
    'scripts/google_credentials.json', # Service accounts
    'infrastructure/',          # Real infrastructure configs
]
```

## **Sanitization Rules (MANDATORY)**

For all allowed files, the following global replacements are enforced:

1. **Internal IPs:** All `192.168.x.x` addresses → `{{INTERNAL_IP}}`
2. **Secrets:** Any occurrence of `api_key`, `token`, `password`, `secret` (and common variations) followed by a value → `{{API_SECRET}}`
3. **Database Credentials:** Specific local defaults like `root` or `admin` in connection strings → `{{DB_USER}}` / `{{DB_PASSWORD}}`

## **What Gets Synchronized**

### **Preserved Documentation & Logic**
- ✓ Architectural Standards (ADRs, HLD, LLD)
- ✓ System Design Documentation
- ✓ Sanitized Python Scripts (Engine & API logic)
- ✓ Sanitized n8n Workflow Definitions (JSON)
- ✓ Standard Operating Procedures (SOPs)
- ✓ Standardized Goal READMEs (Outcomes, Systems, Metrics)

## **Operational Procedures**
Pre-Sync Checklist

Before running sync script:

    Private repo is clean: All changes committed
    Recent backup exists: _meta/backups/ has today's backup
    Public repo is ready: Target directory exists and is valid git repo
    Review recent changes: Check git log for accidentally committed secrets

Running the Sync

Standard execution:

```bash
cd ~/Documents/autonomous-living
python3 scripts/sync-to-public.py
```

Expected output:

```
Syncing from /home/{{USER}}/Documents/autonomous-living to /home/{{USER}}/Documents/autonomous-living-architecture
✅ Sanitized: docs/00_Start-here/Principles.md
✅ Sanitized: docs/20_Systems/S00_Homelab-Platform/Architecture.md
✅ Copied: docs/90_Attachments/diagrams/system_architecture.png
...
```

Post-Sync Verification

Critical verification steps:

```bash
cd ~/Documents/autonomous-living-architecture

# 1. Check for accidentally copied sensitive paths
find . -name "_meta" -o -name ".env" -o -name "docker-compose.yml"
# Expected: No results

# 2. Search for real IP addresses
grep -r "192\.168\." . --include="*.md" --include="*.yml"
# Expected: Only {{INTERNAL_IP}} placeholders

# 3. Search for email addresses
grep -r "@" . --include="*.md" | grep -v "{{EMAIL}}" | grep -v "mailto:"
# Expected: Only documentation emails

# 4. Search for API keys/tokens
grep -ri "api[_-]key\|token" . --include="*.md" --include="*.yml" | grep -v "{{API_SECRET}}"
# Expected: Only documentation references

# 5. Verify structure integrity
ls -la docs/
# Expected: All major directories present except 10_GOALS/
```

Git Commit and Push

After successful verification:

```bash
cd ~/Documents/autonomous-living-architecture

# Review changes
git status
git diff

# Stage and commit
git add .
git commit -m "Sync from private repo: $(date +%Y-%m-%d)

- Updated system documentation
- Added new ADRs
- Refreshed automation patterns
- All sensitive data sanitized and verified"

# Push to public GitHub
git push origin main
```

Safety Mechanisms
Rollback Procedure

If sync introduces problems:

```bash
cd ~/Documents/autonomous-living-architecture

# View recent commits
git log --oneline -5

# Rollback to previous commit
git reset --hard HEAD~1

# Force push if already pushed to GitHub
git push --force origin main
```

When to rollback:

    Sensitive data discovered after push
    Structural errors in synced content
    Broken links or missing files
    Sanitization patterns failed

Maintenance and Updates
Adding New Sanitization Patterns

When you discover new sensitive data patterns:

1. Document the pattern:

## New Pattern: Database Connection Strings
**Pattern found:** `postgresql://user:password@host:5432/database`
**Regex pattern:** `postgresql://[^:]+:[^@]+@[^:]+:\d+/\w+`
**Replacement:** `postgresql://{{DB_USER}}:{{DB_PASSWORD}}@{{DB_HOST}}:{{DB_PORT}}/{{DB_NAME}}`

2. Add to SANITIZE_PATTERNS and test thoroughly
Updating Exclusion Paths

When adding new private content types, update EXCLUDE_PATHS and document the reason for exclusion.
Quarterly Review Checklist

Every 3 months:

    Audit exclusion list: Are all sensitive paths still excluded?
    Test sanitization patterns: Run pattern tests on sample data
    Review recent commits: Check last 20 commits in private repo
    Update documentation: Ensure this README reflects current practices
    Verify public repo: Manually review for any leaked data
    Test rollback procedure: Ensure quick revert capability

Troubleshooting
Common Issues

Permission denied error:

`chmod -R u+w ~/Documents/autonomous-living-architecture/`

Git conflicts after sync:

```bash
cd ~/Documents/autonomous-living-architecture
git stash  # Save local changes
python3 ~/Documents/autonomous-living/scripts/sync-to-public.py
git stash pop  # Reapply if needed
```

Accidentally synced sensitive file:

```bash
# Remove from git history completely
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/sensitive/file.md"
  --prune-empty --tag-name-filter cat -- --all

# Force push to rewrite GitHub history
git push --force origin main
```

# 5. Update exclusion list in sync script

Integration with Daily Workflow
Recommended Sync Frequency

Weekly sync schedule:

    Day: Friday afternoon (end of work week)
    Timing: After final commit to private repo
    Duration: 5-10 minutes including verification

Trigger conditions for immediate sync:

    Major architectural decision documented (new ADR)
    Significant system documentation update
    New automation pattern worth sharing

Why Manual Process (Not Automated)

    Manual review is critical for verifying no sensitive data leaked
    Context awareness needed for architectural vs. personal content judgment
    Git commit messages matter for public repo user understanding
    Emergency stop capability allows immediate halt if issues discovered

Related Documentation

    System: S10 Daily Goals Automation
    ADR: Adr-0001: Repository Structure
    Standard: Goal Documentation Standard

Last Updated: 2026-02-04
Owner: {{OWNER_NAME}}
Status: Active
