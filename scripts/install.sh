#!/usr/bin/env bash
# Install fable-skill rules into a project.  Usage: bash install.sh <project_dir>
# Safe by design: backs up before overwriting (never clobbers an existing backup);
# never overwrites CLAUDE.md, ENVIRONMENT.md or LESSONS.md if they already exist.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-}"
if [ -z "$TARGET" ] || [ ! -d "$TARGET" ]; then
  echo "Usage: bash install.sh <existing_project_dir>" >&2; exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"
STAMP="$(date +%Y%m%d)"
REPLACED=0

# Refuse to drop markdown into an unrelated claude/ directory (e.g. a code package).
if [ -d "$TARGET/claude" ] && [ -n "$(ls -A "$TARGET/claude")" ] \
   && ! ls "$TARGET/claude"/[0-9][0-9]-*.md >/dev/null 2>&1; then
  echo "claude/ already exists and is not a fable-skill install; aborting." >&2; exit 1
fi

backup_then_copy () {  # $1=src $2=dest
  if [ -f "$2" ] && ! cmp -s "$1" "$2"; then
    local b="$2.bak-$STAMP"
    [ -e "$b" ] && b="$2.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$2" "$b"; echo "  backed up  $2 -> $b"; REPLACED=$((REPLACED+1))
  fi
  cp "$1" "$2"; echo "  installed  $2"
}

mkdir -p "$TARGET/claude/tmp" "$TARGET/.claude/agents"

echo "[1/5] rule files -> claude/"
for f in "$SKILL_DIR"/references/*.md; do
  backup_then_copy "$f" "$TARGET/claude/$(basename "$f")"
done

echo "[2/5] state files (kept if present)"
for f in ENVIRONMENT.md LESSONS.md; do
  if [ -f "$TARGET/claude/$f" ]; then echo "  kept       claude/$f (local state)"
  else cp "$SKILL_DIR/assets/$f" "$TARGET/claude/$f"; echo "  installed  claude/$f"; fi
done

echo "[3/5] subagents -> .claude/agents/"
for f in "$SKILL_DIR"/assets/agents/*.md; do
  backup_then_copy "$f" "$TARGET/.claude/agents/$(basename "$f")"
done

echo "[4/5] CLAUDE.md"
if [ -f "$TARGET/CLAUDE.md" ]; then
  backup_then_copy "$SKILL_DIR/assets/CLAUDE.md" "$TARGET/CLAUDE.fable.md"
  echo "  existing CLAUDE.md kept. Fable version written to CLAUDE.fable.md"
  echo "  -> ask Claude: 'Merge CLAUDE.fable.md into CLAUDE.md per claude/40-maintenance.md (<=60 lines)'"
else
  cp "$SKILL_DIR/assets/CLAUDE.md" "$TARGET/CLAUDE.md"; echo "  installed  CLAUDE.md"
fi

echo "[5/5] .gitignore (backups + scratch)"
touch "$TARGET/.gitignore"
for pat in '*.bak-*' 'claude/tmp/'; do
  grep -qxF "$pat" "$TARGET/.gitignore" || { echo "$pat" >> "$TARGET/.gitignore"; echo "  added      $pat"; }
done

echo
if [ "$REPLACED" -gt 0 ]; then
  echo "WARNING: $REPLACED local file(s) differed and were replaced (see *.bak-*)."
  echo "  -> ask Claude: 'Re-apply my local changes from the .bak files per claude/40-maintenance.md'"
fi
echo "Done. Start (or restart) Claude Code here and say: Run claude/90-bootstrap.md top to bottom."
