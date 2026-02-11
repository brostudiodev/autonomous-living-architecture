---
title: "Sync-to-Public System Documentation"
type: "system_documentation"
status: "active"
owner: "Michał"
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


## **Security Model - Defense in Depth**

**Layer 1 - Path Exclusion:** Complete directories/file types never copied  
**Layer 2 - Content Sanitization:** Pattern-based replacement of sensitive data  
**Layer 3 - Manual Review:** Pre-push verification of sanitized content  
**Layer 4 - Git History:** Public repo starts fresh, no private history

## **Exclusion Policy**

### **Complete Path Exclusions**

Your current `EXCLUDE_PATHS` configuration:

```python
EXCLUDE_PATHS = [
    '.git/',                    # Git metadata (private commit history)
    '.venv/',                   # Python virtual environment
    '__pycache__/',             # Python bytecode cache
    '_meta/',                   # Daily logs, backups (privacy-critical)
    '.env',                     # Environment variables
    '.py',                      # Python scripts (contains logic)
    'README.md',                # Root README (custom for public)
    'CHANGELOG.md',             # Private changelog
    'CONTRIBUTING.md',          # Private contribution guide
    'Enterprise_Documentation_Generator_Prompt.md',  # Internal prompts
    '.json',                    # All JSON files (configs, exports)
    'docs/10_GOALS/',           # Complete goals (too personal)
    'script.sh',                # Utility scripts
    'infrastructure/',          # Docker configs with real IPs/secrets
    '.github/',                 # GitHub Actions workflows
]
```

Critical Exclusions Explained:

`_meta/` - Contains daily activity logs with personal schedules, habits, behavioral patterns, and backup files with potentially sensitive historical data.

`docs/10_GOALS/` - Personal goal implementations contain health metrics, financial targets, career details, and household management specifics.

`.json` files - JSON exports contain n8n workflow credentials, Grafana dashboard configurations with real IP addresses, and data exports with actual measurements.

`infrastructure/` - Docker and infrastructure configs include real internal IP addresses, network topology, service ports, and environment variable references.
Sanitization Patterns

For files that are copied, these patterns replace sensitive data:

```python
SANITIZE_PATTERNS = [
    (r'192\.168\.\d+\.\d+', '{{INTERNAL_IP}}'),
    (r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', '{{EMAIL}}'),
    (r'(api[_-]?key|token)["\s:=]+["']?[\w-]+', r'\1: {{API_SECRET}}'),
]
```

What Gets Synchronized
Preserved Documentation Structure

```
docs/
├── 00_START-HERE/          ✓ Philosophy and principles
├── 20_SYSTEMS/             ✓ System architecture docs
├── 30_SOPS/                ✓ Standard operating procedures
├── 40_RUNBOOKS/            ✓ Incident response patterns
├── 50_AUTOMATIONS/         ✓ Workflow documentation
├── 60_DECISIONS_ADRS/      ✓ Architecture decision records
└── 90_ATTACHMENTS/         ✓ Diagrams and visuals
```

File Type Handling

Markdown files (.md): Content sanitized using regex patterns, structure preserved
YAML files (.yml, .yaml): Configuration structure preserved, sensitive values replaced
Other files: Binary files copied without modification
Operational Procedures
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
Syncing from /home/michal/Documents/autonomous-living to /home/michal/Documents/autonomous-living-architecture
✅ Sanitized: docs/00_START-HERE/Principles.md
✅ Sanitized: docs/20_SYSTEMS/S00_Homelab-Platform/Architecture.md
✅ Copied: docs/90_ATTACHMENTS/diagrams/system_architecture.png
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
    ADR: ADR-0001: Repository Structure
    Standard: Goal Documentation Standard

Last Updated: 2026-02-04
Owner: Michał
Status: Active
