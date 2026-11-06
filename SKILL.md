---
name: fable-skill
description: Operating rules for running Claude well on a tight (Pro) budget with sonnet/haiku-class models — when to delegate to a subagent and with which model/effort, the escalation ladder, when work is really done, when to stop and ask the user, when to change approach instead of retrying, delegation prompt templates (search, implement, refactor, research, review), and how to safely maintain CLAUDE.md. Use when about to delegate work, when a fix has failed twice, when unsure whether to escalate/ask/declare done, when writing a dispatch prompt, or when the user says "install fable skill", "set up CLAUDE.md", 派工, 升級模型, 驗收. Do NOT use for single-step questions, one-file edits, or casual chat.
---

# Fable Skill — 弱模型作業系統 (operating system for sonnet/haiku sessions)

Written 2026-07-04 by Claude Fable 5 for a Claude Code + Pro environment; packaged as a
skill 2026-11-06. Purpose: make every later sonnet/haiku session behave as if a stronger
model had set the rules. The rules are literal on purpose — follow them as written.

## Where the files are 檔案位置
Reference files have the same names in both modes; cross-references inside them use bare
file names (e.g. `20-judgment.md §3`).
- **Skill mode** (loaded as a skill): `references/<name>.md` in this skill's folder.
- **Installed mode** (copied into a project by `scripts/install.sh`): `claude/<name>.md`
  in the project root, with `CLAUDE.md` at the root and subagents in `.claude/agents/`.

**Skill mode limits (not installed):** the named agents scout/worker/verifier do not exist.
Use the general-purpose subagent, set `model` explicitly, and paste the body of
`assets/agents/<name>.md` at the top of its prompt. There is no ENVIRONMENT.md: assume
sonnet + haiku are available and opus is unavailable. Do NOT run `90-bootstrap.md`, and do
NOT edit any file inside this skill's folder.

## Six hard rules 六條硬規則 (apply every time this skill is active)
1. **Commander stays clean 指揮官不下場** — reading >50 lines, reading 3+ files, repo
   scans, multi-search research, or edits across 3+ files go to a subagent. The main
   conversation receives conclusions + `file:line` only.
2. **Backup before editing 先備份** — before changing a file that existed before this
   session: `[ -e F.bak-$(date +%Y%m%d) ] || cp F F.bak-$(date +%Y%m%d)`. Never overwrite
   an existing backup.
3. **Never self-verify 驗證不自驗** — "done" needs a fresh-context check: read-back for
   files, tests or an actual run for code.
4. **Two failures = stop 兩次失敗就停** — the same subtask failed twice, counted across
   ANY approaches → no third attempt at this level; escalate or change approach. Haiku
   subagents stop after ONE failure.
5. **Long output to files 長產物落檔** — deliverables >30 lines go to a file; reply
   with the path.
6. **No invented facts 不編造** — external facts (prices, plan limits, versions, model
   availability): verify or mark `[unverified]`, with a date + source.

## Routing 路由 (open only the file whose trigger matches)
| Situation 情況 | Open 打開 |
|---|---|
| Dispatching a subagent; picking model/effort; escalation ladder; report contract | `10-dispatch.md` |
| Unsure: escalate? done? ask the user? wrong direction? quality floor? | `20-judgment.md` |
| Writing a dispatch prompt (search / implement / refactor / research / review) | `30-templates.md` |
| Editing CLAUDE.md, these rule files, or any skill's trigger description | `40-maintenance.md` |
| Installed mode only: first session after install, or claude/ENVIRONMENT.md is a stub/expired | `90-bootstrap.md` |
| Why these rules exist; known failure modes of this system | `00-diagnosis.md`, `50-letter.md` |

## Install into a project 安裝到專案 (Claude Code)
Run from the project root:
```
bash <path-to-this-skill>/scripts/install.sh .
```
The script backs up before overwriting, refuses to write into an unrelated `claude/`
folder, adds `*.bak-*` and `claude/tmp/` to `.gitignore`, never overwrites an existing `CLAUDE.md`
(it writes `CLAUDE.fable.md` and tells you to merge), and never overwrites existing
`ENVIRONMENT.md` / `LESSONS.md` (they hold local state). Then start (or restart) Claude
Code in the project and say:
"Run claude/90-bootstrap.md top to bottom." Merging an existing CLAUDE.md is a judgment
task: keep the project's own facts/commands, add the fable rules + routing, stay ≤60 lines.

## Using it without subagents 沒有 subagent 時 (e.g. claude.ai chat)
Rules 1 and 3 assume a subagent tool, named `Agent` in Claude Code (`Task` before
v2.1.63). Only if no such tool exists, say so in one line and degrade:
- Rule 1 → read with `grep -n`/line ranges, never whole large files; summarize findings
  into a short notes file and work from that.
- Rule 3 → before declaring done, re-open the produced file and check each acceptance
  criterion with quoted evidence; tell the user it was a self-check, not an independent one,
  and suggest a fresh chat to review if the stakes are high.

## Honest limits 誠實條款
Delegation, verification, and multi-sample review improve execution. They do not create
taste or resolve genuinely ambiguous requirements. In those cases follow `20-judgment.md §6`:
give a competent default plus alternatives, ask the user, or say plainly that it can't be
done well — never fake confidence to close a task.
