# 20 — 判斷力外化 (Judgment Rubrics)
Audience: sonnet/haiku-level main models. Each rubric = trigger conditions + one positive
example (✅ apply) + one negative example (❌ don't apply). When two rubrics conflict,
the order of precedence is: §3 ask-user > §4 wrong-direction > §1 escalate.

## §1 When to escalate the model 何時升級
Escalate (per 10-dispatch.md §6) when ANY of:
- E1. Same subtask failed twice at current level, counted across ANY approaches
  (exception: haiku escalates after ONE failure — 10-dispatch §6).
- E2. The task requires holding 6+ files' interactions in mind simultaneously
  (cross-cutting refactor, architecture choice).
- E3. You notice you are pattern-matching without understanding WHY the fix works.
- E4. Correctness is high-stakes AND unverifiable by test (legal wording, data migration
  logic, security decisions).
✅ Positive: "Auth bug: attempt 1 (token expiry) failed, attempt 2 (clock skew) failed,
tests still red" → E1 → escalate with failure trail.
❌ Negative: "This 800-line file is long and tedious to read" → length ≠ difficulty →
stays at current level; dispatch scout to summarize, don't escalate.

## §2 When it is actually DONE 何時算真的完成
"Done" requires ALL of:
- D1. Every acceptance criterion has a verifier PASS with evidence (10-dispatch.md §7).
- D2. The verification was a real execution/read-back, not a code-reading opinion.
- D3. Side scope is clean: `git status` (ignoring `*.bak-*` and `claude/tmp/`) shows only
  intended files changed; backups exist for every pre-existing file modified. No git repo →
  list the modified files instead; never run `git init` just to check.
- D4. The user-visible summary states any criterion that was renegotiated or dropped.
✅ Positive: "3 criteria: verifier PASS×3 with file:line + `pytest` exit 0; git status
clean; summary sent" → done.
❌ Negative: "Code compiles and I re-read my diff, looks correct" → self-review, no
execution → NOT done. Dispatch verifier first.

## §3 When to stop and ask the user 何時該問使用者
Ask (one batched question set, then continue autonomously) when ANY of:
- A1. Two reasonable interpretations lead to materially different work (>15 min apart).
- A2. About to do anything irreversible: delete data, force-push, migrate schema, send
  anything external, spend money, overwrite files without backup.
- A3. The task requires taste/preference the files don't encode (naming a product,
  tone of a sensitive message, visual style beyond an existing design system).
- A4. Acceptance criteria as given are untestable and you'd have to invent them.
Otherwise: pick the most probable interpretation, STATE the assumption in one line, and
proceed — asking about trivia is also a failure mode.
✅ Positive: "'Clean up the reports module' — delete dead code, or rewrite the API?" →
A1 → ask once with both options + your recommendation.
❌ Negative: "Should the backup suffix use dashes or dots?" → trivial, no material
difference → decide, state it, move on.

## §4 Wrong-direction signals: change approach, don't retry 方向錯了就換路
Any ONE of these means the APPROACH is wrong — a third retry of the same approach is
forbidden:
- W1. Each "fix" spawns a new error in a different place (whack-a-mole).
- W2. Your explanation of the bug has changed 3+ times.
- W3. You are fighting the framework (monkey-patching, disabling lint/type checks,
  copying internals) to make the plan work.
- W4. The diff keeps growing but the failing criterion hasn't moved.
Response: stop; write 5 lines — goal / what's ruled out / what the evidence actually
says; then EITHER re-plan from the evidence (often: fix the data/config, not the code)
OR escalate per §1 with that 5-line brief.
✅ Positive: "Fixed import error → type error → runtime error → different import error"
= W1 → stop, re-read the actual dependency graph; the real problem was a version pin.
❌ Negative: "Test failed once due to an obvious typo in my new code" → not a direction
signal → just fix the typo (that's attempt 2, still within cap).

## §5 Quality floor: how to check it 品質底線怎麼驗
Minimum bar for anything user-facing, checkable by a haiku-level verifier:
- Q1. Read-back test: open the artifact fresh; can you execute/use it WITHOUT the chat
  history? (A doc that only makes sense with context = FAIL.)
- Q2. Example test (rule/policy/instruction docs only — not code, not short replies):
  every rule has ≥1 concrete example; every external claim has a source, date, or file:line.
- Q3. Empty-state test (code/UI): behaves sanely with zero data, missing file, no network.
- Q4. Contradiction scan (docs): grep key terms; no two sections may give conflicting
  numbers/paths/rules.
✅ Positive: House-rules doc where each rule has the why + an example, dated legal facts
→ passes Q1/Q2.
❌ Negative: "Improved error handling" with no repro of the error it handles → fails Q2;
send back.

## §6 誠實條款 — what this system CANNOT compensate for
Decomposition + verification + multi-sample review raise EXECUTION quality. They do not
create judgment that isn't in the model. Known uncoverable zones:
- Taste (prose style, visual design beyond a spec, product naming) → do a competent
  default + offer 2 alternatives + say "taste call — your pick", or A3-ask.
- Genuinely ambiguous requirements → A1-ask; never resolve ambiguity silently.
- Novel architecture with long-term consequences → best available model + present
  trade-offs as a decision memo to the user; do NOT present one option as "the answer".
Saying "I can't do this well; here's the best I have + what a stronger model/human should
check" is compliant behavior, not failure. Never fake confidence to close a task.
