# Daily Goals Automation System

**Version:** 2.4 (Cross-Platform Production)  
**Status:** Production Ready  
**Platforms:** Linux, Windows  
**Purpose:** Automated bridge between Obsidian Second Brain and autonomous-living execution repository

## System Overview

The Daily Goals Automation System transforms your Obsidian daily notes into structured execution data, maintaining perfect synchronization across all your devices while embodying your "Automation-First Living" philosophy.

### Architecture at a Glance

```mermaid
graph TD
    A[Obsidian Daily Note] -->|Ctrl+Shift+G| B[sync_daily_goals.py v2.4]
    B -->|Extracts| C[Checked Goals & Activities]
    B -->|Updates| D[YAML Frontmatter]
    B -->|Generates| E[JSON Telemetry Logs]
    B -->|Appends| F[Goal Activity Logs]
    B -->|Nuclear Git Sync| G[GitHub Repository]
    G -->|Cross-Platform| H[Linux & Windows Sync]

Core Capabilities

🤖 Automation-First Design:

    Zero manual Git operations required
    Self-healing conflict resolution
    Cross-platform path auto-detection
    Production-grade error handling

📊 Structured Data Generation:

    JSON telemetry for analytics and AI processing
    Markdown activity logs for human review
    YAML frontmatter for Obsidian integration
    Automatic backup creation

🌍 Cross-Platform Reliability:

    Identical operation on Linux and Windows
    Unicode/emoji support on all platforms
    Relative path architecture eliminates configuration drift
    Nuclear conflict resolution prevents Git issues

Quick Start
Prerequisites

    Python 3.8+ with PyYAML module
    Git configured with GitHub access
    Obsidian with Shell Commands plugin (recommended)

Folder Structure (Critical)

Documents/
├── Obsidian Vault/           # Your Second Brain
│   └── 99_System/scripts/    # Automation scripts location
└── autonomous-living/        # Your execution repository (this repo)

Daily Usage

    Fill daily note: Check goals you worked on, add "Did:" descriptions
    Trigger automation: Press Ctrl+Shift+G in Obsidian
    Verification: See success message, check created files
    Result: Perfect cross-platform synchronization automatically maintained

System Components
Input: Daily Note Format

## After Work – Power Goals

- [x] **G02** – [[P - Automation - Automationbro]]
    - **Did:** Published automation best practices article
    - **Next:** Create follow-up on AI integration patterns  
    - **Code:** `autonomous-living/goal-02/articles/`

Output: Structured Data

YAML Frontmatter:

goals_touched: ["[[P - Automation - Automationbro]]"]
goals_activities:
  G02:
    name: "P - Automation - Automationbro"
    did: "Published automation best practices article"
    next: "Create follow-up on AI integration patterns"
    code: "autonomous-living/goal-02/articles/"

JSON Telemetry:

{
  "date": "2026-01-18",
  "goals_summary": {"total_touched": 1},
  "activities": [{"id": "G02", "did": "Published...", "next": "Create..."}]
}

Activity Log:

## 2026-01-18 (Saturday)

**Action:** Published automation best practices article
**Next Step:** Create follow-up on AI integration patterns
**Code:** `autonomous-living/goal-02/articles/`

Configuration

Location: Obsidian Vault/99_System/scripts/config.yaml

# Minimal configuration - paths auto-detected
daily_notes_folder: "01_Daily_Notes"
create_backups: true
verbose_logging: true
auto_git_sync: true

Obsidian Integration

Shell Commands Setup:

    Command (Linux): python3 "{{vault_path}}/99_System/scripts/sync_daily_goals.py" --force
    Command (Windows): python "{{vault_path}}\99_System\scripts\sync_daily_goals.py" --force
    Working Directory: (leave empty)
    Hotkey: Ctrl+Shift+G

Nuclear-Proof Git Strategy

The system uses a fetch-reset strategy that eliminates merge conflicts:

    Fetch: Get latest remote state from other machines
    Reset: Align local Git history with remote (preserving generated files)
    Stage: Add newly created JSON and Markdown files
    Commit: Create clean commit on top of remote history
    Push: Send to GitHub with zero conflicts

Result: Both Linux and Windows can write simultaneously without conflicts.
File Locations
Generated Files

autonomous-living/
├── _meta/
│   ├── daily-logs/YYYY-MM-DD.json     # Machine-readable telemetry
│   └── backups/YYYY-MM-DD.md.bak      # Safety backups
├── goal-g01/ACTIVITY.md                # Goal-specific activity logs
├── goal-g02/ACTIVITY.md
└── goal-g12/ACTIVITY.md

Script Location

Obsidian Vault/
└── 99_System/scripts/
    ├── sync_daily_goals.py             # Main automation engine
    └── config.yaml                     # Configuration file

Quick Diagnostics

Test the system:

# Linux
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --verbose --force

# Windows  
cd "Obsidian Vault\99_System\scripts"
python sync_daily_goals.py --verbose --force

Verify results:

# Check JSON logs
ls -la autonomous-living/_meta/daily-logs/

# Check activity logs
ls -la autonomous-living/goal-g*/ACTIVITY.md

# Check Git sync
cd autonomous-living && git status

Related Documentation

    Installation Guide - Complete setup from scratch
    Troubleshooting Guide - Common issues and recovery
    Git Operations Reference - Manual commands for maintenance
    Architecture Deep Dive - Technical implementation details

Emergency Recovery

If automation fails:

cd autonomous-living
git fetch origin
git reset --hard origin/main  # Nuclear reset to match GitHub

If repository corrupted:

cd Documents
rm -rf autonomous-living
git clone git@github.com:yourusername/autonomous-living.git

Support

Before requesting help, run diagnostics:

python3 sync_daily_goals.py --verbose --force 2>&1 | tee debug.log

Submit issues with:

    debug.log file
    Operating system details
    Git repository status
    Daily note format sample

This system embodies "Automation-First Living" principles by eliminating manual overhead while maintaining perfect data integrity and cross-platform synchronization. It serves as the foundational infrastructure for your 2026 vision of complete life automation.


### **File 2: `docs/20_SYSTEMS/S10_Daily-Goals-Automation/Installation.md`**

```markdown
# Complete Installation Guide

