---
title: "SVC_GitHub-Todo-List-Extractor"
type: "automation_spec"
status: "active"
automation_id: "SVC_GitHub-Todo-List-Extractor"
goal_id: "goal-g12"
systems: ["S03", "S10"]
owner: "Micha\u0142"
updated: "2026-02-09"
---

# SVC_GitHub-Todo-List-Extractor

## Purpose
Extracts open TODO items (`- [ ]`) from all Goal Roadmap files in GitHub repository and returns a formatted summary organized by goal and quarter.

## Triggers
- **Execute Workflow**: Called as sub-workflow from main orchestrator (chat commands)
- **Telegram**: Direct `/todo` command via Telegram bot
- **Webhook**: HTTP POST to `/todo-webhook` endpoint

## Inputs

### From Execute Workflow (Primary)
```json
{
  "normalized": { "text": "/todo" },
  "_command": { "name": "todo", "args": "" },
  "metadata": {
    "source": "chat",
    "session_id": "xxx",
    "response_endpoint": { "type": "chat", "session_id": "xxx" }
  }
}
```

### From Telegram
```json
{
  "message": {
    "text": "/todo G01",
    "chat": { "id": 123456789 }
  }
}
```

### From Webhook
```json
{
  "command": "/todo"
}
```

### Command Syntax
| Command     | Description           |
|-------------|-----------------------|
| `/todo`     | All goals (12 roadmaps) |
| `/todo G01` | Specific goal         |
| `/todo 1`   | Short format (same as G01) |
| `/todo G05` | Returns G05 (formerly G02-Finance) |

### Processing Logic

1.  **Parse Command** - Detect input source (execute workflow/telegram/webhook), extract command and optional goal filter
2.  **Validate** - Verify command matches `/todo` pattern with optional goal specifier
3.  **Prepare Goals** - Build list of GitHub file paths to fetch (all 12 goals or filtered)
4.  **GitHub Get File** - Fetch `Roadmap.md` binary content from each goal folder
5.  **Extract Text** - Convert binary markdown to UTF-8 text
6.  **Merge Goal Data** - Combine extracted content with goal metadata
7.  **Parse TODOs** - Extract unchecked items (`- [ ]`) grouped by quarter (Q1-Q4)
8.  **Format Response** - Generate formatted message with emoji indicators
9.  **Route Response** - Direct output to appropriate channel (Telegram/Webhook/Parent workflow)

## Outputs

### Success Response

```
\U0001f4cb *TODO List - Autonomous Living*
\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550

\U0001f4cc *G01: Target Body Fat* (17)
\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2550\u2550\u2550\u2550

\U0001f5d3\ufe0f _Q1:_
  \u2610 Develop script for monthly progress summary generation
  \u2610 Establish initial body composition baseline...
  \u2610 Integrate smart scale data API with S03 Data Layer

\U0001f5d3\ufe0f _Q2:_
  \u2610 Implement next session planner script...

...

\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550
\U0001f4ca *Total: 239 open tasks*
\U0001f550 2026-02-09 20:42 UTC
```

### Response Routing
| Source              | Output                                 |
|---------------------|----------------------------------------|
| `telegram`          | Send via Telegram API (Markdown format) |
| `webhook`           | JSON response: `{ success: true, message: "..." }` |
| `chat` / `execute_workflow` | Return data to parent workflow     |

### Message Splitting

Messages exceeding 4000 characters (Telegram limit) are split into multiple parts, preserving goal boundaries.

## Dependencies

### Systems

*   **S03 Data Layer** - GitHub repository as source of truth
*   **S10 Daily Goals Automation** - Integration with daily workflow

### External Services

*   **GitHub API** - File content retrieval (authenticated)
*   **Telegram Bot API** - Message delivery (OliwiaAIBot)

### Credentials
| Credential          | Type      | Storage                             |
|---------------------|-----------|-------------------------------------|
| GitHub account      | API Token | n8n credential store (SWpOnkLoKO1C9hQn) |
| Telegram (OliwiaAIBot) | Bot Token | n8n credential store (DCOwEgVhcQsb8aXC) |

### GitHub Repository Structure

```
brostudiodev/autonomous-living/
├── docs/10_GOALS/
    ├── G01_Target-Body-Fat/Roadmap.md
    ├── G02_Automationbro-Recognition/Roadmap.md
    ├── G05_Autonomous-Financial-Command-Center/Roadmap.md
    ├── G03_Autonomous-Household-Operations/Roadmap.md
    ├── G04_Digital-Twin-Ecosystem/Roadmap.md
    ├── G06_Certification-Exams/Roadmap.md
    ├── G07_Predictive-Health-Management/Roadmap.md
    ├── G08_Predictive-Smart-Home-Orchestration/Roadmap.md
    ├── G09_Complete-Process-Documentation/Roadmap.md
    ├── G10_Automated-Career-Intelligence/Roadmap.md
    ├── G11_Intelligent-Productivity-Time-Architecture/Roadmap.md
    └── G12_Meta-System-Integration-Optimization/Roadmap.md
```

