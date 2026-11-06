# 90 — 首次啟用檢查 (Bootstrap — run in the FIRST Claude Code session after install)
Run top to bottom; each step writes results down so no later session repeats it.

## 1. Adversarial review 對抗審查 (MANDATORY — checks THIS install against THIS environment)
Dispatch a FRESH subagent (sonnet, no prior context) with exactly:
> Read CLAUDE.md and every file in claude/ and .claude/agents/. You are a hostile
> reviewer. Find: (a) rules that contradict each other, (b) file paths, tool names, or
> command syntax that don't exist in THIS environment, (c) sentences a haiku-level model
> could misread — for each, quote the line and say what the misreading would be.
> Report as a numbered list with file:line. Find at least 5 issues or state explicitly
> that fewer exist after honest effort.
For each finding, look up its file's tier in 40-maintenance.md "Permission tiers":
FREE → fix it now with the universal edit procedure. ASK-FIRST → show the user a proposed
diff and apply only after approval. FROZEN (00, 50) → append a correction to LESSONS.md;
never edit the file. Log the review date in ENVIRONMENT.md.

## 2. Record the real environment 記錄真實環境 → fill ENVIRONMENT.md
- `claude --version` → record.
- Slash commands are typed by the USER — you cannot run them. Ask: "Please run /model
  and paste the list you see." Record exactly what they paste. If opus is absent, or its
  row carries ANY billing note ("Extra Usage", "usage credits", a price): set
  `opus: unavailable`. Never fill models from memory; no reply → leave `[unverified]`.
- Confirm agents load by dispatching scout on a trivial task ("list files in claude/,
  report paths only"). If the agent is "not found", ask the user to restart Claude Code
  (a new agents folder is only picked up on restart), then retry once.
- Effort is set via the `effort:` frontmatter field (10-dispatch §3); scout ships with
  `effort: low`. If that dispatch errors on the field, remove it and record that here.
- Settings→Usage (user does this): note current session/weekly headroom style.

## 3. Wire-up checks 接線檢查
- CLAUDE.md is at the repo root (or `~/.claude/CLAUDE.md` for user-global) and ≤60 lines.
- Paths in CLAUDE.md's routing table resolve: `ls claude/*.md`.
- `LESSONS.md` exists (seed file ships with install).

## 4. First-week calibration 第一週校準
After ~5 real tasks, append to LESSONS.md: which dispatch rules fired, which were skipped
and why. If a rule was skipped 3+ times for the same reason, it is wrong for this
environment — propose the amendment to the user (ASK-FIRST tier).
