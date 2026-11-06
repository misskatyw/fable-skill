# 00 — Harness 診斷 (Diagnosis)
Written by Fable 5, 2026-07-04. Evidence: the five custom skills in the original environment (a token-saving skill, a
usage-estimator skill, a plan-first skill, a household-app skill, a PDF-generation skill)
+ user-confirmed setup (Claude Code + Pro plan). Skill names generalized for publication.
Read-only reference. Do not edit; append corrections to LESSONS.md instead.

## #1 token leak — Skill trigger overlap（三個 skill 會同時觸發）
**Problem.** the token-saving skill ("use proactively at the START of any long task"), the
usage-estimator ("Always use when... 'how expensive is this task?'"), and the plan-first skill ("suggest it even if
the user doesn't ask") all fire on one ordinary coding request. Each SKILL.md is 100–300
lines. One request can silently load 500+ lines of instructions before any work starts.
On a Pro budget this is the single largest recurring overhead.
**Fix.**
- Each skill description gets a NEGATIVE trigger line, e.g. usage-estimator: "Do NOT trigger
  unless the user explicitly asks about cost/limits." plan-first: "Do NOT auto-suggest for
  tasks touching fewer than 3 files."
- Rule of one: at most ONE proactive skill suggestion per conversation; after that, only
  load skills the user names.
- The token-saving and usage-estimator skills overlap ~40% (session hygiene advice in
  both). Keep hygiene in the token-saving skill only; the estimator keeps only estimation.

## #2 error source — Stale/uncalibrated numbers baked into skills（過期數字被弱模型當真）
**Problem.** The usage-estimator skill hardcodes "Pro ≈ 45 msgs / ~44,000 tokens per session (May 2026
data)". These are third-party estimates that drift; plan capacities and model lineups have
already changed since. A weak model will quote them as fact indefinitely. Same class of
risk: legal notes embedded in a household-app skill, library assumptions in a PDF skill.
**Fix.**
- Every volatile fact must carry a date + source line, and an expiry action:
  `[verify after 2026-10: check Settings→Usage]`. Format defined in 40-maintenance.md.
- Prefer RELATIVE facts (Max 5x = 5× Pro) over absolute numbers; point to
  Settings→Usage for absolutes.
- Never state plan capacity as a number without the word "estimate" and a date.

## #3 focus killer — No delegation structure: main context does all the reading
**Problem.** There is no CLAUDE.md and no subagents. Every repo scan, file dump, and web
search lands in the main conversation. On Pro this both burns the 5-hour window fastest
AND buries earlier instructions (the "Claude ignores me" failure the token-saving skill describes is
caused by exactly this). Long tool outputs in main context are the top focus-loss cause.
**Fix.** The whole 10-dispatch.md exists for this. One-line version: the main conversation
never reads more than ~50 lines of anything; bulk reading/searching/batch-editing goes to
a subagent that returns conclusions + file:line only.

## Honest limits of these fixes（誠實條款）
Structure fixes execution quality. It does NOT fix: taste, ambiguous requirements, novel
architecture judgment. Those cases are routed by 20-judgment.md → escalate model, ask the
user, or say "cannot do well" explicitly. Never let a checklist pretend to be judgment.