## Error Handling

| Failure Scenario          | Detection                                     | Response                                      | Alert             |
|---------------------------|-----------------------------------------------|-----------------------------------------------|-------------------|
| Invalid command syntax    | Regex match fails                             | Return error message with usage help          | None              |
| GitHub file not found     | GitHub node error                             | Skip goal, show error in output               | Log warning       |
| Binary decode failure     | Extract Text fails                            | Goal shows "No content extracted"             | Log error         |
| Telegram delivery fails   | API error                                     | n8n error handling                            | Workflow error log |

### Error Response Example

```
\u274c *G01: Target Body Fat*
   _No content extracted_
```

## Monitoring

*   **Success metric**: Response contains `Total: X open tasks` with `X > 0`
*   **Performance**: Typical execution 3-5 seconds for all 12 goals
*   **Alert on**: Consistent "No content extracted" for all goals (indicates GitHub auth issue)

## Manual Fallback

If automation fails, manually check TODOs:

```bash
# Clone/pull repo
cd autonomous-living
git pull origin main

# Search for open TODOs in all roadmaps
grep -r "^\s*- \[ \]" docs/10_GOALS/*/Roadmap.md

# Count by goal
for f in docs/10_GOALS/*/Roadmap.md; do
    count=$(grep -c "^\s*- \[ \]" "$f" 2>/dev/null || echo 0)
    echo "$f: $count"
done
```

## Workflow Node Reference

| Node                               | Type      | Purpose                                         |
|------------------------------------|-----------|-------------------------------------------------|
| When Executed by Another Workflow  | Trigger   | Entry point for sub-workflow calls              |
| Telegram Trigger                   | Trigger   | Direct Telegram commands                        |
| Chat Webhook                       | Trigger   | HTTP POST endpoint                              |
| Parse Command                      | Code      | Extract command and detect source               |
| If Valid                           | If        | Route valid vs invalid commands                 |
| Prepare Goals                      | Code      | Build goal list with file paths                 |
| GitHub Get File                    | GitHub    | Fetch `Roadmap.md` from each goal               |
| Extract Text                       | Extract From File | Convert binary to UTF-8 text                  |
| Merge Goal Data                    | Code      | Combine content with metadata                   |
| Parse TODOs                        | Code      | Extract unchecked items by quarter              |
| Format Response                    | Code      | Build formatted message                         |
| Is Telegram?                       | If        | Route to Telegram output                        |
| Is Webhook?                        | If        | Route to Webhook or Parent                      |
| Send Telegram                      | Telegram  | Deliver message via bot                         |
| Webhook Response                   | Respond to Webhook | Return JSON response                        |
| Return to Parent                   | NoOp      | Return data to calling workflow                 |

## Configuration

### Goal Registry (in `Prepare Goals` node)

```javascript
const goals = [
  { goalId: 'G01', goalName: 'Target Body Fat', filePath: 'docs/10_GOALS/G01_Target-Body-Fat/Roadmap.md' },
  { goalId: 'G05', goalName: 'Autonomous Financial Command Center', filePath: 'docs/10_GOALS/G05_Autonomous-Financial-Command-Center/Roadmap.md' },
  // ... remaining goals
];
```

To add a new goal:

*   Add entry to `goals` array in `Prepare Goals` node
*   Ensure `Roadmap.md` exists in GitHub with standard format

### Roadmap.md Format Requirements

```markdown
## Q1 (Jan-Mar)
- [x] Completed task
- [ ] Open task to extract

## Q2 (Apr-Jun)
- [ ] Another open task

## Dependencies
(TODOs here are NOT extracted - section stops at Dependencies/Notes/References)
```

## Version History

| Date       | Change                                      | Author      |
|------------|---------------------------------------------|-------------|
| 2026-02-09 | Initial implementation                      | Micha\u0142 |
| 2026-02-09 | Added Execute Workflow trigger support      | Micha\u0142 |
| 2026-02-09 | Fixed binary-to-text extraction (Extract From File node) | Micha\u0142 |
| 2026-02-09 | Added 3-way routing (Telegram/Webhook/Parent) | Micha\u0142 |

## Related Documentation

*   Goal Documentation Standard
*   SOP: Weekly Review
*   System: S03 Data Layer
*   System: S10 Daily Goals Automation
