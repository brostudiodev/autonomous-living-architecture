import os
import re
import datetime
from pathlib import Path

OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")

def get_today_note_path():
    today_str = datetime.date.today().strftime("%Y-%m-%d")
    return os.path.join(DAILY_NOTES_DIR, f"{today_str}.md")

def generate_reflection_draft():
    """Analyze today's activities and generate a reflection draft."""
    note_path = get_today_note_path()
    if not os.path.exists(note_path):
        return None

    with open(note_path, 'r') as f:
        content = f.read()

    # 1. Extract what was done (from goals_activities or 'After Work' section)
    # We look for [x] GXX blocks
    done_goals = re.findall(r"- \[x\] \*\*(G\d{2})\*\*\s*–.*?\n\s*- \*\*Did:\*\*\s*(.+)", content)
    
    reflection = "\n### 🤖 Automated Daily Reflection (Draft)\n"
    if done_goals:
        reflection += f"Today I moved the needle on **{len(done_goals)}** power goals:\n"
        for gid, did in done_goals:
            reflection += f"- **{gid}**: {did.strip()}\n"
    else:
        reflection += "No goals were checked as completed today. 🟠 Strategic stall detected.\n"

    # 2. Check for specific wins (e.g. HIT workout completed)
    if "- [x] 💪 HIT Workout" in content:
        reflection += "- 💪 **Health Win**: Completed HIT session. Recovery management active.\n"
    
    if "💸 Finance:" in content and "🚨 STOP SPENDING" not in content:
        reflection += "- 💸 **Finance Win**: Budget within limits for major categories.\n"
    elif "🚨 STOP SPENDING" in content:
        reflection += "- ⚠️ **Finance Bottleneck**: Budget breaches detected in some categories.\n"

    reflection += "\n**Next Steps Alignment:**\n"
    next_steps = re.findall(r"- \*\*Next:\*\*\s*(.+)", content)
    if next_steps:
        for step in next_steps[:3]:
            if step.strip() and step.strip().lower() != "tbd":
                reflection += f"- → {step.strip()}\n"

    # 3. Foundation First Prep (from A - System - Life Routines)
    reflection += "\n### 👕 Evening Prep Checklist (Foundation First)\n"
    reflection += "- [ ] Clothes set out for tomorrow?\n"
    reflection += "- [ ] Lunch/Breakfast ingredients ready?\n"
    reflection += "- [ ] Bag/Backpack packed with essentials?\n"
    reflection += "- [ ] Phone charging OUTSIDE the bedroom?\n"
    reflection += "- [ ] 3 key tasks identified for the first 90 minutes?\n"

    return reflection

def inject_reflection():
    note_path = get_today_note_path()
    if not os.path.exists(note_path):
        return

    draft = generate_reflection_draft()
    if not draft: return

    with open(note_path, 'r') as f:
        content = f.read()

    # Inject into ## 🧠 Reflection section
    if "## 🧠 Reflection" in content:
        # Check if already injected to avoid duplication
        if "### 🤖 Automated Daily Reflection" in content:
            # Replace existing
            content = re.sub(r"### 🤖 Automated Daily Reflection.*?(?=

## |$)", draft.strip(), content, flags=re.DOTALL)
        else:
            content = content.replace("## 🧠 Reflection", f"## 🧠 Reflection
{draft}")

    with open(note_path, 'w') as f:
        f.write(content)
    print(f"✅ Reflection draft injected into today's note.")

if __name__ == "__main__":
    inject_reflection()
