---
title: "G11: Automated Security Auditor"
type: "automation_spec"
status: "active"
automation_id: "G11_security_auditor.py"
goal_id: "goal-g11"
systems: ["S11", "S02"]
owner: "Michal"
updated: "2026-03-20"
---

# G11: Automated Security Auditor

## Purpose
Acts as a continuous security watchdog for the Autonomous Living ecosystem. It scans the codebase for accidentally exposed secrets and verifies that sensitive configuration files have restrictive file-system permissions.

## Key Features
- **Secret Pattern Matching:** Uses regex to detect hardcoded API keys, tokens, and passwords in Python scripts.
- **Permission Verification:** Checks critical files (`.env`, credentials) for insecure read/write access by unauthorized users.
- **Environment Awareness:** Specifically filters out valid `os.getenv` calls to minimize false positives.
- **Automated Alerts:** Triggers a `WARNING` in the system log if vulnerabilities are detected.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` daily registry.
- **Manual:** `python3 scripts/G11_security_auditor.py`

## Inputs
- **Codebase:** Scans the `scripts/` directory.
- **File System:** Inspects metadata of sensitive files defined in `SENSITIVE_FILES`.

## Processing Logic
1.  **Script Crawl:** Iterates through all `.py` files in the repository.
2.  **Pattern Scan:** Searches for high-entropy strings assigned to variables like `api_key`, `token`, etc.
3.  **Permission Check:** Uses the `stat` module to verify that sensitive files do not have "others-readable" or "others-writable" bits set.
4.  **Logging:** Aggregates all findings into a single report and logs to `system_activity_log`.

## Outputs
- **System Activity Log:** `SUCCESS` (clean) or `WARNING` (issues found).
- **Console Output:** Detailed list of security findings.

## Dependencies
### Systems
- [S02 Identity & Access](../../20_Systems/S02_Identity-Access/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Permission Denied | `OSError` | Skips file, continues audit | Console |
| Missing .env | `os.path.exists` | Logs as warning | System Activity Log |

## Manual Fallback
If the auditor is offline:
1.  Manually run `grep -r "api_key =" scripts/` to check for exposures.
2.  Run `ls -l .env` to verify permissions are `-rw-------` (600).
