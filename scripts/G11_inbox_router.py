import os
import re
import yaml
from pathlib import Path

# Configuration
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
INBOX_DIR = os.path.join(OBSIDIAN_VAULT, "00_Inbox")
GOALS_PATH = "/home/{{USER}}/Documents/autonomous-living/docs/10_Goals"

# Goal Keywords for simple routing logic
GOAL_KEYWORDS = {
    "G01": ["workout", "muscle", "protein", "body fat", "training", "gym"],
    "G02": ["substack", "automationbro", "brand", "audience", "article"],
    "G03": ["pantry", "grocery", "shopping", "household", "home admin"],
    "G04": ["digital twin", "avatar", "api", "twin engine"],
    "G05": ["finance", "budget", "savings", "investment", "credit card", "bank"],
    "G06": ["exam", "certification", "study", "learning", "six sigma"],
    "G07": ["health", "biometric", "withings", "sleep", "hrv", "blood"],
    "G08": ["smart home", "home assistant", "zigbee", "sensor", "automation"],
    "G09": ["career", "job", "professional", "resume", "positioning"],
    "G10": ["productivity", "calendar", "time architecture", "pomodoro"],
    "G11": ["meta-system", "integration", "optimization", "n8n"],
    "G12": ["documentation", "audit", "standard", "sop", "readme"]
}

def route_inbox_files():
    """Scan inbox, suggest goals, and add a summary block."""
    print("🧠 Routing Obsidian Inbox items...")
    
    if not os.path.exists(INBOX_DIR):
        print("❌ Inbox not found.")
        return

    for filename in os.listdir(INBOX_DIR):
        if not filename.endswith(".md"): continue
        file_path = os.path.join(INBOX_DIR, filename)
        
        with open(file_path, 'r') as f:
            content = f.read()
        
        # 1. Detect Goal Alignment
        matched_goals = []
        lower_content = content.lower()
        for gid, keywords in GOAL_KEYWORDS.items():
            if any(k in lower_content for k in keywords):
                matched_goals.append(gid)
        
        # 2. Extract Key Points (Simulated Intelligence)
        # We'll take the first few non-empty lines as "Summary"
        lines = [l.strip() for l in content.split('
') if l.strip() and not l.startswith('#') and not l.startswith('---')]
        summary = lines[:3]
        
        # 3. Inject Routing Block
        if "## 🧠 Intelligence Router" not in content:
            routing_block = "
---
## 🧠 Intelligence Router
"
            if matched_goals:
                routing_block += f"**Suggested Goals:** {' '.join([f'#goal-{g.lower()}' for g in matched_goals])}
"
            else:
                routing_block += "**Suggested Goals:** #uncategorized
"
            
            routing_block += "
**Quick Summary:**
"
            for line in summary:
                routing_block += f"- {line[:100]}...
"
            
            routing_block += f"
**Action:** Move to `02_Projects/Goal-{matched_goals[0] if matched_goals else 'Misc'}`
"
            
            # Add to top (after frontmatter)
            fm_match = re.match(r'^---
(.*?)
---
', content, re.DOTALL)
            if fm_match:
                new_content = f"---{fm_match.group(1)}---
{routing_block}
{content[fm_match.end():]}"
            else:
                new_content = routing_block + "
" + content
                
            with open(file_path, 'w') as f:
                f.write(new_content)
            print(f"✅ Routed: {filename}")

if __name__ == "__main__":
    route_inbox_files()
