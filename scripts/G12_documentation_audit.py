import os
import re

DOCS_DIR = "/home/{{USER}}/Documents/autonomous-living/docs"
GOALS_DIR = os.path.join(DOCS_DIR, "10_GOALS")
SYSTEMS_DIR = os.path.join(DOCS_DIR, "20_SYSTEMS")

REQUIRED_GOAL_FILES = ["README.md", "Outcomes.md", "Metrics.md", "Systems.md", "Roadmap.md"]
REQUIRED_HEADERS = [
    "Purpose", "Scope", "Inputs", "Outputs", "Dependencies", 
    "Procedure", "Failure Modes", "Security Notes", "Owner"
]

def audit_file(file_path):
    if not os.path.exists(file_path):
        return ["File Missing"]
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    missing = []
    for header in REQUIRED_HEADERS:
        # Check for both Markdown headers (# Header) and plain bold headers or list items
        if not re.search(f"(#+.*{header}|\*\*{header})", content, re.IGNORECASE):
            missing.append(header)
    return missing

def run_audit():
    report = "# Documentation Compliance Audit Report\n\n"
    report += f"**Date:** {os.popen('date').read().strip()}\n\n"
    
    # Audit Goals
    report += "## 🎯 Goal Documentation Audit\n"
    report += "| Goal | Missing Files | Missing Headers (README) |\n"
    report += "| :--- | :--- | :--: |\n"
    
    for goal_folder in sorted(os.listdir(GOALS_DIR)):
        path = os.path.join(GOALS_DIR, goal_folder)
        if os.path.isdir(path) and goal_folder.startswith("G"):
            missing_files = [f for f in REQUIRED_GOAL_FILES if not os.path.exists(os.path.join(path, f))]
            readme_missing_headers = audit_file(os.path.join(path, "README.md"))
            
            files_str = ", ".join(missing_files) if missing_files else "✅"
            headers_str = ", ".join(readme_missing_headers) if readme_missing_headers else "✅"
            report += f"| {goal_folder} | {files_str} | {headers_str} |\n"

    # Audit Systems
    report += "\n## ⚙️ System Documentation Audit\n"
    report += "| System | Missing Headers (README) |\n"
    report += "| :--- | :--- |\n"
    
    for sys_folder in sorted(os.listdir(SYSTEMS_DIR)):
        path = os.path.join(SYSTEMS_DIR, sys_folder)
        if os.path.isdir(path) and sys_folder.startswith("S"):
            readme_missing_headers = audit_file(os.path.join(path, "README.md"))
            headers_str = ", ".join(readme_missing_headers) if readme_missing_headers else "✅"
            report += f"| {sys_folder} | {headers_str} |\n"

    output_path = os.path.join(DOCS_DIR, "G12_Documentation_Audit_Report.md")
    with open(output_path, 'w') as f:
        f.write(report)
    print(f"✅ Audit complete. Report saved to: {output_path}")

if __name__ == '__main__':
    run_audit()
