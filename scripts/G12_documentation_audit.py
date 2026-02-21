import os
import re
from datetime import datetime
from pathlib import Path

# Paths
DOCS_DIR = "/home/{{USER}}/Documents/autonomous-living/docs"
GOALS_DIR = os.path.join(DOCS_DIR, "10_Goals")
SYSTEMS_DIR = os.path.join(DOCS_DIR, "20_Systems")
AUTOMATIONS_DIR = os.path.join(DOCS_DIR, "50_Automations")

REQUIRED_GOAL_FILES = ["README.md", "Outcomes.md", "Metrics.md", "Systems.md", "Roadmap.md"]
GOAL_FRONTMATTER = ["title", "type", "status", "goal_id", "owner", "updated"]

class DocAuditor:
    def __init__(self):
        self.report = []
        self.stats = {"goals": 0, "systems": 0, "automations": 0, "errors": 0}

    def log(self, text):
        self.report.append(text)

    def validate_frontmatter(self, file_path, required_fields):
        if not os.path.exists(file_path): return ["File Missing"]
        with open(file_path, 'r') as f:
            content = f.read()
            fm_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
            if not fm_match: return ["Missing Frontmatter"]
            
            fm_text = fm_match.group(1)
            missing = [field for field in required_fields if f"{field}:" not in fm_text]
            return missing

    def check_traceability(self, goal_path):
        """Verify that Systems.md links to existing System and Automation files."""
        systems_file = os.path.join(goal_path, "Systems.md")
        if not os.path.exists(systems_file): return ["Systems.md Missing"]
        
        errors = []
        with open(systems_file, 'r') as f:
            content = f.read()
            # Extract relative links like ../../20_Systems/S01/README.md
            links = re.findall(r"\[.*?\]\((.*?)\)", content)
            for link in links:
                if link.startswith("http"): continue
                # Strip anchor tags
                clean_link = link.split("#")[0]
                if not clean_link: continue # Skip pure anchor links
                
                # Resolve relative path
                full_path = os.path.abspath(os.path.join(goal_path, clean_link))
                if not os.path.exists(full_path):
                    errors.append(f"Broken Link: {link}")
        return errors

    def check_roadmap_freshness(self, roadmap_path):
        """Check if Q1 goals are being checked off."""
        if not os.path.exists(roadmap_path): return "N/A"
        with open(roadmap_path, 'r') as f:
            content = f.read()
            q1_section = re.search(r"## Q1(.*?)(?=\n## Q2|\Z)", content, re.DOTALL)
            if q1_section:
                tasks = re.findall(r"- \[([ xX])\]", q1_section.group(1))
                if not tasks: return "No Tasks"
                done = tasks.count('x') + tasks.count('X')
                pct = (done / len(tasks)) * 100
                return f"{pct:.0f}% Complete"
        return "No Q1"

    def run(self):
        self.log(f"# 🕵️ G12: System Documentation Audit Report")
        self.log(f"**Timestamp:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        self.log(f"**North Star:** [Automation-First Living](../00_Start-here/North-Star.md)\n")

        # 🎯 GOALS AUDIT
        self.log("## 🎯 Goal Tier Audit")
        self.log("| Goal | Health | Files | Frontmatter | Roadmap | Traceability |")
        self.log("| :--- | :---: | :--- | :--- | :---: | :--- |")

        for goal in sorted(os.listdir(GOALS_DIR)):
            if not goal.startswith("G"): continue
            goal_path = os.path.join(GOALS_DIR, goal)
            self.stats["goals"] += 1
            
            # 1. File Check
            missing_files = [f for f in REQUIRED_GOAL_FILES if not os.path.exists(os.path.join(goal_path, f))]
            
            # 2. Frontmatter Check
            fm_errors = self.validate_frontmatter(os.path.join(goal_path, "README.md"), GOAL_FRONTMATTER)
            
            # 3. Roadmap Status
            roadmap_status = self.check_roadmap_freshness(os.path.join(goal_path, "Roadmap.md"))
            
            # 4. Traceability
            trace_errors = self.check_traceability(goal_path)
            
            # Score
            score_icon = "✅"
            if missing_files or fm_errors or trace_errors:
                score_icon = "⚠️"
                self.stats["errors"] += 1
            if not os.path.exists(os.path.join(goal_path, "README.md")):
                score_icon = "❌"

            self.log(f"| {goal[:3]} | {score_icon} | {len(REQUIRED_GOAL_FILES)-len(missing_files)}/{len(REQUIRED_GOAL_FILES)} | {', '.join(fm_errors) if fm_errors else '✅'} | {roadmap_status} | {len(trace_errors) if trace_errors else '✅'} |")

        # ⚙️ SYSTEMS AUDIT
        self.log("\n## ⚙️ System Tier Audit")
        self.log("| ID | System Name | README Status | Has Sub-Docs |")
        self.log("| :--- | :--- | :---: | :---: |")
        
        for sys in sorted(os.listdir(SYSTEMS_DIR)):
            sys_path = os.path.join(SYSTEMS_DIR, sys)
            if not os.path.isdir(sys_path): continue
            if not sys.startswith("S"): continue
            self.stats["systems"] += 1
            has_readme = os.path.exists(os.path.join(sys_path, "README.md"))
            sub_docs = len([f for f in os.listdir(sys_path) if f.endswith(".md") and f != "README.md"])
            
            self.log(f"| {sys[:3]} | {sys[4:].replace('-', ' ')} | {'✅' if has_readme else '❌'} | {sub_docs} |")

        # 📊 SUMMARY
        self.log("\n## 📊 Compliance Summary")
        total = self.stats["goals"] + self.stats["systems"]
        health_pct = ((total - self.stats["errors"]) / total) * 100
        self.log(f"- **Overall Documentation Health:** {health_pct:.1f}%")
        self.log(f"- **Total Goals Audited:** {self.stats['goals']}")
        self.log(f"- **Total Systems Audited:** {self.stats['systems']}")
        self.log(f"- **Total Critical Errors:** {self.stats['errors']}")

        # Write to file
        output_path = os.path.join(DOCS_DIR, "G12_Documentation_Audit_Report.md")
        with open(output_path, 'w') as f:
            f.write("\n".join(self.report))
        print(f"✅ Enhanced Audit complete: {output_path}")

if __name__ == "__main__":
    auditor = DocAuditor()
    auditor.run()
