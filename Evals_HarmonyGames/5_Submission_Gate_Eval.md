# SUBMISSION GATE EVALUATOR — Harmony Games Universe

> **Purpose:** Catch every defect pattern before a Harmony Games task is submitted. **Hard-gate eval** — any single submission-gate defect is a blocker. Zero tolerance. Run this last, after the prompt, injection, and rubric evals have passed.

---

## The 7 Defect Families

| # | Family | What it catches |
|---|---|---|
| F1 | **Impossible-with-Connectors** | Rubrics/asks demanding actions or data the connectors cannot provide (incl. empty-table capabilities) |
| F2 | **Persona & Date Mismatch** | Persona attribution/authority errors, mailbox gaps, date contradictions, phantom references |
| F3 | **Process / Category Violations** | Criteria that credit tool-calling motions instead of measuring outcomes; miscategorized items |
| F4 | **Rubric Defects (Broken / Over-Strict)** | Target data missing in universe, or valid alternative paths penalized |
| F5 | **Illegal Tool-Output Dependencies** | Criteria whose grading requires inspecting tool return values not visible in the transcript |
| F6 | **QC-Pattern Compliance** | Atomicity, missing criteria, overly broad, destination mismatch, blank fields, exclusion gaps, delegation ambiguity, gate/penalty/band integrity, feasibility/date strictness |
| F7 | **Pillar Profile & Difficulty** | Off-profile difficulty; dual-prompt drift; task too easy to hold Pass@5 < 30% |

---

## STEP 0 — Mandatory TODO List (Hard Gate)

