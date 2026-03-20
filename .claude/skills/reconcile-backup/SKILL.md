---
name: reconcile-backup
description: Reconciles the latest local backup (created by overwrite-local) against the repo's dotfiles. Use this skill when the user runs /reconcile-backup or asks to compare, reconcile, diff, or restore from a local backup. Also triggers for "check backup", "what changed when I overwrote", "bring back local changes", or "did I lose anything".
---

# Reconcile Backup

After running `./overwrite-local`, a timestamped backup of the previous `$HOME` state is saved to `_local-backup/`. This skill compares that backup against the current repo dotfiles to surface meaningful differences — primarily local customizations that the overwrite replaced — and helps the user selectively restore them.

## Context

- **Repo dotfiles:** `dotfiles/` — the source of truth checked into git
- **Local backups:** `_local-backup/<timestamp>/` — snapshots of `$HOME` taken by `overwrite-local` before it overwrites
- **Filter rules:** `filter.txt` — rsync filter controlling which files are tracked; only files matching these rules are relevant
- **Linux-only configs:** dirs like `xfce4`, `i3`, `openbox`, `polybar`, `rofi`, `tint2`, `dunst`, `terminator` are commented out in `filter.txt` — they exist in the repo from legacy Linux usage but should be excluded from comparisons on macOS

## Procedure

### Step 1: Identify the backup and diff in one pass

Find the latest timestamped backup and run the diff. Do this in a **single bash call**:

```bash
BACKUP=$(ls -1t _local-backup/ | grep -E '^[0-9]{4}-' | head -1) && diff -rq "_local-backup/$BACKUP/" dotfiles/
```

If the user asked about a **specific config** (e.g. "check the fish config"), scope the diff to that subtree only — don't diff everything:

```bash
BACKUP=$(ls -1t _local-backup/ | grep -E '^[0-9]{4}-' | head -1) && diff -rq "_local-backup/$BACKUP/.config/fish/" dotfiles/.config/fish/
```

If multiple timestamped backups exist, default to the latest. Only ask the user if context suggests they want an older one.

### Step 2: Analyze differences

For each file that differs, run a content diff. If there are multiple files, diff them all in a **single bash call** using `for` or `;`:

```bash
diff _local-backup/<timestamp>/<file1> dotfiles/<file1>; echo '---'; diff _local-backup/<timestamp>/<file2> dotfiles/<file2>
```

The repo is the source of truth. Only report changes where the **backup had something the repo doesn't** — local customizations that were overwritten. Classify each as:
- **Local addition lost** — backup has lines/files not in the repo (user likely wants to bring these in)
- **Platform divergence** — differences due to OS-specific settings (e.g., `pbcopy` vs `clip.exe`, macOS vs Linux paths). Flag for the user to decide.
- **Formatting only** — whitespace, JSON spacing, schema version bumps with no semantic change. Note but deprioritize.

Silently skip:
- **Repo-only files/content** — the repo added these intentionally; the overwrite applied them. Not actionable.
- Linux-only configs (xfce4, i3, openbox, polybar, rofi, tint2, dunst, terminator) unless the user is on Linux.

### Step 3: Present findings

Show the user a summary table of only the actionable differences — things the backup had that the repo doesn't:

```
| File | What was lost | Recommendation |
|------|---------------|----------------|
| .tmux.conf | Local had macOS-specific bindings | Restore from backup |
| .config/fish/config.fish | Backup had rbenv init block | Ask user if needed |
| .config/fish/CLAUDE.md | Only in backup, not tracked in repo | Copy to repo |
```

Only list files where the user lost something. Don't include files where the repo was simply newer — those are working as intended.

### Step 4: Apply restorations

After the user confirms which changes to bring in, copy from the backup to `dotfiles/`:

```bash
command cp <backup_path> <dotfiles_path>
```

Use `command cp` to bypass any shell aliases that add `-i` (interactive) prompts.

**Do not touch files where the repo version is newer or more complete unless the user explicitly asks.**

### Step 5: Verify

Run `git diff --stat` to confirm only the expected files changed in the repo, and show a brief summary of what was restored.

## Important Notes

- Always use `command cp` (not bare `cp`) when copying files — many dotfile setups alias `cp` to `cp -i` which blocks on confirmation in non-interactive contexts.
- The backup reflects what was on `$HOME` *before* `overwrite-local` ran. The repo reflects what was *written onto* `$HOME`. So differences mean the overwrite replaced something.
- When in doubt about whether to restore a file, ask the user. The backup is ephemeral — once `overwrite-local` runs again, the previous backup directory is not overwritten but the user may not think to check it.
- Never restore files that are in `.gitignore` or that look like secrets/credentials.
- If `filter.txt` has a file commented out (prefixed with `#`), that file is intentionally untracked — don't suggest adding it.