Step-by-step setup of the Daily Goals Automation System from scratch on Linux and Windows.

## Prerequisites Checklist

### Required Software
- [ ] **Python 3.8+** installed and accessible from command line
- [ ] **Git** installed with GitHub authentication configured
- [ ] **Obsidian** installed
- [ ] **Shell Commands** plugin for Obsidian (recommended)

### Verification Commands
```bash
# Check installations
python3 --version  # Linux (should be 3.8+)
python --version   # Windows (should be 3.8+)
git --version
ssh -T git@github.com  # Should show successful authentication

Phase 1: Repository Setup
Folder Structure Creation

Critical Requirement: Both repositories must be siblings in the same parent directory.

Linux:

cd ~/Documents

# Clone repositories as siblings
git clone git@github.com:yourusername/michal-second-brain-obsidian.git "Obsidian Vault"
git clone git@github.com:yourusername/autonomous-living.git

# Verify structure
ls -la
# Expected output:
# drwxr-xr-x  Obsidian Vault/
# drwxr-xr-x  autonomous-living/

Windows:

cd C:\Users\%USERNAME%\Documents

git clone git@github.com:yourusername/michal-second-brain-obsidian.git "Obsidian Vault"
git clone git@github.com:yourusername/autonomous-living.git

dir
REM Expected: Both folders visible

Repository Verification

# Verify Git remotes
cd "Obsidian Vault" && git remote -v
cd ../autonomous-living && git remote -v

# Both should show GitHub URLs

Phase 2: Python Environment Setup
Install Dependencies

Linux:

# Install PyYAML
python3 -m pip install --user PyYAML

# Verify installation
python3 -c "import yaml; print('✅ PyYAML:', yaml.__version__)"

Windows:

REM Install PyYAML
python -m pip install PyYAML

REM Verify installation
python -c "import yaml; print('✅ PyYAML:', yaml.__version__)"

Troubleshoot Python Issues

"Python not found" on Windows:

    Reinstall Python from python.org
    ✅ Check "Add Python to PATH" during installation
    Restart Command Prompt
    Test: python --version

Permission errors on Linux:

# Use user installation
python3 -m pip install --user PyYAML

# Or system-wide (if preferred)
sudo python3 -m pip install PyYAML

Phase 3: Script Installation
Create Automation Script

Navigate to scripts directory:

cd "Obsidian Vault/99_System/scripts"

Create sync_daily_goals.py: (Copy the complete v2.4 script from the main documentation)

Create config.yaml:

# Daily Goals Automation Configuration
daily_notes_folder: "01_Daily_Notes"
create_backups: true
verbose_logging: true
auto_git_sync: true

Set Permissions (Linux)

chmod +x sync_daily_goals.py

Initial Test

# Linux
python3 sync_daily_goals.py --version

# Windows
python sync_daily_goals.py --version

# Expected output: Version information and system details

Phase 4: Obsidian Integration
Install Shell Commands Plugin

    Open Obsidian
    Settings → Community plugins → Browse
    Search: "Shell Commands"
    Install → Enable

Configure Command

Create new command:

    Settings → Shell Commands → New command
    Alias: Sync Daily Goals

Platform-specific settings:

Linux Configuration:

    Command: python3 "{{vault_path}}/99_System/scripts/sync_daily_goals.py" --force
    Working directory: (leave empty)
    Shell: /bin/bash

Windows Configuration:

    Command: python "{{vault_path}}\99_System\scripts\sync_daily_goals.py" --force
    Working directory: (leave empty)
    Shell: cmd.exe

Assign Hotkey

    Settings → Hotkeys
    Search: "Shell Commands: Sync Daily Goals"
    Assign: Ctrl+Shift+G

Test Integration

    Press Ctrl+Shift+G in Obsidian
    Expected: Success notification appears
    Verify: Check autonomous-living/_meta/daily-logs/ for new files

Phase 5: Cross-Platform Synchronization
Establish Clean Git State

On primary machine (e.g., Linux):

cd autonomous-living
git push --force origin main
git status  # Should show "working tree clean"

On secondary machine (e.g., Windows):

cd autonomous-living
git fetch origin
git reset --hard origin/main
git status
REM Should show "working tree clean"

Verify Synchronization

# Both machines should show identical commit hashes
git rev-parse HEAD

# Both should show same recent commits
git log --oneline -3

Phase 6: Production Testing
Create Test Daily Note

Create: 01_Daily_Notes/2026-01-18.md (use today's date)

Content:

---
date: 2026-01-18
weekday: Saturday
---

# 2026-01-18 – Daily

## After Work – Power Goals

- [x] **G02** – [[P - Automation - Automationbro]]
    - **Did:** Completed automation system installation and testing
    - **Next:** Begin daily usage and monitoring for optimization
    - **Code:** `autonomous-living/docs/20_SYSTEMS/S10_Daily-Goals-Automation/`

- [ ] **G01** – [[P - Workout - Reach Target Body Fat]]
    - **Did:**
    - **Next:**
    - **Code:** `autonomous-living/goal-01/`

Execute Full Test

Run automation:

# Linux
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --force

# Windows
cd "Obsidian Vault\99_System\scripts"
python sync_daily_goals.py --force

Expected output:

🔄 Processing 2026-01-18.md...
   🔄 Force reprocessing enabled
   🔍 Found 1 checked goals
   📋 Processing G02: P - Automation - Automationbro...
      ✅ Activity logged: Completed automation system installation...
✅ Updated 2026-01-18.md
   📊 Goals: 1 | Activities: 1
📝 Created daily log: 2026-01-18.json
   📁 Updated G02 activity log
🔄 Syncing autonomous-living repository...
✅ Autonomous-living repository synced to GitHub
✨ Successfully processed 2026-01-18.md

Verify Results

Check generated files:

# JSON telemetry log
cat autonomous-living/_meta/daily-logs/2026-01-18.json

# Activity log update
cat autonomous-living/goal-g02/ACTIVITY.md

# Git synchronization
cd autonomous-living && git log --oneline -3

Test Obsidian hotkey:

    Press Ctrl+Shift+G in Obsidian
    Should see same success output
    Verify files update correctly

Phase 7: Cross-Machine Verification
Test on Second Machine

Switch to your other machine and:

# Pull latest changes
cd autonomous-living
git pull origin main

# Verify you see commits from first machine
git log --oneline -5

# Test automation on second machine
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --force  # Linux
python sync_daily_goals.py --force   # Windows

# Should work identically

Verify Cross-Platform Sync

On first machine:

cd autonomous-living
git pull origin main
git log --oneline -5
# Should show commits from both machines

Post-Installation Configuration
Optional: Obsidian Git Plugin Setup

For automatic vault synchronization:

    Install Obsidian Git plugin
    Configure:
        Auto pull on startup: ON
        Auto pull interval: 5 minutes
        Auto commit interval: 10 minutes

Optional: Automated Scheduling

Linux (cron):

# Edit crontab
crontab -e

# Add evening automation (23:00 daily)
0 23 * * * cd ~/Documents/"Obsidian Vault"/99_System/scripts && python3 sync_daily_goals.py

Windows (Task Scheduler):

    Task Scheduler → Create Basic Task
    Trigger: Daily at 23:00
    Action: Start program
    Program: python
    Arguments: sync_daily_goals.py
    Start in: C:\Users\%USERNAME%\Documents\Obsidian Vault\99_System\scripts

Installation Verification Checklist

    Both repositories cloned and in sibling directories
    Python 3.8+ installed with PyYAML module
    sync_daily_goals.py script present and executable
    config.yaml created with correct settings
    Shell Commands plugin installed and configured
    Ctrl+Shift+G hotkey assigned and working
    Test automation creates JSON logs and activity files
    Git synchronization works without conflicts
    Cross-platform testing completed successfully
    Both machines show identical Git history

Troubleshooting Installation Issues
Script Won't Run

# Check Python path
which python3  # Linux
where python   # Windows

# Check script permissions (Linux)
ls -la sync_daily_goals.py
chmod +x sync_daily_goals.py  # If needed

# Test script directly
python3 sync_daily_goals.py --help

Git Authentication Fails

# Test GitHub connection
ssh -T git@github.com

# If fails, regenerate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"
# Add public key to GitHub: Settings → SSH and GPG keys

Obsidian Integration Issues

    Verify Shell Commands plugin is enabled
    Check command syntax exactly matches platform
    Test command in terminal first
    Ensure working directory is empty
    Restart Obsidian after configuration changes

Next Steps

After successful installation:

    Begin daily usage - Use Ctrl+Shift+G after filling daily notes
    Monitor for issues - Check Git status occasionally: cd autonomous-living && git status
    Review documentation - Read Troubleshooting.md for common issues
    Optimize workflow - Consider automated scheduling for hands-free operation

Your Daily Goals Automation System is now production-ready and embodies true "Automation-First Living" principles!


### **File 3: `docs/20_SYSTEMS/S10_Daily-Goals-Automation/Troubleshooting.md`**

```markdown
# Troubleshooting Guide

