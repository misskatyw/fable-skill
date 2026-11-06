# 30 — 派工模板 (Delegation Templates)
Copy the block, fill every ⟨⟩. A dispatch missing any of 目標/驗收/回報 is invalid —
go back and fill it. Default agent per type is noted; override model per 10-dispatch §3.
Subagents have no access to these rule files: paste any rule you cite. Report files go
in `claude/tmp/` (gitignored by install.sh; in skill mode use any scratch dir).

## T1 搜尋/掃描 Search & scan — agent: scout (haiku)
```
GOAL+WHY: Find ⟨what: definition/usages/config/pattern⟩ in ⟨scope: dir or repo⟩.
I need this to ⟨downstream purpose — lets you judge relevance⟩.
DO: size up first (wc -l/ls); grep -n before reading; never open lockfiles/node_modules.
ACCEPTANCE:
- Every occurrence of ⟨target⟩ in ⟨scope⟩ listed, or explicit "NOT FOUND".
- Each finding has file:line.
- ⟨optional: classify findings into ⟨categories⟩⟩.
REPORT: bullets + file:line only; no file contents; long inventory → claude/tmp/scout-⟨topic⟩.md,
return path. If the question needs reasoning not lookup, reply "needs sonnet" and stop.
```

## T2 實作 Implement — agent: worker (sonnet)
```
GOAL+WHY: Implement ⟨feature/fix⟩ in ⟨files/module⟩. Context: ⟨1-3 lines: why, and the
already-known constraints/decisions — do not make the agent rediscover them⟩.
SCOPE: may modify ONLY ⟨file list⟩. Other files needed → report back, don't touch.
ACCEPTANCE:
- ⟨observable behavior 1, e.g. "GET /x returns 200 with field y"⟩
- ⟨command⟩ exits 0  ⟨e.g. npm test / pytest -q⟩
- git status (ignoring *.bak-* and claude/tmp/) shows only ⟨file list⟩ changed;
  .bak created for pre-existing files.
REPORT: per report contract (10-dispatch §5) + the exact verify command you ran and its
exit code. Two failed attempts → stop and return the failure trail.
```

## T3 重構 Refactor — agent: worker (sonnet; 6+ files → split or escalate)
```
GOAL+WHY: Refactor ⟨what⟩ from ⟨current pattern⟩ to ⟨target pattern⟩ because ⟨why⟩.
INVARIANT (most important line): externally visible behavior MUST NOT change.
Evidence required: ⟨test suite⟩ passes BEFORE your changes (run it first; if it's already
red, STOP and report — never refactor on a red baseline).
SCOPE: ⟨file list⟩. Batch mechanical follow-ups: after the pattern is proven on
⟨one instance⟩, STOP and return the solved diff; the main session dispatches haiku for
the remaining instances.
ACCEPTANCE:
- Same test suite green after; zero test files modified ⟨unless listed⟩.
- No public API/signature changes ⟨or list allowed ones⟩.
- git diff --stat within ⟨file list⟩ only.
REPORT: contract §5 + before/after test run exit codes.
```

## T4 研究 Research — agent: scout (sonnet if synthesis needed, haiku if lookup)
```
GOAL+WHY: Answer ⟨question⟩ to inform ⟨decision⟩. Depth: ⟨quick lookup ≤2 searches /
standard ≤5 / deep ≤10 — state which⟩.
RULES: prefer original sources (official docs, papers, primary announcements); every
claim gets URL + publication date; conflicting sources → report the conflict, don't pick
silently; nothing found → "NOT FOUND", never fill gaps from memory.
ACCEPTANCE:
- The ⟨N⟩ sub-questions each answered or marked NOT FOUND: ⟨list them⟩.
- Every factual claim has source + date.
- One clearly-marked ⟨recommendation / options table⟩ at most 10 lines.
REPORT: findings → claude/tmp/research-⟨topic⟩.md; reply = 5-bullet summary + the path.
```

## T5 審查 Review — agent: verifier (sonnet, FRESH context — never the author)
```
You did NOT write this and must not trust its author's claims.
INPUT: ⟨paths⟩. ORIGINAL ACCEPTANCE CRITERIA: ⟨paste them verbatim⟩.
METHOD: docs → read back the actual file; code → RUN it (tests or the code itself;
write a throwaway smoke test in claude/tmp/ if none exists and say so). Also apply this
quality floor ⟨main session: paste the Q1–Q4 lines from 20-judgment.md §5 verbatim⟩.
ACCEPTANCE of your own review: one PASS/FAIL line per criterion, each with evidence
(file:line or command+exit code). No repairs — verdict only.
REPORT: the per-criterion table + overall PASS/FAIL. "Mostly fine" = FAIL.
```

## High-risk add-on 高風險加掛 (append to any template when 20-judgment §1 E4 applies)
```
SECOND OPINION: this output feeds an irreversible/high-stakes step. After the verifier,
a second fresh agent independently answers: "⟨the core question⟩". If its answer
materially disagrees, DO NOT proceed — present both views to the user.
```