```
- [ ] Phase 0: Load & Pre-Read
  - [ ] 0.1: Read prompt.txt — extract persona, scenario, both prompts, all asks, all entity references
  - [ ] 0.2: Read task_metadata.md — role/authority, declared pillar profile, sources/distractors/tripwires
  - [ ] 0.3: Read golden_solution.txt — the intended ground-truth deliverables + values
  - [ ] 0.4: Read rubrics.json — catalog every rubric: ID, category, gate flag, weight, criterion, evidence, expected values
  - [ ] 0.5: Read Scepture data/MANIFEST.md — table inventory + empty-table constraints
  - [ ] 0.55: Read Tools/5_Server_Tools_Details.json — tool ground truth (276 tools + parameters)
  - [ ] 0.6: Read the relevant Scepture data/<schema>/ tables — build the universe state for verification
  - [ ] 0.7: Read gemini_fully_specified agent runs/ if present — Pass@5 evidence

- [ ] Phase 1: F1 — Impossible-with-Connectors
  - [ ] 1.1: For EACH rubric/ask, verify the required tool exists in Tools/5_Server_Tools_Details.json (and any relied-on parameter is exposed by that tool)
  - [ ] 1.2: Reject any empty-DATA capability — the gcal/gslides/linear_comment/github-issue-release-tag/slack-draft-scheduled/snowflake tools exist in the catalog, but their tables are empty (MANIFEST), so nothing is gradable
  - [ ] 1.3: For EACH entity, verify it's discoverable via a realistic query chain
  - [ ] 1.4: Check pagination walls (586k slack_messages / 24.7k gmail_messages need a filter, not a full scan)
  - [ ] 1.5: Check attachment/file content referenced without a way to read it
  - [ ] 1.6: Record verdict per rubric: FEASIBLE / IMPOSSIBLE / UNREACHABLE

- [ ] Phase 2: F2 — Persona & Date Mismatch
  - [ ] 2.1: Prompt reads as the assigned persona (role, authority, access)
  - [ ] 2.2: Persona has authority for ALL rubric-required actions (no overreach)
  - [ ] 2.3: If the task sends email, the persona owns a mailbox in gmail/gmail_users.json (only 8 exist)
  - [ ] 2.4: Slack/email attribution matches the persona in universe data
  - [ ] 2.5: All rubric events fall at/before 2026-01-27; no future-as-past
  - [ ] 2.6: Every entity reference exists in universe data
  - [ ] 2.7: Recipients exist in Contacts/Slack/Gmail and are active
  - [ ] 2.8: Record verdict: CONSISTENT / MISMATCH / PHANTOM

- [ ] Phase 3: F3 — Process / Category Violations
  - [ ] 3.1: List all Process rubrics; apply the three-condition test to each
  - [ ] 3.2: For ALL rubrics: does the criterion name a specific tool as the success condition? (TOOL_GATE)
  - [ ] 3.3: Does it pin specific query params when alternatives work? (QUERY_GATE)
  - [ ] 3.4: Any write action miscategorized as Process? (must be OC 1.1)
  - [ ] 3.5: Any quality-degree judgment as Objective Compliance instead of Expert Assessment?
  - [ ] 3.6: Process > 40% of total? 3+ items crediting the same tool/service?
  - [ ] 3.7: Record verdict: LEGITIMATE_PROCESS / TOOL_GATE / QUERY_GATE / WRITE_IN_PROCESS / MISCATEGORIZED

- [ ] Phase 4: F4 — Rubric Defects (Broken / Over-Strict)
  - [ ] 4.1: Extract EVERY expected value (names, emails, handles, keys, PR titles, versions, figures, dates, counts)
  - [ ] 4.2: GREP each against Scepture data/; for calculations, verify components + math
  - [ ] 4.3: Verify each email/handle maps to the right person
  - [ ] 4.4: For each pinned approach: would a valid alternative path be wrongly penalized?
  - [ ] 4.5: Check channel/method lock-in, structured-ID lock-in, evidence stricter than criterion
  - [ ] 4.6: Check role/segregation overreach
  - [ ] 4.7: Verify facts match the CURRENT universe snapshot (not stale)
  - [ ] 4.8: Record verdict: SOUND / BROKEN / OVER_STRICT

- [ ] Phase 5: F5 — Illegal Tool-Output Dependencies
  - [ ] 5.1: For EACH criterion: verifiable from tool CALL ARGUMENTS / final response alone?
  - [ ] 5.2: Flag "tool returned success" checks, values only in tool responses, cross-response aggregation
  - [ ] 5.3: Content in write args (email body, message text, issue field) IS verifiable ✓
  - [ ] 5.4: Record verdict: SELF_CONTAINED / VERIFIABLE_FROM_ARGS / NEEDS_TOOL_OUTPUT

- [ ] Phase 6: F6 — QC-Pattern Compliance
  - [ ] 6.1: Atomicity — any criterion bundling 2+ independently-verifiable items?
  - [ ] 6.2: Forward coverage — every explicit deliverable mapped to an Outcome rubric?
  - [ ] 6.3: Under-strict — per criterion in isolation, could a wrong answer still pass?
  - [ ] 6.4: Destination consistency — rubrics target the prompt's specified output?
  - [ ] 6.5: Blank fields — every rubric has non-blank category/criterion/justification/evidence + weight/score-type/dependencies?
  - [ ] 6.6: Exclusion coverage — filter criteria + decoys → incorrect inclusion penalized?
  - [ ] 6.7: Delegation clarity — prompt mixes "I'll [verb]" with agent imperatives?
  - [ ] 6.8: Gate composition — gate small, objective, atomic; nothing subjective; safety/PII present?
  - [ ] 6.9: Expert-Assessment bands — fixed −1…+1 scale, distinct falsifiable bands?
  - [ ] 6.10: Penalties — subtract-only 0/−1/−2/−3, positive wording; no negative weights; must-fail behaviors in the gate not as penalties?
  - [ ] 6.11: Feasibility (strict) — every explicit ask fulfillable (no "minor secondary" escape)?
  - [ ] 6.12: Date alignment (strict) — universe data temporally sound with 2026-01-27?

- [ ] Phase 7: F7 — Pillar Profile & Difficulty
  - [ ] 7.1: Each pillar hits its declared band; no off-profile over-build
  - [ ] 7.2: Dual-prompt consistency — specified + under-specified drive the same end-state
  - [ ] 7.3: Pass@5 < 30% on the Gemini checkpoint (fully-specified prompt) — evidence or credible estimate
  - [ ] 7.4: Ethical tripwire (if declared) is present in the data and covered by a penalty/gate item

- [ ] Phase 8: Final Verdict
  - [ ] 8.1: Fill per-rubric findings + task-level checks
  - [ ] 8.2: Count failures per family (F1-F7) → PASS only if zero failures across ALL families
```

