---
name: reconcile-backup
description: Reconciles the latest local backup (created by overwrite-local) against the repo's dotfiles. Use this skill when the user runs /reconcile-backup or asks to compare, reconcile, diff, or restore from a local backup. Also triggers for "check backup", "what changed when I overwrote", "bring back local changes", or "did I lose anything".
---

# Reconcile Backup

After running `./overwrite-local`, a timestamped backup of the previous `$HOME` state is saved to `_local-backup/`. This skill compares that backup against the current repo dotfiles to surface meaningful differences — files the backup had that the repo doesn't, files the repo has that the backup didn't, and content-level diffs — then helps the user selectively restore changes.

## Context

- **Repo dotfiles:** `dotfiles/` — the source of truth checked into git
- **Local backups:** `_local-backup/<timestamp>/` — snapshots of `$HOME` taken by `overwrite-local` before it overwrites
- **Filter rules:** `filter.txt` — rsync filter controlling which files are tracked; only files matching these rules are relevant
- **Linux-only configs:** dirs like `xfce4`, `i3`, `openbox`, `polybar`, `rofi`, `tint2`, `dunst`, `terminator` are commented out in `filter.txt` — they exist in the repo from legacy Linux usage but should be excluded from comparisons on macOS

## Procedure

### Step 1: Identify the backup to compare

List `_local-backup/` and pick the most recent timestamp directory. If multiple backups exist, confirm with the user which one to compare (default to latest).

```bash
ls -1t _local-backup/ | head -5
```

### Step 2: Run a recursive diff

Compare the backup against `dotfiles/` to get a file-level summary:

```bash
diff -rq _local-backup/<timestamp>/ dotfiles/
```

### Step 3: Categorize differences

Organize the diff output into three buckets:

1. **Backup-only files** — files that existed locally but are not in the repo. These are potential gaps where local customizations were lost.
2. **Repo-only files** — files in the repo but not in the backup. Filter out Linux-only configs (xfce4, i3, openbox, polybar, rofi, tint2, dunst, terminator) unless the user is on Linux. These are usually fine — they're configs that were added to the repo from another machine.
3. **Content differences** — files present in both but with different content. Run `diff` on each to show what changed.

### Step 4: Analyze content diffs

For each file with content differences, run a standard diff and characterize the change:

```bash
diff _local-backup/<timestamp>/<file> dotfiles/<file>
```

Classify each diff as one of:
- **Local was newer** — backup has additions/changes not in the repo (user likely wants to bring these in)
- **Repo was newer** — repo has additions/changes not in the backup (usually fine, repo is authoritative)
- **Platform divergence** — differences due to OS-specific settings (e.g., `pbcopy` vs `clip.exe`, macOS vs Linux paths). Flag these for the user to decide.
- **Formatting only** — whitespace, JSON spacing, schema version bumps with no semantic change. Note but deprioritize.

### Step 5: Present findings

Show the user a summary table like:

```
| File | Status | Recommendation |
|------|--------|----------------|
| .tmux.conf | Local had macOS config, repo had WSL | Restore from backup |
| .config/fish/config.fish | Backup had 2 extra aliases | Restore from backup |
| .config/fish/CLAUDE.md | Only in backup | Copy to repo |
| .config/linearmouse/... | Repo is newer | Keep repo version |
```

For each file, clearly state what was in the backup vs what's in the repo and give a recommendation.

### Step 6: Apply restorations

After the user confirms which changes to bring in, copy from the backup to `dotfiles/`:

```bash
command cp <backup_path> <dotfiles_path>
```

Use `command cp` to bypass any shell aliases that add `-i` (interactive) prompts.

**Do not touch files where the repo version is newer or more complete unless the user explicitly asks.**

### Step 7: Verify

Run `git diff --stat` to confirm only the expected files changed in the repo, and show a brief summary of what was restored.

## Important Notes

- Always use `command cp` (not bare `cp`) when copying files — many dotfile setups alias `cp` to `cp -i` which blocks on confirmation in non-interactive contexts.
- The backup reflects what was on `$HOME` *before* `overwrite-local` ran. The repo reflects what was *written onto* `$HOME`. So differences mean the overwrite replaced something.
- When in doubt about whether to restore a file, ask the user. The backup is ephemeral — once `overwrite-local` runs again, the previous backup directory is not overwritten but the user may not think to check it.
- Never restore files that are in `.gitignore` or that look like secrets/credentials.
- If `filter.txt` has a file commented out (prefixed with `#`), that file is intentionally untracked — don't suggest adding it.
