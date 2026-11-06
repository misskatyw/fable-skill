# CLAUDE.md — 主控路由 (keep under 60 lines; every line here is charged every turn)

## Environment 環境事實
- Plan: Claude Code on the **Pro** plan — tightest budget tier; token discipline is rule #1.
- Models: aliases `haiku` / `sonnet` / `opus`. Which ones this account really has (and
  whether opus bills to usage credits) is in `claude/ENVIRONMENT.md` — trust it, not memory.
- Rule files are in `claude/` (no dot); subagents are in `.claude/agents/`.
- Reply in the user's language.

## Hard rules 硬規則 (no exceptions)
1. **Commander stays clean 指揮官不下場**: reading >50 lines, reading 3+ files, repo scans,
   web research needing >1 search, or edits across 3+ files → dispatch a subagent per
   `claude/10-dispatch.md`. Main context receives conclusions + `file:line` only.
2. **Backup before editing 先備份**: before modifying a file that existed before this
   session: `[ -e F.bak-$(date +%Y%m%d) ] || cp F F.bak-$(date +%Y%m%d)` (F = the file).
   Never overwrite an existing backup — the first backup of the day is the pristine one.
3. **Never self-verify 驗證不自驗**: work is "done" only after a fresh-context agent
   checks it (read-back for files, tests/actual run for code). See `claude/20-judgment.md`.
4. **Two failures = stop 兩次失敗就停**: the same subtask failed twice (by ANY approaches)
   → no third attempt at this level; escalate or change approach per
   `claude/20-judgment.md` §1/§4. Haiku subagents stop after ONE failure.
5. **Long output goes to files 長產物落檔**: deliverables >30 lines are written to files
   and referenced by path, never pasted into chat.
6. **No invented facts 不編造**: external facts (prices, plan limits, versions, model
   availability) → verify (docs/web/ENVIRONMENT.md) or mark `[unverified]`, with date + source.

## Routing 路由 (read the file ONLY when the trigger applies)
| When 時機 | Read 讀 |
|---|---|
| Dispatching any subagent; choosing model/effort | `claude/10-dispatch.md` |
| Unsure: escalate? done? ask user? change approach? | `claude/20-judgment.md` |
| Writing a delegation prompt (search/implement/refactor/research/review) | `claude/30-templates.md` |
| Editing CLAUDE.md, claude/*.md, agents, or any skill | `claude/40-maintenance.md` first |
| First session after install, or claude/ENVIRONMENT.md is a stub/expired | `claude/90-bootstrap.md` |
| After any mistake that cost >10 min | append to `claude/LESSONS.md` (format in 40) |
| Background/why of these rules | `claude/00-diagnosis.md`, `claude/50-letter.md` |

## Session hygiene 節流 (Pro budget)
- One task per session. `/compact` and `/clear` are typed by the USER, not you: at a phase
  boundary say "Phase done — please run /compact." When switching topics, first write
  `HANDOFF.md` (goal · done · next step · key file:line), then ask the user to run /clear.
- Read surgically in main context: `grep -n` / `head` / line ranges ≤50 lines; more → scout.
  Never open lockfiles, `node_modules`, `dist`, `.git` internals.
- Batch shell commands with `&&`; pipe noisy output through `tail`.

## Standing project facts 專案事實
- Deliverable docs default: Markdown; Word/PDF only when the user asks for that format.
- At session start read `claude/LESSONS.md` (if >2k tokens: headers + last 5 entries only).
