# 40 — 維護協議 (Maintenance Protocol)
How future (weaker) models update this system without degrading it. Read fully before
editing ANY file under claude/ or CLAUDE.md.

## Permission tiers 權限分級
| Tier | Files / content | Who may change |
|---|---|---|
| FREE 自由改 | `LESSONS.md` (append only), `ENVIRONMENT.md` (update verified facts), fixing typos/dead paths in any file except FROZEN ones | Any model, no approval |
| ASK-FIRST 先問使用者 | CLAUDE.md hard rules & routing table; 10-dispatch ladder/caps; 20-judgment rubrics; deleting anything; any skill's trigger description | Propose diff → user approves → apply |
| FROZEN 不改 | `00-diagnosis.md`, `50-letter.md` (historical record) | Nobody edits; corrections go to LESSONS.md |

## Universal edit procedure 通用改檔程序
1. `[ -e F.bak-$(date +%Y%m%d) ] || cp F F.bak-$(date +%Y%m%d)` (hard rule #2; never
   overwrite an existing backup — the first backup of the day is the pristine one).
2. Make the edit. Additions to volatile facts MUST carry the fact format below.
3. Contradiction scan: grep the changed terms across CLAUDE.md + claude/*.md; if the new
   rule conflicts with an existing one, resolve explicitly (delete/amend the loser) —
   never leave two live rules that disagree.
4. Read-back: fresh eyes (verifier agent) reads the edited section; can it be executed
   without this session's chat history? No → rewrite.

## Volatile fact format 易變事實格式 (mandatory for numbers, versions, limits, prices)
`<fact> [src: <where>, <YYYY-MM>] [verify after <YYYY-MM>: <how to re-check>]`
Example: `<fact> [src: support.claude.com, YYYY-MM] [verify after YYYY-MM: ask the user
to run /model, update ENVIRONMENT.md]`
A model that encounters an EXPIRED fact must re-verify before relying on it, then update
the line and its dates.

## Lessons log 教訓寫回 (`LESSONS.md`)
After any mistake costing >10 min, append ≤4 lines:
```
## <YYYY-MM-DD, today> · <trigger situation>
RULE: <imperative, checkable — what to do differently>
EXAMPLE: <the concrete case, 1 line>
```
Rules that would change ASK-FIRST files stay in LESSONS.md until the user promotes them.

## Compaction 精簡節律 (prevents rule-pile rot)
- `LESSONS.md` > 80 lines OR CLAUDE.md > 60 lines → propose a consolidation to the user:
  merge duplicates, promote proven lessons into the proper file, delete ones that never
  fired again. Show the diff; user approves.
- Every consolidation: check `.bak-*` clutter; keep the newest 2 backups per file,
  propose deleting older ones.
- Quarterly (or when ENVIRONMENT.md is stale): rerun `90-bootstrap.md` checks.

## Skill edits 技能檔
Skills live either in claude.ai settings or in Claude Code (`~/.claude/skills/`,
`.claude/skills/`). Treat the copy under version control as canonical. Never edit files
inside an installed skill folder (e.g. `~/.claude/skills/fable-skill/`) — a `git pull`
overwrites them; change the project's `claude/` copies instead, or the source repo. Any change to a skill's `description:` (triggers)
is ASK-FIRST: over-broad triggers are leak #1 in 00-diagnosis.md; every new trigger
phrase needs a matching negative trigger ("Do NOT trigger when ...").