---

## Input Files

| File | Purpose |
|---|---|
| `prompt.txt` | Persona, scenario, both prompts, asks |
| `golden_solution.txt` | Intended ground-truth deliverables + values |
| `rubrics.json` | All rubric items — primary target |
| `task_metadata.md` | Declared pillar profile, sources, distractors, tripwires, human-time estimate |
| `rubric_verifier.txt` | Author's verifier notes |
| `Scepture data/<schema>/<table>.json` | Universe data |
| `Scepture data/MANIFEST.md` | Table inventory + empty-table constraints |
| `Tools/5_Server_Tools_Details.json` | **Tool ground truth** — 276 connector tools + parameters (F1 tool/parameter existence) |
| `gemini_fully_specified agent runs/trajectory-run-N.json` | Pass@5 evidence (if available) |

---

## Phase 1: F1 — Impossible-with-Connectors

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Non-existent tool | Rubric/ask needs a tool with no match in `Tools/5_Server_Tools_Details.json` | rubric expects an in-place delete no connector tool offers | **IMPOSSIBLE** |
| Non-existent parameter | Rubric hinges on a tool field the tool doesn't expose | criterion grades a value the tool's `parameters` don't include | **IMPOSSIBLE** |
| Empty-data capability | Tool exists in the catalog but its table is empty (`MANIFEST.md`) | "schedule a meeting" (`gcal_*` exist, gcal empty), "build a deck" (`gslides_*` exist, empty), "comment on the ticket" (`linear_create_comment` exists, no comments), "open a GitHub issue / cut a release" (tools exist, empty), "schedule a Slack message" (`slack_schedule_message` exists, empty), "read from Snowflake" (`snowflake_*` exist, no data) | **IMPOSSIBLE** |
| Undiscoverable entity | Entity in data but no realistic query surfaces it | a message with no channel/keyword/thread anchor | **UNREACHABLE** |
| Pagination wall | Full scan of a huge table with no filter | "total across all 586k Slack messages" with no narrowing filter | **UNREACHABLE** |
| Unreadable content | File/attachment content referenced with no way to read it | rubric expects values from a Drive binary tools only list by name | **IMPOSSIBLE** |

---

## Phase 2: F2 — Persona & Date Mismatch

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Persona role mismatch | Prompt actions exceed the persona's role/authority | a coordinator making an executive go/no-go call they don't own | **MISMATCH** |
| No mailbox | Email-sending persona absent from `gmail/gmail_users.json` (8 mailboxes) | task requires the persona to email but they have no mailbox | **MISMATCH** |
| Wrong attribution | Slack/email attributed to the wrong persona | messages authored as another user | **MISMATCH** |
| Role overreach | Rubric requires the persona to approve/certify beyond authority | an engineer required to sign off on a release gate reserved for a lead | **MISMATCH** |
| Future-as-past | Rubric expects analysis of events after 2026-01-27 | references a build "shipped" after the extract date | **MISMATCH** |
| Phantom entity | Prompt/rubric references a message/person/ticket that doesn't exist | "the doc Robert shared" with no such Drive/Docs file | **PHANTOM** |
| Inactive recipient | Rubric emails someone not in Contacts/Gmail or departed | recipient absent from the universe | **PHANTOM** |

---

## Phase 3: F3 — Process / Category Violations

