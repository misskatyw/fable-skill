# 10 — 模型調度守則 (Dispatch Rules)
Audience: the MAIN model of any future session (usually sonnet). Follow literally.

## 1. Commander stays clean 指揮官不下場
The main conversation is for: understanding the user, planning, dispatching, integrating
conclusions, and talking to the user. It is NOT for bulk work.

MUST dispatch a subagent (never do in main context):
- Reading any file >50 lines, or reading 3+ files
- Scanning/searching a repo (grep across dirs, "find where X is defined")
- Web research needing >1 search
- Batch edits across 3+ files
- Running noisy commands (test suites, installs, builds) when only the verdict matters

MAY do in main context: targeted edits to at most 2 files, one `grep -n` with `| head`,
file slices of ≤50 lines, one quick web lookup, talking to the user.

## 2. Delegation trio 派工三件套 (every dispatch prompt MUST contain all three)
1. **Goal + why 目標與動機** — what to produce AND what it will be used for (the "why"
   lets the subagent make sane micro-decisions).
2. **Acceptance criteria 驗收條件** — objectively checkable. Bad: "good quality".
   Good: "all 3 call sites updated; `npm test` exits 0; no other files touched".
3. **Report format 回報格式** — exactly what to return (see §5 report contract).
Fill-in templates: `30-templates.md`. Do not freestyle a dispatch prompt.
Subagents cannot read these rule files by name — paste any rule you cite into the prompt.

## 3. Model + effort selection 模型與 effort
The subagent tool is named **`Agent`** (called `Task` in Claude Code before v2.1.63).
Use ALIASES (`haiku`, `sonnet`, `opus`) in the subagent `model:` frontmatter or the
Agent tool's `model` parameter — aliases auto-resolve to current versions. Check
`ENVIRONMENT.md` for which aliases this account actually has. If it says
`opus: unavailable` (or has no ENVIRONMENT.md), the ladder tops out at sonnet — §6 fallback.
`fable` / `best`: never dispatch unless the user explicitly asks; on Pro they bill to usage
credits [src: code.claude.com/docs/en/model-config, 2026-11] [verify after 2027-02].

| Task type | Model | Effort/thinking |
|---|---|---|
| Mechanical: rename, boilerplate, format, read-and-list, simple grep-scan | `haiku` | default |
| Standard work: implement feature, fix known bug, refactor ≤5 files, research, review | `sonnet` | default |
| Hard reasoning: architecture, cross-cutting refactor, bug that survived 2 sonnet tries | `opus` if available, else §6 fallback | high |
| Planning phase of a big task | ask the user to run `/model opusplan` if opus available, else sonnet with an explicit plan→user-approval step before executing | high for plan |

Effort: set per subagent with the frontmatter field `effort: low|medium|high|xhigh|max`
(available levels depend on the model); the user sets session effort with `/effort`.
Current 5.5-generation models default to `medium` [src: code.claude.com/docs/en/model-config,
2026-11] [verify after 2027-02]. "default" in the table = omit the field. Never guess
syntax; if unsure, omit effort.

## 4. Budget guardrails (Pro) 額度護欄
- Max 2 subagents running at once. Parallel swarms are a Max-plan luxury.
- A subagent that will read >20 files gets haiku, or sonnet with `effort: low`, never opus.
- Before any dispatch estimated to be heavy (whole-repo scan, 10+ web fetches): tell the
  user the estimated cost in one line and proceed unless they object.

## 5. Report contract 回報合約 (paste into every dispatch prompt)
> Return ONLY: (a) conclusions as bullet points, (b) `file:line` references for every
> claim, (c) paths of any files you wrote. Do NOT paste file contents, diffs >10 lines,
> or command output into your reply. Long output → write to a file, return the path.
> If you could not meet an acceptance criterion, say which one and why — do not
> approximate silently.

## 6. Escalation / de-escalation 升降級路徑
- **haiku fails once** on its task → resend to `sonnet` immediately. No second haiku try.
- **sonnet fails the SAME subtask twice** → escalate to `opus` (if available) WITH the
  full failure trail: both attempts, exact errors, what was ruled out. Never make opus
  rediscover what sonnet already learned.
- **Opus unavailable** (ENVIRONMENT.md says so, or it bills to usage credits) → fallback
  ladder, in order:
  1. Fresh-context sonnet subagent with a distilled brief (often beats a polluted
     context; write the brief using the 30-templates format).
  2. Multi-sample review: 2 independent sonnet attempts + 1 fresh sonnet judge picks/merges
     (use for judgment-heavy outputs, not mechanical ones).
  3. Stop and tell the user: "this needs a stronger model / your decision" — with the
     failure trail attached. This is a valid outcome, not a failure.
- **De-escalate 降級**: once sonnet/opus has SOLVED the pattern (e.g. the correct fix for
  one instance), the MAIN session dispatches `haiku` to batch-apply the remaining
  instances, giving it the solved example verbatim as the template. Subagents never
  dispatch other subagents.
- **Retry cap**: the same subtask gets at most 2 failed attempts at any single level,
  counted across ALL approaches (a "different fix" does not reset the count). Total across
  all levels: if 3 different approaches have failed, go to 20-judgment.md §4 (you are
  probably solving the wrong problem).

## 7. Verification: never self-verify 驗證不自驗
The agent that produced work never signs it off. Dispatch the `verifier` agent
(fresh context, defined in `.claude/agents/verifier.md`; in skill mode see SKILL.md):
- **Files/docs** → verifier reads the file back and checks each acceptance criterion,
  quoting `file:line` evidence per criterion.
- **Code** → verifier runs the tests or actually executes the code; "it looks right" is
  not a pass. If no tests exist, verifier writes a throwaway smoke test in `claude/tmp/`.
- **High-risk judgment** (irreversible actions, user-facing docs, money/legal) → add a
  second opinion: a separate fresh agent answers the same question independently;
  disagreement = stop and present both views to the user.
Verifier verdicts are binary per criterion: PASS / FAIL(+evidence). "Mostly fine" = FAIL.
