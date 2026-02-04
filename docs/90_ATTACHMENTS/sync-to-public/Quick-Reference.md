# Sync-to-Public Quick Reference

## **Standard Workflow**

```bash
# 1. Navigate to private repo
cd ~/Documents/autonomous-living

# 2. Ensure clean state
git status  # Should show "nothing to commit, working tree clean"

# 3. Run sync (dry-run first)
python3 scripts/sync-to-public.py --dry-run

# 4. Review dry-run output, then sync for real
python3 scripts/sync-to-public.py

# 5. Navigate to public repo
cd ~/Documents/autonomous-living-architecture

# 6. Verify no sensitive data leaked
grep -r "192\.168\." . --include="*.md"  # Should be empty
find . -name "_meta" -o -name ".env"     # Should be empty

# 7. Review changes
git status
git diff

# 8. Commit and push
git add .
git commit -m "Sync from private: $(date +%Y-%m-%d)"
git push origin main
```

Emergency: Sensitive Data Leaked

```bash
# 1. DO NOT PANIC - git history can be rewritten
cd ~/Documents/autonomous-living-architecture

# 2. Remove file from current commit
git rm path/to/sensitive/file.md
git commit --amend

# 3. If already pushed, rewrite history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/sensitive/file.md"
  --prune-empty -- --all

# 4. Force push (rewrites public history)
git push --force origin main

# 5. Update exclusion list in sync script
```

Common Commands

```bash
# Test sync without changes
python3 scripts/sync-to-public.py --dry-run

# Sync with debug output
python3 scripts/sync-to-public.py --debug

# Show help
python3 scripts/sync-to-public.py --help

# Check for uncommitted changes in private repo
cd ~/Documents/autonomous-living && git status

# Rollback last public commit
cd ~/Documents/autonomous-living-architecture
git reset --hard HEAD~1
git push --force origin main
```