A Process rubric is legitimate ONLY if all three hold: (1) required by every valid path, (2) a stricter Outcome can't capture it, (3) it verifies a behavior (not a tool trace).

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Tool-selection gate | Criterion names a specific tool as the success condition | "must use the Slack search tool" when other reads return the same data | **TOOL_GATE** |
| Query gate | Pins specific query params when alternatives return the same data | "must query 'go/no-go'" when a broader read finds it | **QUERY_GATE** |
| Write-in-Process | A write (send/create/update/post) categorized as Process | "send_email" credited just for calling it | **WRITE_IN_PROCESS** |
| Quality-as-OC | A degree/quality judgment as Objective Compliance | "the report is well organized" as a binary OC check | **MISCATEGORIZED** (→ Expert Assessment) |
| Inflated credit | Process > 40% of total, or 3+ items crediting the same service | many process items in a thin scenario | Flag imbalance |

---

## Phase 4: F4 — Rubric Defects (Broken / Over-Strict)

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Missing target | An embedded value doesn't exist in the universe | ticket key / PR title / version / figure absent from `Scepture data/` | **BROKEN** |
| Bad calculation | Component data missing or math wrong | rubric total doesn't match summed source records | **BROKEN** |
| Stale data | Rubric fact contradicts the current snapshot | rubric "status: open" but data shows "Done" | **BROKEN** |
| Channel/method lock-in | Prompt said "notify" but rubric requires email | valid Slack path would fail | **OVER_STRICT** |
| ID-format lock-in | Rubric pins `channel_id` when the name is valid | `C007` demanded when `#release-blockers` works | **OVER_STRICT** |
| Role overreach | Persona required to act beyond authority | engineer required to certify a release gate | **OVER_STRICT** |
| Email format locked | One address form pinned when an alias is valid | pins `robert@…` when `r.calloway@…` also maps to them | **OVER_STRICT** |

---

## Phase 5: F5 — Illegal Tool-Output Dependencies

| Check | What to look for | Verdict |
|---|---|---|
| Success-check | "tool returned success" | **NEEDS_TOOL_OUTPUT** |
| Response-only value | Expected value only appears in a tool response, not the call args or final answer | **NEEDS_TOOL_OUTPUT** |
| Cross-response aggregation | Requires summing across multiple tool responses the judge can't see | **NEEDS_TOOL_OUTPUT** |
| Write-arg content | Content in write args (email body, Slack text, issue field) | VERIFIABLE ✓ |
| Self-contained value | Criterion embeds the expected value directly | SELF_CONTAINED ✓ |

---

## Phase 6: F6 — QC-Pattern Compliance

| # | Check | Verdict if found |
|---|---|---|
| 6.1 | Criterion bundles 2+ independently-verifiable items | **NOT_ATOMIC** |
| 6.2 | Explicit deliverable has zero Outcome coverage | **MISSING_CRITERIA** |
| 6.3 | In isolation, a wrong answer could still pass | **OVERLY_BROAD** |
| 6.4 | Rubric checks "final response" when prompt says email/Slack/issue | **WRONG_DESTINATION** |
| 6.5 | Blank category/criterion/justification/evidence or missing weight/score-type/dependencies | **BLANK_FIELD** |
| 6.6 | Filter criteria + decoys but no exclusion rubric | **MISSING_EXCLUSION** |
| 6.7 | Prompt mixes "I'll [verb]" with agent imperatives | **DELEGATION_AMBIGUITY** |
| 6.8 | Subjective/degree/non-atomic item in the must-pass gate | **BAD_GATE_ITEM** |
| 6.9 | Expert-Assessment band off the −1…+1 scale or non-falsifiable | **BAD_BAND** |
| 6.10 | Negative weight, or a must-fail behavior encoded as a penalty (belongs in the gate) | **BAD_PENALTY** |
| 6.11 | Any explicit ask can't be fulfilled — no "minor secondary" escape | **INFEASIBLE** |
| 6.12 | Universe data misaligned with 2026-01-27 → stale/ambiguous references | **DATE_MISALIGNED** |

