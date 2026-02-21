import os
import re
import yaml
from datetime import datetime, timedelta
from pathlib import Path

# Paths
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")
WEEKLY_REVIEWS_DIR = os.path.join(OBSIDIAN_VAULT, "03_Areas/A - Systems/Reviews")

def get_last_7_days():
    """Return a list of dates for the last 7 days ending today."""
    today = datetime.now().date()
    return [(today - timedelta(days=i)).strftime("%Y-%m-%d") for i in range(7)]

def parse_daily_note(date_str):
    """Extract frontmatter and key sections from a daily note."""
    file_path = os.path.join(DAILY_NOTES_DIR, f"{date_str}.md")
    if not os.path.exists(file_path):
        return None
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # 1. Parse Frontmatter
    fm = {}
    fm_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if fm_match:
        try:
            fm = yaml.safe_load(fm_match.group(1)) or {}
        except:
            pass
            
    # 2. Extract Highlights/Frustrations
    highlight = fm.get('highlight', '')
    frustration = fm.get('frustration', '')
    
    # Fallback to searching in content if YAML is empty
    if not highlight:
        h_match = re.search(r'## After Work - Overview\n- Highlight: (.*)', content)
        if h_match: highlight = h_match.group(1).strip()
        
    if not frustration:
        f_match = re.search(r'- Frustration: (.*)', content)
        if f_match: frustration = f_match.group(1).strip()

    # Normalize Energy (often a list in templates)
    energy_raw = fm.get('energy', 3)
    if isinstance(energy_raw, list) and len(energy_raw) > 0:
        # Extract first digit from first item like "5 - peak"
        energy_val = int(re.search(r'\d', str(energy_raw[0])).group())
    elif isinstance(energy_raw, (int, float)):
        energy_val = int(energy_raw)
    else:
        energy_val = 3

    return {
        "date": date_str,
        "energy": energy_val,
        "sleep": fm.get('sleep_duration', 0) or 0,
        "sleep_quality": fm.get('sleep_quality', 3) or 3,
        "steps": fm.get('steps', 0) or 0,
        "calories": fm.get('calories', 0) or 0,
        "protein": fm.get('protein', 0) or 0,
        "goals_touched": fm.get('goals_touched', []),
        "highlight": highlight,
        "frustration": frustration,
        "workout_type": fm.get('workout_type', '')
    }

def aggregate_weekly_data():
    dates = get_last_7_days()
    daily_stats = []
    for d in dates:
        note_data = parse_daily_note(d)
        if note_data:
            daily_stats.append(note_data)
            
    if not daily_stats:
        return None
        
    total_days = len(daily_stats)
    
    # Aggregates with safety for None types
    avg_sleep = sum(float(s['sleep']) for s in daily_stats) / total_days
    avg_quality = sum(float(s['sleep_quality']) for s in daily_stats) / total_days
    avg_energy = sum(int(s['energy']) for s in daily_stats) / total_days
    total_steps = sum(int(s['steps']) for s in daily_stats)
    
    # Goals Frequency
    all_goals = []
    for s in daily_stats:
        all_goals.extend(s['goals_touched'])
    
    goal_freq = {}
    for g in all_goals:
        goal_freq[g] = goal_freq.get(g, 0) + 1
        
    # Highlights/Lowlights
    highlights = [f"[[{s['date']}]] - {s['highlight']}" for s in daily_stats if s['highlight']]
    lowlights = [f"[[{s['date']}]] - {s['frustration']}" for s in daily_stats if s['frustration']]
    
    # Workouts
    workouts = [f"[[{s['date']}]] ({s['workout_type']})" for s in daily_stats if s['workout_type'] and s['workout_type'].lower() != 'rest']

    return {
        "start_date": min(dates),
        "end_date": max(dates),
        "week_str": datetime.now().strftime("%Y-W%U"),
        "avg_sleep": round(avg_sleep, 1),
        "avg_quality": round(avg_quality, 1),
        "avg_energy": round(avg_energy, 1),
        "avg_steps": int(total_steps / total_days),
        "goal_freq": goal_freq,
        "highlights": highlights,
        "lowlights": lowlights,
        "workouts": workouts,
        "daily_links": [f"[[{d}]]" for d in sorted(dates)]
    }

def create_weekly_review():
    data = aggregate_weekly_data()
    if not data:
        print("No daily notes found for the last 7 days. Review aborted.")
        return

    # Prepare Goal Check-in section
    goal_checkin = ""
    for i in range(1, 13):
        gid = f"G{i:02d}"
        count = data['goal_freq'].get(gid, 0)
        status = "[x]" if count > 0 else "[ ]"
        goal_checkin += f"- {status} **{gid}**: {count} sessions this week\n"

    # Template
    template = f"""---
week: {data['week_str']}
year: {datetime.now().year}
start: {data['start_date']}
end: {data['end_date']}
north_star: "[[P - Goals - 2026 Automation-First Living]]"
tags:
  - weekly
---

# Weekly Review – {data['week_str']} ({data['start_date']} – {data['end_date']})

## 1. Snapshot of the Week (Autonomous Aggregation)

### 1.1 Metrics
- **Sleep:** avg {data['avg_sleep']} h; quality ~ {data['avg_quality']} / 5
- **Training:** {len(data['workouts'])} sessions
- **Steps:** ~ {data['avg_steps']} / day
- **Energy trend:** {data['avg_energy']} / 5

### 1.2 Highlights & Lowlights
**Highlights (from Dailies):**
{chr(10).join("- " + h for h in data['highlights'])}

**Lowlights (from Dailies):**
{chr(10).join("- " + l for l in data['lowlights'])}

---

## 2. Daily Notes Summary
- **Dailies this week:** {', '.join(data['daily_links'])}
- **Workouts logged:** {', '.join(data['workouts']) if data['workouts'] else "None"}

---

## 3. 12 Power Goals – Weekly Check-in
{goal_checkin}

**Strategic Focus Suggestion:**
"""
    
    # Intelligent suggestion for next week
    starved_goals = [f"G{i:02d}" for i in range(1, 13) if f"G{i:02d}" not in data['goal_freq']]
    if starved_goals:
        template += f"⚠️ The following goals were **starved** this week: {', '.join(starved_goals[:3])}. Consider prioritizing one of these next week.\n"
    else:
        template += "✅ All systems active. Maintain current momentum.\n"

    # Save file
    file_name = f"{data['week_str']}.md"
    target_path = os.path.join(WEEKLY_REVIEWS_DIR, file_name)
    
    with open(target_path, 'w') as f:
        f.write(template)
    
    print(f"✅ Weekly Review generated successfully: {target_path}")

if __name__ == "__main__":
    create_weekly_review()
