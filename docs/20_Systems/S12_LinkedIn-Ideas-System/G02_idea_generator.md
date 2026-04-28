---
title: "G02_idea_generator.py"
type: "script"
status: "active"
goal_id: "goal-g02"
owner: "Michał"
updated: "2026-03-18"
systems: ["S04", "S08"]
---

# G02_idea_generator.py

## Purpose
On-demand script for generating LinkedIn and Substack content ideas. Creates idea files in the Ideas Baskets based on user input or system context.

## Intent
Enable quick creation of new content ideas without manual file creation. Accepts parameters via command line or generates from system data (time saved, automation wins).

---

## How to Run

### From Command Line
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
python3 G02_idea_generator.py [platform] [type] [key=value...]
```

### Asking Me (Easier!)
Just tell me:
- **Platform**: "LinkedIn" or "Substack"
- **Topic**: What the idea is about
- **Details**: Any specific points you want to include

**Example:**
> "Create a LinkedIn idea about smart home automation"

I'll generate the file and show you the result.

---

## Parameters

### Platform
| Value | Output Location |
|-------|----------------|
| `linkedin` | `Obsidian Vault/02_Projects/LinkedIn Ideas Basket/` |
| `substack` | `Obsidian Vault/02_Projects/Substack Notes Ideas Basket/` |

### Idea Type
| Type | Description |
|------|-------------|
| `tip` | Quick actionable tip |
| `time_saved` | Time savings story |
| `automation_win` | System achievement |
| `system_failure` | Lessons learned |

### Key-Value Pairs
| Key | Description | Example |
|-----|-------------|---------|
| `title` | Idea title | `title="Morning Routine"` |
| `hook` | Opening line | `hook="I saved 30 minutes today"` |
| `tip` | The actual tip | `tip="Use IFTTT"` |
| `why` | Why it works | `why="Free and simple"` |
| `cta` | Call to action | `cta="What's your tip?"` |
| `minutes` | Time saved (for time_saved type) | `minutes=45` |
| `old_habit` | What you used to do | `old_habit="track expenses"` |
| `new_habit` | What now happens automatically | `new_habit="auto-categorized"` |
| `benefit` | The benefit | `benefit="15 min/day saved"` |
| `timeframe` | When failure happened | `timeframe="last week"` |
| `lessons` | Lessons learned | `lessons="Check your systems"` |

---

## Usage Examples

### Example 1: Simple LinkedIn Tip
```bash
python3 G02_idea_generator.py linkedin tip tip="Use Google Calendar reminders" why="Free, 2 minutes to set up" cta="What's your favorite tool?"
```

### Example 2: Time Saved Story (LinkedIn)
```bash
python3 G02_idea_generator.py linkedin time_saved minutes=60 hook="Yesterday I got an hour back" what_it_means="That's 5 hours/week"
```

### Example 3: Substack Note
```bash
python3 G02_idea_generator.py substack tip tip="Start with one automation" cta="What's holding you back?"
```

### Example 4: Auto-Generate from System
```bash
python3 G02_idea_generator.py auto
```
This reads your Digital Twin state and creates ideas based on:
- Time saved today
- Recent automation wins
- System achievements

---

## Asking Me to Create Ideas

### Just tell me in plain text:

**Simple:**
> "Create a LinkedIn idea about saving time on grocery shopping"

**Detailed:**
> "Create a Substack note about my smart home setup. Hook: I bought smart bulbs, it was a mess. Key points: start with one hub, automation > voice"

**From System:**
> "Generate ideas from my system data"

### What I'll Do:
1. Parse your request
2. Generate appropriate idea file
3. Show you the result
4. Save to correct basket

---

## Output Files

### LinkedIn Ideas
```
Obsidian Vault/02_Projects/LinkedIn Ideas Basket/
├── IDEA-Morning-Routine-Automated.md
├── IDEA-New-Tip-Idea.md
└── ...
```

### Substack Notes
```
Obsidian Vault/02_Projects/Substack Notes Ideas Basket/
├── SN-Morning-Routine-Automated.md
├── SN-Automation-vs-Life-Admin.md
└── ...
```

---

## File Structure

Each generated file contains:

```markdown
---
title: "[IDEA] Title"
date_created: YYYY-MM-DD
date_source: YYYY-MM-DD
source_type: On-demand generation
status: 🆕 New
linkedin_format: tip
tags:
  - linkedin
  - idea
  - tip
---

# Idea: Title

## Hook
Opening line

## Key Points
- Point 1
- Point 2

## Source
Generated on-demand

## Why This Works
Explanation

## Potential CTA
Question for readers

---

## 📝 Draft (Editable)

[Pre-written content following the philosophy]

---

*Want to refine this idea? Message me!*
```

---

## Draft Philosophy (Built-In)

Every idea follows the "benefits for everyone" philosophy:

### ✅ DO
- Focus on benefits for reader
- Use inclusive language ("anyone can do this")
- Mention free/simple tools
- End with action CTA

### ❌ DON'T
- Not about "how smart I am"
- Not technical jargon without explanation
- Not exclusive tone

---

## Dependencies

### Systems
- S04 Digital Twin (for `auto` mode)
- S08 Automation Orchestrator

### External
- Obsidian Vault
- File system access

---

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Invalid platform | Unknown platform name | Show usage help |
| File exists | Duplicate filename | Warn, don't overwrite |
| Auto mode fails | LLM/DB error | Show what was gathered |
| Missing required params | KeyError | Show error, continue |

---

## Examples of Asking Me

### Want a quick tip?
> "Create LinkedIn tip about using IFTTT for grocery lists"

### Want a story?
> "Create Substack note about how I saved 45 minutes by automating expense tracking"

### Want me to generate from your data?
> "Generate new ideas from my system"

### Want a specific format?
> "Create LinkedIn idea about morning routines, should mention HRV, sleep data, and free tools"

---

## Related Documentation

- [LinkedIn Ideas System](docs/20_Systems/S12_LinkedIn-Ideas-System/README.md)
- [Substack Notes System](docs/20_Systems/S13_Substack-Notes-Ideas-System/README.md)
- [LinkedIn Ideas Basket](02_Projects/LinkedIn Ideas Basket.md)
- [Substack Notes Basket](02_Projects/Substack Notes Ideas Basket.md)

---

## Owner & Review

- **Owner:** Michał
- **Review Cadence:** As needed
- **Last Updated:** 2026-03-18