---

## Phase 7: F7 — Pillar Profile & Difficulty

| Check | What to look for | Verdict |
|---|---|---|
| Off-profile over-build | A pillar cranked high the task never scoped (e.g., a P4 task with an unscoped hard ethical trap) | **OFF_PROFILE** |
| Under-built claimed pillar | A pillar declared high but not actually exercised (e.g., "P4-high" but a 3-hop lookup) | **UNDER_BUILT** |
| Dual-prompt drift | Specified + under-specified imply different end-states | **PROMPT_DRIFT** |
| Too easy | Trivially solvable — won't hold Pass@5 < 30% (single-service, shallow, investigate+one-email) | **TOO_EASY** |
| Tripwire uncovered | Declared ethical tripwire present in data but no penalty/gate item covers it | **TRIPWIRE_UNCOVERED** |

---

## Phase 8: Final Verdict

**Per-rubric aggregate:**

| Rubric # | Criterion | F1 | F2 | F3 | F4 | F5 | F6 | Overall |
|---|---|---|---|---|---|---|---|---|
| 1 | … | FEASIBLE | CONSISTENT | N/A | SOUND | SELF_CONTAINED | PASS | **PASS** |
| 2 | … | IMPOSSIBLE | — | — | BROKEN | — | NOT_ATOMIC | **FAIL** |

**Task-level:**

| Check | Result |
|---|---|
| F1: Any IMPOSSIBLE / UNREACHABLE (non-existent tool/param, or empty-data capability)? | PASS/FAIL |
| F2: Any PHANTOM / MISMATCH / no-mailbox? | PASS/FAIL |
| F3: Any TOOL_GATE / QUERY_GATE / WRITE_IN_PROCESS / MISCATEGORIZED? | PASS/FAIL |
| F4: Any BROKEN / OVER_STRICT? | PASS/FAIL |
| F5: Any NEEDS_TOOL_OUTPUT? | PASS/FAIL |
| F6: Any NOT_ATOMIC / MISSING_CRITERIA / OVERLY_BROAD / WRONG_DESTINATION / BLANK_FIELD / MISSING_EXCLUSION / DELEGATION_AMBIGUITY / BAD_GATE_ITEM / BAD_BAND / BAD_PENALTY / INFEASIBLE / DATE_MISALIGNED? | PASS/FAIL |
| F7: Any OFF_PROFILE / UNDER_BUILT / PROMPT_DRIFT / TOO_EASY / TRIPWIRE_UNCOVERED? | PASS/FAIL |
| Process > 40%? | PASS/FAIL |
| Pass@5 < 30% on Gemini checkpoint? | PASS/FAIL |

```
┌─────────────────────────────────────────────┐
│           SUBMISSION GATE VERDICT           │
├─────────────────────────────────────────────┤
│ Total rubrics evaluated:  ___               │
│ F1 (Impossible-with-Connectors): ___        │
│ F2 (Persona & Date):             ___        │
│ F3 (Process / Category):         ___        │
│ F4 (Broken / Over-Strict):       ___        │
│ F5 (Tool-Output Deps):           ___        │
│ F6 (QC-Pattern Compliance):      ___        │
│ F7 (Pillar & Difficulty):        ___        │
│ TOTAL FAILURES:                  ___        │
│                                             │
│ VERDICT:  PASS / FAIL                       │
│ PASS = zero failures across ALL 7 families  │
│        AND Pass@5 < 30%.                     │
│ Any single defect = FAIL.                   │
└─────────────────────────────────────────────┘
```

---

## Quick Reference: Canonical Submission-Gate Patterns