Comprehensive diagnostic and resolution procedures for the Daily Goals Automation System.

## Quick Diagnostics

**First step for any issue - run verbose diagnostics:**

```bash
# Linux
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --verbose --force

# Windows
cd "Obsidian Vault\99_System\scripts"
python sync_daily_goals.py --verbose --force

Analyze the output for specific error patterns covered in this guide.
Issue Categories
🔍 Pattern Matching Issues
No Goals Detected

Symptoms:

ℹ️ No goals with activity content found

Root Cause: Daily note format doesn't match expected pattern.

Required Format Checklist:

    Section header contains "Power Goals" (case-insensitive)
    Checkbox: - [x] (lowercase x, no spaces inside brackets)
    Goal ID: **G01** (bold, uppercase, with leading zero)
    Goal link: [[P - Goal Name]] format
    Activity content: **Did:** field must have actual text (not empty)

Common Format Mistakes:
❌ Wrong 	✅ Correct
- [ x ] 	- [x]
**G1** 	**G01**
**g02** 	**G02**
- **Did:** (empty) 	- **Did:** Actual activity description

Diagnostic Command:

# Check your daily note format
TODAY=$(date +%Y-%m-%d)
grep -A 5 "\[x\].*\*\*G[0-9]" "01_Daily_Notes/$TODAY.md"

Fix: Update your daily note to match the required format exactly.
🔄 Git Synchronization Issues
Git Sync Fails - Diverged Branches

Symptoms:

❌ Git command failed: git pull --no-rebase origin main
Error: Your branch and 'origin/main' have diverged

Root Cause: Cross-platform synchronization conflict between Linux and Windows machines.

Solution 1: Nuclear Reset (Recommended)

cd autonomous-living

# Reset to match GitHub exactly (discards local conflicts)
git fetch origin
git reset --hard origin/main
git status  # Should show "working tree clean"

# Re-run automation
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --force  # Linux
python sync_daily_goals.py --force   # Windows

Solution 2: Complete Repository Reset

# If reset fails, clone fresh repository
cd Documents  # or C:\Users\Username\Documents
rm -rf autonomous-living  # Linux
rmdir /s /q autonomous-living  # Windows

git clone git@github.com:yourusername/autonomous-living.git

Git Push Rejected

Symptoms:

! [rejected] main -> main (non-fast-forward)

Root Cause: Another machine pushed changes while you were working.

Automatic Resolution: The v2.4 script handles this automatically with retry logic.

Manual Resolution:

cd autonomous-living
git fetch origin
git reset --soft origin/main  # Preserve your files, align history
git add .
git commit -m "Manual sync after conflict"
git push origin main

🐍 Python Environment Issues
Python Not Found

Symptoms:

bash: python3: command not found
'python' is not recognized as an internal or external command

Linux Solution:

# Install Python 3
sudo apt update
sudo apt install python3 python3-pip

# Verify
python3 --version

Windows Solution:

    Download Python from python.org
    ⚠️ Critical: Check "Add Python to PATH" during installation
    Restart Command Prompt
    Test: python --version

PyYAML Module Missing

Symptoms:

ModuleNotFoundError: No module named 'yaml'

Solution:

# Linux
python3 -m pip install --user PyYAML

# Windows
python -m pip install PyYAML

# Verify installation
python3 -c "import yaml; print('✅ PyYAML installed')"  # Linux
python -c "import yaml; print('✅ PyYAML installed')"   # Windows

Unicode/Emoji Errors (Windows)

Symptoms:

UnicodeEncodeError: 'charmap' codec can't encode character '\U0001f916'

Solution: The v2.4 script handles this automatically. If still occurring:

# Set UTF-8 environment variable
set PYTHONUTF8=1
python sync_daily_goals.py --force

📁 Path and File System Issues
Vault Not Found

Symptoms:

❌ Vault not found: /path/to/Obsidian Vault

Root Cause: Incorrect folder structure or path resolution.

Verification:

# Check folder structure
ls -la ~/Documents/  # Linux
dir C:\Users\%USERNAME%\Documents\  # Windows

# Expected structure:
# Obsidian Vault/
# autonomous-living/

Solution: Ensure both repositories are siblings in the same parent directory.
Permission Denied (Linux)

Symptoms:

Permission denied: './sync_daily_goals.py'

Solution:

chmod +x "Obsidian Vault/99_System/scripts/sync_daily_goals.py"

🔧 Obsidian Integration Issues
Hotkey Not Working

Symptoms: Pressing Ctrl+Shift+G does nothing or shows error.

Diagnostic Checklist:

    Shell Commands plugin enabled?
        Settings → Community plugins → Shell Commands → Enabled ✅

    Command configured correctly?
        Settings → Shell Commands → Verify command exists

    Hotkey assigned?
        Settings → Hotkeys → Search "Shell Commands: Sync Daily Goals"

Common Solutions:

Use absolute Python path (Linux):

/usr/bin/python3 "/home/username/Documents/Obsidian Vault/99_System/scripts/sync_daily_goals.py" --force

Use absolute Python path (Windows):

python "C:\Users\Username\Documents\Obsidian Vault\99_System\scripts\sync_daily_goals.py" --force

Test command independently:

# Copy exact command from Shell Commands plugin
# Run in terminal to see actual error messages

Shell Commands Shows No Output

Solutions:

    Settings → Shell Commands → Find your command → Output → Set to "Notice" or "Modal"
    Enable: "Show output on success"
    Test with simple command first: echo "Test output"

🔄 Cross-Platform Sync Issues
Files Not Syncing Between Machines

Symptoms: Changes on Linux don't appear on Windows (or vice versa).

Diagnostic:

# Check Git status on both machines
cd autonomous-living
git status
git log --oneline -5

# Compare commit hashes (should be identical)
git rev-parse HEAD

Solution:

# On machine with outdated data
cd autonomous-living
git pull origin main

# If conflicts occur
git fetch origin
git reset --hard origin/main

# Verify synchronization
git log --oneline -3

Different Usernames Causing Path Issues

Symptoms: Script works on one machine but not another due to username differences.

Solution: The v2.4 script uses auto-detection, but verify folder structure:

# Both machines should have this structure
Documents/
├── Obsidian Vault/
└── autonomous-living/

Path independence is built-in - the script automatically detects correct paths regardless of username.
Advanced Diagnostics
Complete System Health Check

Create comprehensive diagnostic script:

# Linux
cat > system_health.sh << 'EOF'
#!/bin/bash
echo "=== Daily Goals Automation System Health Check ==="
echo "Date: $(date)"
echo ""

echo "=== Environment ==="
echo "OS: $(uname -a)"
echo "Python: $(python3 --version 2>&1)"
echo "Git: $(git --version)"
echo "PyYAML: $(python3 -c 'import yaml; print(yaml.__version__)' 2>&1)"
echo ""

echo "=== Folder Structure ==="
ls -la ~/Documents/ | grep -E "(Obsidian|autonomous)"
echo ""

echo "=== Script Status ==="
cd ~/Documents/"Obsidian Vault"/99_System/scripts
ls -la sync_daily_goals.py config.yaml
echo ""

echo "=== Repository Status ==="
cd ~/Documents/autonomous-living
echo "Branch: $(git branch --show-current)"
echo "Status: $(git status --short)"
echo "Last commits:"
git log --oneline -3
echo ""

echo "=== Recent Activity ==="
echo "JSON logs:"
ls -la _meta/daily-logs/ | tail -3
echo "Activity logs:"
find goal-g* -name "ACTIVITY.md" -exec wc -l {} \; | head -5
EOF

chmod +x system_health.sh
./system_health.sh

Enable Maximum Debugging

Temporary verbose mode:

python3 sync_daily_goals.py --verbose --force 2>&1 | tee debug.log

Permanent debug configuration: Edit config.yaml:

verbose_logging: true
create_backups: true  # Enables backup creation for safety

Git Repository Deep Inspection

cd autonomous-living

# Check repository integrity
git fsck --full

# View detailed remote information
git remote show origin

# Check branch synchronization
git branch -vv

# View recent activity across all branches
git log --all --graph --oneline -10

Emergency Recovery Procedures
Complete System Reset (Nuclear Option)

When multiple issues compound and normal troubleshooting fails:

# 1. Backup current state
cp -r ~/Documents/autonomous-living ~/Documents/autonomous-living.backup.$(date +%Y%m%d)

# 2. Remove corrupted repository
rm -rf ~/Documents/autonomous-living

# 3. Clone fresh from GitHub
cd ~/Documents
git clone git@github.com:yourusername/autonomous-living.git

# 4. Test automation
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --force

# 5. Verify results
cd ~/Documents/autonomous-living
git status
ls -la _meta/daily-logs/

Recover Lost or Corrupted Data

From automatic backups:

# List available backups
ls -la ~/Documents/autonomous-living/_meta/backups/

# Restore specific daily note
cp autonomous-living/_meta/backups/2026-01-18.md.bak \
   "Obsidian Vault/01_Daily_Notes/2026-01-18.md"

From Git history:

cd autonomous-living

# Find when file was last good
git log --follow -- "goal-g02/ACTIVITY.md"

# Restore from specific commit
git checkout <commit-hash> -- "goal-g02/ACTIVITY.md"

Fix Corrupted Git Repository

cd autonomous-living

# Attempt repair
git fsck --full
git gc --prune=now

# If repair fails, clone fresh (see Nuclear Option above)

Prevention Strategies
Daily Maintenance (Automated)

Best practices to prevent issues:

    Consistent usage pattern:
        Always use the automation script, never manually edit autonomous-living files
        Fill daily notes consistently with proper format

    Regular synchronization:

# Morning routine (optional)
cd autonomous-living && git pull origin main

Monitor Git status:

    # Weekly check
    cd autonomous-living && git status

Early Warning System

Set up monitoring to catch issues early:

# Add to daily automation (Linux cron)
0 23 * * * cd ~/Documents/autonomous-living && git status --short | grep -q . && echo "⚠️ Uncommitted changes detected" | mail -s "Git Status Alert" your.email@example.com

Cross-Platform Best Practices

    Designate primary machine: If issues persist, consider making one machine the primary writer
    Stagger usage: Don't run automation simultaneously on both machines
    Regular cross-verification: Periodically verify both machines show identical Git history

Getting Help
Information to Collect Before Requesting Support

# Run comprehensive diagnostics
cd "Obsidian Vault/99_System/scripts"
python3 sync_daily_goals.py --verbose --force 2>&1 | tee ~/debug_output.log

# Collect system information
uname -a > ~/system_info.txt  # Linux
systeminfo > ~/system_info.txt  # Windows

# Git repository status
cd ~/Documents/autonomous-living
git status > ~/git_status.txt
git log --oneline -10 > ~/git_history.txt

Support Channels

    Self-help: Review this troubleshooting guide thoroughly
    Documentation: Check Git-Operations.md for manual procedures
    Repository issues: Search existing issues in autonomous-living GitHub repository
    New issue: Open GitHub issue with debug_output.log and system information attached

Issue Templates

For bug reports, include:

    Operating system and version
    Python version and PyYAML version
    Complete debug output (debug_output.log)
    Sample daily note that caused the issue
    Git repository status and recent history
    Steps to reproduce the problem

For feature requests, include:

    Clear description of desired functionality
    Use case explanation
    Compatibility considerations (Linux/Windows)
    Integration points with existing system

Remember: The Daily Goals Automation System is designed to be self-healing and robust. Most issues can be resolved with the nuclear reset approach, and the system will regenerate all necessary data from your Obsidian daily notes.


### **File 4: `docs/20_SYSTEMS/S10_Daily-Goals-Automation/Git-Operations.md`**

```markdown
# Git Operations Reference

