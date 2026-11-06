# 50 — 給未來 session 的信 (Letter to Future Sessions)
From Fable 5, 2026-07-04. The user never asked me these three things; they matter most.

## 1. Your real bottleneck is the Pro budget, not intelligence
The single highest-leverage habit in this environment is session discipline, not model
cleverness: one task per session, `/compact` at phase boundaries, HANDOFF.md + `/clear`
between topics, and dispatching all bulk reading to scout. A sonnet that keeps a clean
context will beat an opus drowning in 80k tokens of tool noise. When the user asks for
"a better model", first ask whether the context is the problem.

## 2. This system lives on TWO surfaces that will drift apart
Claude Code loads CLAUDE.md but not the claude.ai skills; claude.ai loads the skills but
not CLAUDE.md. The same person is served by both. Drift symptom: a rule fixed on one
surface keeps failing on the other. Treat this repo as canonical; when a lesson changes
behavior, ask the user whether the matching skill (or CLAUDE.md) needs the same patch.
Priority patch still pending as I write: the usage-estimator skill's hardcoded capacity numbers
(00-diagnosis.md #2) — they will silently rot.

## 3. Some domains have real-world stakes the rest of the work doesn't
Outputs that land in employment relationships, legal obligations, or a child's care are
not ordinary deliverables. For those: never drop legal guardrails a skill encodes, even
when the user's draft conflicts (flag it, gently); never rename stored-data keys in a live
app (it orphans people's history); and tone errors ARE functional errors — a required
tone is an acceptance criterion, not decoration. When in doubt there, 20-judgment §3
(ask) beats initiative.

## How this system will most likely degrade — and the antidotes
- **Rule accretion 規則堆積**: every mishap adds a rule; files bloat past what weak
  models actually follow; then ALL rules are effectively ignored. Antidote: the
  compaction thresholds in 40-maintenance are load-bearing — enforce them. Deleting a
  stale rule is maintenance, not vandalism.
- **Verification theater 驗證做樣子**: verifier dispatches start getting the worker's
  summary instead of raw acceptance criteria, and verdicts become rubber stamps.
  Antidote: verifier must receive criteria VERBATIM from the original dispatch and quote
  file:line/exit-code evidence per criterion. A verdict without evidence is void.
- **Stale facts trusted 過期事實**: model lineups, plan limits, local legal details change;
  a weak model quotes a 2026 number in 2027 with full confidence. Antidote: the volatile
  fact format with expiry dates (40-maintenance) — an expired fact is treated as unknown.
- **Escalation inflation 升級通脹**: "hard" becomes an excuse; everything routes to the
  top model and the budget dies. Antidote: escalation REQUIRES the failure trail
  (10-dispatch §6). No trail, no escalation.

## Unfinished business from my session (handoff)
- Adversarial review by a TRUE fresh-context agent could not be run here (chat interface
  has no subagents) — it is step 1 of 90-bootstrap.md. Do it in the first Claude Code
  session before trusting these files. I did a self read-back + contradiction scan only.
- ENVIRONMENT.md ships as a stub — bootstrap fills it with the real /model output.
- Skill-description patches (negative triggers, usage-estimator number fix) drafted as
  recommendations in 00-diagnosis.md but NOT applied to the live skills; needs the user.
