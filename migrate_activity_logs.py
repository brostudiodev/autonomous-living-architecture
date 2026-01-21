#!/usr/bin/env python3
"""
Activity Log Migration Script
Migrates entries from goal-gXX/ACTIVITY.md → docs/10_GOALS/GXX_*/ACTIVITY_LOG.md

Author: Michał Nowakowski
Date: 2026-01-21
"""

import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# Cross-platform UTF-8 handling
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except AttributeError:
        import codecs
        sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer)
        sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer)


class ActivityMigrator:
    """Migrates activity logs from legacy to documentation structure."""
    
    GOAL_MAP = {
        "G01": "G01_Target-Body-Fat",
        "G02": "G02_Automationbro-Recognition",
        "G03": "G03_Autonomous-Household-Operations",
        "G04": "G04_Digital-Twin-Ecosystem",
        "G05": "G05_Autonomous-Financial-Command-Center",
        "G06": "G06_Certification-Exams",
        "G07": "G07_Predictive-Health-Management",
        "G08": "G08_Predictive-Smart-Home-Orchestration",
        "G09": "G09_Complete-Process-Documentation",
        "G10": "G10_Automated-Career-Intelligence",
        "G11": "G11_Intelligent-Productivity-Time-Architecture",
        "G12": "G12_Meta-System-Integration-Optimization",
    }
    
    GOAL_NAMES = {
        "G01": "Target Body Fat",
        "G02": "Automationbro Recognition",
        "G03": "Autonomous Household Operations",
        "G04": "Digital Twin Ecosystem",
        "G05": "Autonomous Financial Command Center",
        "G06": "Certification Exams",
        "G07": "Predictive Health Management",
        "G08": "Predictive Smart Home Orchestration",
        "G09": "Complete Process Documentation",
        "G10": "Automated Career Intelligence",
        "G11": "Intelligent Productivity & Time Architecture",
        "G12": "Meta-System Integration & Optimization",
    }
    
    def __init__(self, repo_path: Path, dry_run: bool = False):
        self.repo_path = repo_path
        self.dry_run = dry_run
        self.legacy_base = repo_path
        self.docs_base = repo_path / "docs" / "10_GOALS"
        
        self.stats = {
            'goals_processed': 0,
            'entries_migrated': 0,
            'entries_skipped': 0,
            'errors': 0,
        }
    
    def parse_activity_entries(self, content: str) -> List[Dict]:
        """
        Parse ACTIVITY.md content into individual date entries.
        
        Expected format:
        ## 2026-01-20 (Monday)
        
        **Action:** Did something
        
        **Next Step:** Do something else
        
        **Code:** `goal-g01/some-path`
        
        ---
        """
        entries = []
        
        # Pattern to match each entry block
        pattern = r'## (\d{4}-\d{2}-\d{2})(?:\s*\(([^)]*)\))?\s*\n(.*?)(?=\n## \d{4}-\d{2}-\d{2}|\n---\s*$|\Z)'
        
        matches = re.finditer(pattern, content, re.DOTALL)
        
        for match in matches:
            date = match.group(1)
            weekday = match.group(2) or ''
            block = match.group(3)
            
            entry = {
                'date': date,
                'weekday': weekday.strip(),
                'action': '',
                'next_step': '',
                'code': '',
                'raw_block': block,
            }
            
            # Extract Action/Did
            action_match = re.search(r'\*\*(?:Action|Did):\*\*\s*(.+?)(?=\n\*\*|\n\n|$)', block, re.IGNORECASE)
            if action_match:
                entry['action'] = action_match.group(1).strip()
            
            # Extract Next Step
            next_match = re.search(r'\*\*Next(?: Step)?:\*\*\s*(.+?)(?=\n\*\*|\n\n|$)', block, re.IGNORECASE)
            if next_match:
                entry['next_step'] = next_match.group(1).strip()
            
            # Extract Code path
            code_match = re.search(r'\*\*Code:\*\*\s*`([^`]+)`', block, re.IGNORECASE)
            if code_match:
                entry['code'] = code_match.group(1).strip()
            
            entries.append(entry)
        
        return entries
    
    def format_entry(self, entry: Dict) -> str:
        """Format a single entry for the target ACTIVITY_LOG.md."""
        header = f"## {entry['date']}"
        if entry['weekday']:
            header += f" ({entry['weekday']})"
        
        lines = [header, ""]
        
        if entry['action']:
            lines.append(f"**Action:** {entry['action']}")
            lines.append("")
        
        if entry['next_step']:
            lines.append(f"**Next Step:** {entry['next_step']}")
            lines.append("")
        
        if entry['code']:
            lines.append(f"**Code:** `{entry['code']}`")
            lines.append("")
        
        lines.append("---")
        lines.append("")
        
        return "\n".join(lines)
    
    def get_existing_dates(self, content: str) -> set:
        """Extract dates already present in target file."""
        dates = set()
        pattern = r'## (\d{4}-\d{2}-\d{2})'
        for match in re.finditer(pattern, content):
            dates.add(match.group(1))
        return dates
    
    def create_activity_log_header(self, goal_id: str) -> str:
        """Create header for new ACTIVITY_LOG.md file."""
        goal_name = self.GOAL_NAMES.get(goal_id, "Unknown Goal")
        return f"""# Activity Log: {goal_name}

*Auto-generated activity tracking from daily notes.*

> **Goal ID:** {goal_id}  
> **Last Migration:** 2026-01-21

---

"""
    
    def migrate_goal(self, goal_id: str) -> Tuple[int, int]:
        """
        Migrate a single goal's activity log.
        
        Returns: (migrated_count, skipped_count)
        """
        legacy_path = self.legacy_base / f"goal-{goal_id.lower()}" / "ACTIVITY.md"
        target_folder = self.GOAL_MAP.get(goal_id)
        
        if not target_folder:
            print(f"   ⚠️  No mapping for {goal_id}")
            return 0, 0
        
        target_path = self.docs_base / target_folder / "ACTIVITY_LOG.md"
        
        # Check if legacy file exists
        if not legacy_path.exists():
            print(f"   ℹ️  {goal_id}: No legacy file found at {legacy_path.name}")
            return 0, 0
        
        # Read legacy content
        try:
            legacy_content = legacy_path.read_text(encoding='utf-8')
        except Exception as e:
            print(f"   ❌ {goal_id}: Error reading legacy file: {e}")
            self.stats['errors'] += 1
            return 0, 0
        
        # Parse entries
        entries = self.parse_activity_entries(legacy_content)
        
        if not entries:
            print(f"   ℹ️  {goal_id}: No entries found in legacy file")
            return 0, 0
        
        # Read or create target content
        if target_path.exists():
            try:
                target_content = target_path.read_text(encoding='utf-8')
            except Exception as e:
                print(f"   ❌ {goal_id}: Error reading target file: {e}")
                self.stats['errors'] += 1
                return 0, 0
        else:
            target_content = self.create_activity_log_header(goal_id)
        
        # Get existing dates to avoid duplicates
        existing_dates = self.get_existing_dates(target_content)
        
        # Filter and format new entries
        migrated = 0
        skipped = 0
        new_entries = []
        
        for entry in entries:
            if entry['date'] in existing_dates:
                skipped += 1
                continue
            
            new_entries.append(self.format_entry(entry))
            migrated += 1
        
        if not new_entries:
            print(f"   ℹ️  {goal_id}: All {skipped} entries already exist in target")
            return 0, skipped
        
        # Append new entries to target
        updated_content = target_content.rstrip() + "\n\n" + "\n".join(new_entries)
        
        if self.dry_run:
            print(f"   🔍 {goal_id}: Would migrate {migrated} entries (skip {skipped})")
            print(f"      Source: {legacy_path}")
            print(f"      Target: {target_path}")
        else:
            try:
                # Ensure target directory exists
                target_path.parent.mkdir(parents=True, exist_ok=True)
                target_path.write_text(updated_content, encoding='utf-8')
                print(f"   ✅ {goal_id}: Migrated {migrated} entries (skipped {skipped} duplicates)")
            except Exception as e:
                print(f"   ❌ {goal_id}: Error writing target file: {e}")
                self.stats['errors'] += 1
                return 0, 0
        
        return migrated, skipped
    
    def cleanup_legacy_files(self, goal_ids: List[str]) -> int:
        """
        Remove legacy ACTIVITY.md files after successful migration.
        Only call this after verifying migration was successful.
        """
        removed = 0
        
        for goal_id in goal_ids:
            legacy_path = self.legacy_base / f"goal-{goal_id.lower()}" / "ACTIVITY.md"
            
            if not legacy_path.exists():
                continue
            
            if self.dry_run:
                print(f"   🔍 Would remove: {legacy_path}")
                removed += 1
            else:
                try:
                    legacy_path.unlink()
                    print(f"   🗑️  Removed: {legacy_path}")
                    removed += 1
                except Exception as e:
                    print(f"   ⚠️  Could not remove {legacy_path}: {e}")
        
        return removed
    
    def run(self, cleanup: bool = False):
        """Execute the migration."""
        print("=" * 70)
        print("📦 Activity Log Migration Tool")
        print(f"   Repository: {self.repo_path}")
        print(f"   Mode: {'DRY RUN' if self.dry_run else 'LIVE'}")
        print("=" * 70)
        print()
        
        # Validate paths
        if not self.docs_base.exists():
            print(f"❌ Documentation base not found: {self.docs_base}")
            return
        
        print("🔄 Migrating activity logs...")
        print()
        
        migrated_goals = []
        
        for goal_id in sorted(self.GOAL_MAP.keys()):
            migrated, skipped = self.migrate_goal(goal_id)
            
            self.stats['entries_migrated'] += migrated
            self.stats['entries_skipped'] += skipped
            
            if migrated > 0:
                self.stats['goals_processed'] += 1
                migrated_goals.append(goal_id)
        
        print()
        print("-" * 70)
        print("📊 Migration Summary")
        print("-" * 70)
        print(f"   Goals with migrations: {self.stats['goals_processed']}")
        print(f"   Entries migrated:      {self.stats['entries_migrated']}")
        print(f"   Entries skipped:       {self.stats['entries_skipped']} (already existed)")
        print(f"   Errors:                {self.stats['errors']}")
        print()
        
        # Optional cleanup
        if cleanup and migrated_goals and self.stats['errors'] == 0:
            print("🧹 Cleaning up legacy files...")
            removed = self.cleanup_legacy_files(migrated_goals)
            print(f"   Removed {removed} legacy file(s)")
            print()
        
        if self.dry_run:
            print("💡 This was a DRY RUN. No files were modified.")
            print("   Run without --dry-run to perform actual migration.")
        else:
            print("✅ Migration complete!")
        
        print()