| # | Pattern | Family | Auto-flag |
|---|---|---|---|
| 1 | Rubric requires scheduling / a slide deck / a Linear comment / a GitHub issue-release / Snowflake (tool exists in `Tools/5_Server_Tools_Details.json` but the table is empty), OR a tool/parameter with no catalog match | F1 | IMPOSSIBLE |
| 2 | Entity appears in zero universe records | F1 | UNREACHABLE |
| 3 | Full scan of 586k Slack / 24.7k Gmail rows with no filter | F1 | UNREACHABLE |
| 4 | Email-sending persona has no mailbox in `gmail_users.json` | F2 | MISMATCH |
| 5 | Prompt references a message/person/ticket that doesn't exist | F2 | PHANTOM |
| 6 | Rubric event dated after 2026-01-27 | F2 | MISMATCH |
| 7 | "Must use `specific_tool`" when equivalent returns same data | F3 | TOOL_GATE |
| 8 | Write action categorized as Process | F3 | WRITE_IN_PROCESS |
| 9 | Quality-degree judgment as Objective Compliance | F3 | MISCATEGORIZED |
| 10 | Dollar/version/key/email doesn't exist in universe | F4 | BROKEN |
| 11 | Rubric pins `channel_id` when the name works | F4 | OVER_STRICT |
| 12 | Persona required to act beyond role authority | F4 | OVER_STRICT |
| 13 | Criterion checks "tool returned success" | F5 | NEEDS_TOOL_OUTPUT |
| 14 | Value only in a tool response, not call args / final answer | F5 | NEEDS_TOOL_OUTPUT |
| 15 | Criterion bundles 2+ independently-verifiable items | F6 | NOT_ATOMIC |
| 16 | Explicit deliverable has zero Outcome coverage | F6 | MISSING_CRITERIA |
| 17 | Wrong answer could plausibly pass a criterion in isolation | F6 | OVERLY_BROAD |
| 18 | Rubric checks "final response" when prompt specifies email/Slack/issue | F6 | WRONG_DESTINATION |
| 19 | Blank field or missing per-item field | F6 | BLANK_FIELD |
| 20 | Filter criteria + decoys but no exclusion rubric | F6 | MISSING_EXCLUSION |
| 21 | "I'll [verb]" mixed with agent imperatives | F6 | DELEGATION_AMBIGUITY |
| 22 | Subjective/non-atomic item in the must-pass gate | F6 | BAD_GATE_ITEM |
| 23 | Expert band off the −1…+1 scale or non-falsifiable | F6 | BAD_BAND |
| 24 | Negative weight or must-fail behavior as a penalty | F6 | BAD_PENALTY |
| 25 | Explicit ask can't be fulfilled — no "minor secondary" escape | F6 | INFEASIBLE |
| 26 | Universe data misaligned with 2026-01-27 | F6 | DATE_MISALIGNED |
| 27 | Specified + under-specified prompts drive different end-states | F7 | PROMPT_DRIFT |
| 28 | A claimed-high pillar not actually exercised | F7 | UNDER_BUILT |
| 29 | An unscoped pillar cranked high | F7 | OFF_PROFILE |
| 30 | Solvable shallow / single-service / investigate+one-email | F7 | TOO_EASY |
| 31 | Declared ethical tripwire not covered by any penalty/gate item | F7 | TRIPWIRE_UNCOVERED |

---

## Key Rules

1. **One failure = task FAIL.** No "minor" defect exists — every pattern above is a real escape.
2. **Do not rationalize a match away.** These patterns are wrong the vast majority of the time.
3. **Tool exists ≠ data exists.** Verify tools/parameters against `Tools/5_Server_Tools_Details.json`. Scheduling, slides, Linear comments, GitHub issues/releases, and Snowflake have *tools* in the catalog but *empty* tables in this universe — any rubric needing them is an automatic F1 fail.
4. **Process rubrics get triple scrutiny.** Default: wrong until proven right by the three-condition test.
5. **Check evidence/justification fields too.** Embedded values must match `Scepture data/`; the gate must stay objective; bands must sit on the fixed scale.
6. **The difficulty bar is part of the gate.** A defect-free task that a model solves trivially still FAILs — it must plausibly hold Pass@5 < 30%.
