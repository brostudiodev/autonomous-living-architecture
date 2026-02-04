#!/usr/bin/env python3
"""
Sync autonomous-living private repo to public architecture repo.
Sanitizes sensitive data while preserving architectural documentation.
"""

import os
import re
import shutil
from pathlib import Path

# Sanitization patterns
SANITIZE_PATTERNS = [
    (r'192\.168\.\d+\.\d+', '{{INTERNAL_IP}}'),
    (r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', '{{EMAIL}}'),
    (r'(api[_-]?key|token)["\s:=]+["\\]?[\\w-]+', r'\1: {{API_SECRET}}'),
    # Add more patterns as needed
]

# Exclude these paths completely
EXCLUDE_PATHS = [
    '_meta/',
    'scripts/log_workout.py',
    'infrastructure/docker-compose.yml',  # Use .example version
    'docs/10_GOALS/**/Training/data/',
]

def sanitize_content(content: str) -> str:
    """Apply sanitization patterns to content."""
    for pattern, replacement in SANITIZE_PATTERNS:
        content = re.sub(pattern, replacement, content)
    return content

def should_exclude(path: Path, base_path: Path) -> bool:
    """Check if path should be excluded from sync."""
    relative = str(path.relative_to(base_path))
    return any(exclude in relative for exclude in EXCLUDE_PATHS)

def sync_to_public(private_repo: Path, public_repo: Path):
    """Main sync function."""
    print(f"Syncing from {private_repo} to {public_repo}")
    
    # Copy structure while sanitizing
    for item in private_repo.rglob('*'):
        if item.is_file() and not should_exclude(item, private_repo):
            relative_path = item.relative_to(private_repo)
            target_path = public_repo / relative_path
            
            # Ensure target directory exists
            target_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Read, sanitize, write
            if item.suffix in ['.md', '.yml', '.yaml', '.json', '.py']:
                content = item.read_text(encoding='utf-8')
                sanitized = sanitize_content(content)
                target_path.write_text(sanitized, encoding='utf-8')
                print(f"✓ Sanitized: {relative_path}")
            else:
                shutil.copy2(item, target_path)
                print(f"✓ Copied: {relative_path}")

if __name__ == '__main__':
    private_repo = Path('/home/michal/Documents/autonomous-living')
    public_repo = Path('/home/michal/Documents/autonomous-living-architecture')
    sync_to_public(private_repo, public_repo)