def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Migrate activity logs from goal-gXX/ to docs/10_GOALS/",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Preview what would be migrated (safe)
  python migrate_activity_logs.py --dry-run
  
  # Perform actual migration
  python migrate_activity_logs.py
  
  # Migrate and remove old files
  python migrate_activity_logs.py --cleanup
  
  # Specify custom repo path
  python migrate_activity_logs.py --repo /path/to/autonomous-living
        """
    )
    
    parser.add_argument(
        '--repo', '-r',
        type=Path,
        default=None,
        help='Path to autonomous-living repository (default: auto-detect)'
    )
    
    parser.add_argument(
        '--dry-run', '-n',
        action='store_true',
        help='Preview changes without modifying files'
    )
    
    parser.add_argument(
        '--cleanup', '-c',
        action='store_true',
        help='Remove legacy files after successful migration'
    )
    
    args = parser.parse_args()
    
    # Auto-detect repo path
    if args.repo:
        repo_path = args.repo.resolve()
    else:
        # Try to find autonomous-living relative to script location
        script_dir = Path(__file__).resolve().parent
        
        # Check common locations
        candidates = [
            script_dir,                          # Script is in repo root
            script_dir.parent,                   # Script is in subfolder
            script_dir.parent / "autonomous-living",
            Path.home() / "autonomous-living",
        ]
        
        repo_path = None
        for candidate in candidates:
            if (candidate / "docs" / "10_GOALS").exists():
                repo_path = candidate
                break
        
        if not repo_path:
            print("❌ Could not auto-detect autonomous-living repository.")
            print("   Please specify with --repo /path/to/autonomous-living")
            sys.exit(1)
    
    if not repo_path.exists():
        print(f"❌ Repository path does not exist: {repo_path}")
        sys.exit(1)
    
    migrator = ActivityMigrator(repo_path, dry_run=args.dry_run)
    migrator.run(cleanup=args.cleanup)


if __name__ == "__main__":
    main()
