import os
import re
import datetime
from pathlib import Path

# Paths
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")
GOALS_PATH = "/home/{{USER}}/Documents/autonomous-living/docs/10_Goals"

def get_latest_next_step(goal_id):
    """Extract the last 'Next Step' from the goal's Activity-log.md."""
    # Find the folder for the goal_id
    try:
        goal_folders = [f for f in os.listdir(GOALS_PATH) if f.startswith(goal_id)]
        if not goal_folders:
            return "TBD", None
        
        log_file = os.path.join(GOALS_PATH, goal_folders[0], "Activity-log.md")
        if not os.path.exists(log_file):
            return "TBD", None
        
        with open(log_file, 'r') as f:
            content = f.read()
            # Find the last **Next Step:** entry
            matches = re.findall(r"\*\*Next Step:\*\*\s*(.*?)\n", content)
            code_matches = re.findall(r"\*\*Code:\*\*\s*`?(.*?)`?\n", content)
            
            next_step = matches[-1].strip() if matches else "TBD"
            code_path = code_matches[-1].strip() if code_matches else None
            
            return next_step, code_path
    except Exception as e:
        print(f"Error reading log for {goal_id}: {e}")
        return "Error", None

def generate_briefing():
    """Construct the Mission Briefing block."""
    # We'll pull these from the system recommendations logic in autonomous_daily_manager
    try:
        import sys
        sys.path.append("/home/{{USER}}/Documents/autonomous-living/scripts")
        from autonomous_daily_manager import get_goal_recommendations
        recs_text = get_goal_recommendations() 
        gids = re.findall(r"\*\*(G\d{2})\*\*", recs_text)
    except Exception as e:
        print(f"Briefing generation error (recs): {e}")
        gids = []
    
    if not gids:
        gids = ["G04", "G10", "G05"]

    briefing = "\n## 🚀 Morning Mission Briefing (06:00-09:00)\n"
    briefing += "_Zero-delay execution guide for your Deep Work block._\n\n"
    
    for gid in gids[:3]:
        next_step, code_path = get_latest_next_step(gid)
        goal_folders = [f for f in os.listdir(GOALS_PATH) if f.startswith(gid)]
        if not goal_folders: continue
        goal_folder = goal_folders[0]
        
        briefing += f"### 🎯 {gid}: {goal_folder[4:].replace('-', ' ')}\n"
        briefing += f"- **Current Mission:** {next_step}\n"
        briefing += f"- **Context:** [[{goal_folder}/README|Goal Brief]] | [[{goal_folder}/Roadmap|Roadmap]]\n"
        if code_path:
            briefing += f"- **Quick Start:** `{code_path}`\n"
        briefing += "\n"

    briefing += "---\n"
    return briefing

def inject_briefing():
    today_str = datetime.date.today().strftime("%Y-%m-%d")
    note_path = os.path.join(DAILY_NOTES_DIR, f"{today_str}.md")
    
    if not os.path.exists(note_path):
        print(f"❌ Today's note not found: {note_path}")
        return

    briefing_block = generate_briefing()
    
    with open(note_path, 'r') as f:
        content = f.read()

    if "## 🚀 Morning Mission Briefing" in content:
        # Update existing
        content = re.sub(r"## 🚀 Morning Mission Briefing.*?(?=\n---|\n## )", briefing_block.strip(), content, flags=re.DOTALL)
    else:
        # Insert after the Insights block
        if "### 🧠 Director's Insights" in content:
             content = re.sub(r"(### 🧠 Director's Insights.*?\n)", r"\1" + briefing_block, content, flags=re.DOTALL)
        else:
            content = content.replace("# 2026", "# 2026" + briefing_block)

    with open(note_path, 'w') as f:
        f.write(content)
    print(f"✅ Mission Briefing injected into {today_str}.md")

if __name__ == "__main__":
    inject_briefing()