Manual Git commands for maintenance, troubleshooting, and recovery of the autonomous-living repository.

## Daily Operations

### Repository Status Checks

```bash
cd ~/Documents/autonomous-living  # Linux
cd C:\Users\%USERNAME%\Documents\autonomous-living  # Windows

# Basic status
git status

# Compact status with branch info
git status --short --branch

# Check differences from remote
git fetch origin
git status

Standard Synchronization

# Pull latest changes (standard merge)
git pull origin main

# Pull with rebase (creates linear history)
git pull --rebase origin main

# Push your changes
git push origin main

# Show what changed during pull
git pull origin main --stat

History and Log Inspection

# Recent commits with one line per commit
git log --oneline -10

# Commits from specific machine (search by hostname)
git log --grep="DESKTOP-" --oneline
git log --grep="ubuntu" --oneline

# Commits affecting specific file
git log --oneline -- "goal-g02/ACTIVITY.md"
git log --oneline -- "_meta/daily-logs/"

# Visual branch structure
git log --graph --oneline --all -10

# Show detailed commit information
git show HEAD  # Latest commit
git show HEAD~1  # Previous commit

Cross-Platform Synchronization
Machine-to-Machine Sync

Scenario: Worked on Linux, switching to Windows

On Windows:

cd C:\Users\%USERNAME%\Documents\autonomous-living
git pull origin main
git status
REM Should show "working tree clean"

Later on Linux:

cd ~/Documents/autonomous-living
git pull origin main
git status
# Should show "working tree clean"

Verify Cross-Platform Consistency

# Both machines should show identical output
git rev-parse HEAD  # Commit hash
git log --oneline -5  # Recent history

# Check for uncommitted differences
git status --short
# Should be empty on both machines

Conflict Resolution
Standard Conflict Resolution

When you see: "Your branch and 'origin/main' have diverged"

Option 1: Accept Remote State (Safest)

# Discard local changes, match remote exactly
git fetch origin
git reset --hard origin/main
git status  # Should show "working tree clean"

Option 2: Force Push Local State

# Overwrites remote with your local changes
git push --force origin main

Option 3: Attempt Merge

# Try automatic merge
git pull --no-rebase origin main

# If conflicts occur:
git status  # Shows conflicted files
# Edit files to resolve conflicts manually
git add .
git commit -m "Resolved merge conflicts"
git push origin main

Nuclear Conflict Resolution

For the Daily Goals Automation System, use this approach:

cd autonomous-living

# 1. Stash any uncommitted changes
git add .
git stash

# 2. Reset to match remote exactly
git fetch origin
git reset --hard origin/main

# 3. Re-apply stashed changes (if needed)
git stash pop  # Only if you had important uncommitted work

# 4. Verify clean state
git status

Recovery Operations
Undo Operations

Undo last commit but keep files changed:

git reset --soft HEAD~1
git status  # Files remain staged

Undo last commit and discard changes:

git reset --hard HEAD~1
git log --oneline -5  # Verify commit removed

Undo multiple commits:

# Undo last 3 commits, keep changes
git reset --soft HEAD~3

# Undo last 3 commits, discard changes
git reset --hard HEAD~3

File Recovery

Restore deleted or corrupted file:

# Find when file was last modified
git log --follow -- "goal-g02/ACTIVITY.md"

# Restore from specific commit
git checkout <commit-hash> -- "goal-g02/ACTIVITY.md"

# Restore from previous commit
git checkout HEAD~1 -- "goal-g02/ACTIVITY.md"

# Restore entire directory
git checkout HEAD~1 -- "_meta/daily-logs/"

View file content from previous version:

# Show file from 3 commits ago
git show HEAD~3:goal-g02/ACTIVITY.md

# Show file from specific date
git show main@{2026-01-15}:goal-g02/ACTIVITY.md

# Show file from specific commit
git show abc123f:goal-g02/ACTIVITY.md

Time-Based Recovery

Reset to specific date:

# Find commits from date range
git log --since="2026-01-15" --until="2026-01-16" --oneline

# Reset to commit from specific time
git reset --hard main@{2026-01-15}

# If already pushed, force push required
git push --force origin main

Create restore point before major changes:

# Create backup branch
git branch backup-$(date +%Y%m%d) HEAD
git push origin backup-$(date +%Y%m%d)

Branch Management
Working with Branches

Create and switch to new branch:

# Create branch from current state
git branch feature-branch
git checkout feature-branch

# Or create and switch in one command
git checkout -b feature-branch

List branches:

# Local branches
git branch

# All branches (local and remote)
git branch -a

# Branches with last commit info
git branch -v

Delete branches:

# Delete local branch (safe)
git branch -d branch-name

# Force delete local branch
git branch -D branch-name

# Delete remote branch
git push origin --delete branch-name

Backup and Archive Operations

Create backup of current state:

# Create timestamped backup branch
BACKUP_NAME="backup-$(date +%Y%m%d-%H%M)"
git branch $BACKUP_NAME
git push origin $BACKUP_NAME

echo "Backup created: $BACKUP_NAME"

Archive old backups:

# List backup branches older than 30 days
git for-each-ref --format='%(refname:short) %(committerdate)' refs/heads/backup-* | \
  awk '$2 < "'$(date -d '30 days ago' '+%Y-%m-%d')'"'

# Delete old backup (example)
git branch -D backup-20251201
git push origin --delete backup-20251201

Advanced Operations
Repository Maintenance

Clean up repository:

# Remove untracked files (dry run first)
git clean -n

# Remove untracked files
git clean -f

# Remove untracked files and directories
git clean -fd

Optimize repository:

# Garbage collection and optimization
git gc --aggressive --prune=now

# Verify repository integrity
git fsck --full

# Show repository size
du -sh .git

History Modification

Squash multiple commits into one:

# Combine last 3 commits
git reset --soft HEAD~3
git commit -m "Combined: Daily updates for week of 2026-01-15"

# Force push required if already pushed
git push --force origin main

Interactive rebase (advanced):

# Rebase last 5 commits interactively
git rebase -i HEAD~5

# In editor, choose actions:
# pick = keep commit as-is
# reword = change commit message
# squash = combine with previous commit
# drop = remove commit entirely

Cherry-pick specific commit:

# Apply specific commit from another branch
git cherry-pick <commit-hash>

# Cherry-pick without committing (for review)
git cherry-pick --no-commit <commit-hash>

Remote Operations
Remote Configuration

View remote configuration:

# Show remote URLs
git remote -v

# Detailed remote information
git remote show origin

Change remote URL:

# Switch to SSH (recommended)
git remote set-url origin git@github.com:yourusername/autonomous-living.git

# Switch to HTTPS (if SSH issues)
git remote set-url origin https://github.com/yourusername/autonomous-living.git

# Verify change
git remote -v

Multiple remotes (backup strategy):

# Add backup remote
git remote add backup git@github.com:yourusername/autonomous-living-backup.git

# Push to both remotes
git push origin main
git push backup main

# Pull from specific remote
git pull backup main

Force Push Operations

Safe force push (recommended):

# Force push with lease (fails if remote changed)
git push --force-with-lease origin main

Nuclear force push (use with extreme caution):

# Overwrites remote completely
git push --force origin main

Force push specific branch:

git push --force origin feature-branch

Diagnostic Commands
Pre-Operation Checks

Check what will be pushed:

# Show commits that will be pushed
git log origin/main..HEAD --oneline

# Show detailed differences
git diff origin/main..HEAD

# Show files that will be affected
git diff --name-only origin/main..HEAD

Check what will be pulled:

# Fetch without merging
git fetch origin

# Show commits that will be pulled
git log HEAD..origin/main --oneline

# Show detailed differences
git diff HEAD..origin/main

# Show files that will be affected
git diff --name-only HEAD..origin/main

Repository Health Checks

Verify repository integrity:

# Check for corruption
git fsck --full --verbose

# Count objects and check consistency
git count-objects -v

# Verify connectivity to remote
git remote update
git status -uno

Check repository statistics:

# Show repository size breakdown
git rev-list --objects --all | \
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
  awk '/^blob/ {print substr($0,6)}' | \
  sort --numeric-sort --key=2 --reverse | \
  head -10

# Show largest files in history
git rev-list --all --objects | \
  grep "$(git verify-pack -v .git/objects/pack/*.idx | \
  sort -k 3 -n | tail -10 | awk '{print $1}')"

Configuration Management
View and Modify Configuration

View configuration:

# All configuration (global and local)
git config --list

# Only local repository configuration
git config --local --list

# Specific setting
git config user.name
git config user.email

Update configuration:

# User information
git config --global user.name "Michał Nowakowski"
git config --global user.email "your.email@example.com"

# Repository-specific settings
git config --local user.name "Automation System"
git config --local user.email "automation@yoursite.com"

# Default behaviors
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global push.default simple

Automation-Specific Configuration

Optimize for automation use:

cd autonomous-living

# Set repository for automation use
git config --local core.autocrlf false  # Consistent line endings
git config --local core.filemode false  # Ignore file permissions
git config --local merge.ours.driver true  # Prefer our version in conflicts

# Disable interactive prompts
git config --local merge.tool false
git config --local diff.tool false

Emergency Procedures
Complete Repository Recovery

When repository is completely corrupted:

# 1. Backup corrupted state
mv autonomous-living autonomous-living.corrupted.$(date +%Y%m%d)

# 2. Clone fresh repository
cd ~/Documents
git clone git@github.com:yourusername/autonomous-living.git

# 3. Verify clean state
cd autonomous-living
git status
git fsck --full

# 4. Test automation
cd ../Obsidian\ Vault/99_System/scripts
python3 sync_daily_goals.py --force

Network/Authentication Issues

Test GitHub connectivity:

# Test SSH connection
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."

# Test HTTPS connection
curl -I https://github.com/yourusername/autonomous-living.git
# Expected: HTTP/2 200

# Check DNS resolution
nslookup github.com

Regenerate SSH keys (if authentication fails):

# Generate new SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to add to GitHub
cat ~/.ssh/id_ed25519.pub
# Add to GitHub: Settings → SSH and GPG keys → New SSH key

Automation Integration
Commands for Script Integration

Git status check for automation:

# Check if repository needs attention
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "Repository has uncommitted changes"
    exit 1
fi

# Check if remote is ahead
git fetch origin
if [ $(git rev-list HEAD..origin/main --count) -gt 0 ]; then
    echo "Remote has newer commits"
    exit 1
fi

Safe automated push:

# Automation-safe push with retry
git_push_safe() {
    local max_retries=3
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        if git push origin main; then
            return 0
        fi
        
        echo "Push failed, attempting recovery..."
        git fetch origin
        git reset --soft origin/main
        git add .
        git commit --amend --no-edit
        
        ((retry++))
    done
    
    echo "Push failed after $max_retries attempts"
    return 1
}

This Git operations reference provides manual control when the automation system needs human intervention. Most daily operations should be handled automatically by the sync_daily_goals.py script, but these commands are essential for troubleshooting and recovery scenarios.


## **Additional Integration Points**

### **Update Root README.md**

Add this section to your main `autonomous-living/README.md`:

```markdown
## Daily Goals Automation System

This repository is automatically synchronized with your Obsidian Second Brain through the Daily Goals Automation System. The system extracts checked goals from your daily notes and creates structured execution logs.

**Quick Start:**
- Press `Ctrl+Shift+G` in Obsidian after filling your daily note
- System automatically creates JSON logs and activity files
- Perfect cross-platform synchronization (Linux/Windows)

**Documentation:** [Complete System Guide](./docs/20_SYSTEMS/S10_Daily-Goals-Automation/README.md)

**Files Generated:**
- `_meta/daily-logs/YYYY-MM-DD.json` - Machine-readable telemetry
- `goal-gXX/ACTIVITY.md` - Human-readable activity logs
- `_meta/backups/` - Automatic safety backups

