# Full Rubrics Guide

*Everything you need to write falsifiable, atomic, agent-centric criteria that expose what a frontier AI agent gets wrong.*

**The rubric is the deliverable that matters most.**

A task can look great and still teach the model nothing if the rubric is vague, bundled, or reward-hackable. This guide covers the full framework: categories, weights, phrasing, strictness, structure rules, grading, rating, and justification — with worked examples throughout.

---

## 1. Why rubrics matter

For enterprise tasks, "correctness" is multi-dimensional. A financial analyst who produces the right report but consulted no reference data, or a legal agent that arrives at the right redline by coincidence, has not shown the competence we want to measure. Your rubric must separately evaluate what the agent produced, how it worked, and whether the work would pass expert review.

Rubrics are clear yes/no checks for whether the agent did the right thing. The judge evaluates them using the prompt, the trajectory, the final response, and your criteria — not the full universe. So every rubric must be self-contained.

**Design principles**

- **The rubric exists to expose failures.** A well-built rubric surfaces meaningful weaknesses rather than letting the agent trivially pass. If the agent passes everything, the task was probably too simple.
- **Outcome-first.** Evaluate the agent primarily through the outcomes it produces, not its internal reasoning steps. Prioritize verifiable outcomes over intermediate reasoning.
- **Tightly scoped.** Every criterion must be specific to this task's objective and expected deliverables — not generic.
- **Concise.** Keep the set focused on the most important verification points. Excessive rubrics reduce clarity and duplicate checks.

> **HEADS UP — FRAMEWORK UPDATE:**
> Tool Selection and Query Construction rubrics are no longer a thing. Every rubric is now exactly one of three categories — Objective Compliance, Expert Assessment, or Process. The three-condition Process test in Section 4 still applies. Process rubrics are optional and rare.

**How scoring works: the gate vs. partial credit**

Every run is graded two ways over the same trajectory:

- **The gate (Pass/Fail).** A small set of must-pass criteria decide whether the run passes. ALL of them must pass — if even one fails, the run fails (regardless of weight).
- **Partial credit (a diagnostic score).** Every other criterion feeds a weighted-average quality score. This score is informational — it never decides Pass/Fail.

Which criteria go in the gate? Put a criterion in the gate only if BOTH are true:

1. Objectively pass/fail — verifiable from the tool calls, final state, or artifact, with no quality-degree judgment (yes/no, not "how good").
2. Atomic and unique — if the agent did everything else perfectly but failed only this, the whole deliverable would be unacceptable.

If either is false, it's a partial-credit item. Anything about degree or quality is partial credit. Safety/PII always goes in the gate.

Keep the gate small and objective — it holds the task's non-negotiables (required findings, required actions, figure/accuracy checks, safety/PII), nothing subjective.

> **Example (the loan-discrepancy task):** gate items = the correct discrepancy figure is reported, the flag/email/meeting actions are actually executed, no PII is leaked. Partial credit = how clear and useful the email is (Expert Assessment band), whether the agent flagged before scheduling (Process). A penalty applies if the agent fabricates a figure.

## 2. The rubric categories

Assign each rubric item exactly one category. The category determines what it measures and which judge inputs it needs. There are three categories — Objective Compliance, Expert Assessment, and Process. Objective Compliance breaks into three sub-types (1.1, 1.2, 2.1).

Throughout this guide, "Outcome" is shorthand for the two outcome categories together — Objective Compliance + Expert Assessment (everything that isn't Process).

| Category | Question it answers | Examples | How to write it |
|---|---|---|---|
| **Objective Compliance** | Did the agent fulfill the basic work-product criteria? | • "The redlined contract contains all 5 required clause modifications." • "The output CSV has exactly 12 rows and the total column sums to $4,250." • "All requested Q3 metrics are present in the final report." | Rubrics in this category evaluate the correctness, completeness (did it meet the specs?), and instruction-following of the final deliverable against verifiable requirements. Importantly, they don't evaluate the substantive quality or professional judgment of the work. These are the most objective rubric types. |
| **Expert Assessment** | Would a senior professional trust this work? | • The executive summary is less than 150 words and includes information about [topic 1] and [topic 2]. • The executive summary does not contain [detail 1], [detail 2]. • The agenda slide contains [list of 5 sections] and each section has a <10 words description. • The slide deck only uses colors from the template's color palette and does not use any custom colors. | Rubrics in this category capture the expert-level quality judgment that goes beyond basic completeness: is the work actually good by the standards of the profession? These require subject-matter expertise to write and evaluate. Characteristics: Qualitative quality judgments scored across discrete bands (e.g. −1 to +1), each band a distinct outcome with a score, a short label, and a description. Simple, purely objective quality checks may still be binary (0/1). |
| **Process** | Did the agent work in a reasonable way? | • Agent consulted the compliance playbook before drafting the policy recommendation. • Agent asked the client for clarification on the ambiguous contract term rather than guessing. • Agent retried the failed API call before escalating to the user. | Frame as behavioral expectations over the full trajectory, not rigid step traces. Requires the trajectory as a judge input. |

**Objective Compliance — more examples**

✅ **GOOD**

- The redlined contract contains all 5 required clause modifications.
- The output CSV has exactly 12 rows and the total column sums to $4,250.
- All requested Q3 metrics are present in the final report.

**Expert Assessment — decompose quality into checks (binary or scored bands)**

These require subject-matter expertise. Decompose your quality judgment into discrete checks — binary yes/no sub-criteria when quality is present/absent, or scored bands when quality varies by degree — rather than a holistic gut assessment. Look for major errors that would make the work untrustworthy.

Legal redline task:

- Does the analysis correctly identify the controlling precedent? (yes/no)
- Is the reasoning connecting precedent to the proposed redline logically sound? (yes/no)
- Would the proposed language be defensible in negotiation? (yes/no)

Medical triage task:

- Does the differential diagnosis account for the patient's medication history? (yes/no)
- Are the ordered labs appropriate for the suspected conditions? (yes/no)

**Expert Assessment — generated artifacts (slides, docs, sheets, emails)**

Specify detailed, falsifiable criteria about the artifact's contents and formatting.

✅ **GOOD**

- The executive summary is less than 150 words and includes information about [topic 1] and [topic 2].
- The executive summary does not contain [detail 1] or [detail 2].
- The agenda slide contains [list of 5 sections] and each section has a description under 10 words.
- The slide deck only uses colors from the template's palette and no custom colors.

❌ **AVOID**

- The executive summary is well written.
- The slide deck has a good color scheme.

**Scored bands (where partial credit comes from)**

Expert Assessment is where partial credit comes from. When quality varies by degree, score the judgment across a few discrete bands = each with a score, a short label, and a falsifiable description of exactly what earns it.

The scale is fixed. A band's score must be one of: −1, −0.75, −0.5, −0.25, 0, 0.25, 0.5, 0.75, +1 — don't invent other values. The direction is fixed too:

- **+1** = fully meets the professional bar
- **0** = present but adds no value (baseline)
- **−1** = seriously flawed / would mislead

(positive = good, negative = actively bad; the quarter-steps are just "a bit more/less" between these.)

Use only the bands you need — most items need 3–4. Each band you use must sit on this scale, follow the direction above, and carry a label + a description specific to your artifact.

| Score | Label | What earns it |
|---|---|---|
| −0.5 | advocacy | Reads as a brief for one option; analysis exists to justify a foregone conclusion. |
| 0.0 | brochure | Options restated with generic pros/cons; the reader learns nothing new. |
| 0.5 | quantified | Each option carries its real numbers, so trade-offs are comparable. |
| 1.0 | decision-ready | Quantified, plus explicit decision triggers and the named open questions. |

Bands must be distinct and falsifiable — two reviewers should land on the same band. Purely objective checks (e.g. "summary is under 150 words") can stay binary 0/1.

**Process — what to check**

- Did the agent consult provided reference materials (playbooks, guidelines, knowledge bases) before acting?
- Did it reach out to relevant stakeholders when the task required collaboration or clarification?
- Did it handle ambiguity by seeking clarification rather than making unsupported assumptions?
- Did it attempt recovery when encountering errors, rather than silently failing or hallucinating a workaround?
- Did it respect ordering constraints (e.g., verifying data quality before building a model on it)?

## 3. How to write a single criterion

**Phrase every rubric agent-centric**

Frame each rubric as a behavior of the agent, not a passive description of an artifact. This applies to Outcome and Process alike.

- Subject = "the Agent" (or "Agent").
- Drop (via tool_name) and (visible in parameters) annotations.
- No tool names in rubrics (or in prompts).
- Read it aloud — it should sound natural.

❌ **AVOID:** An email was sent (via send_email) to chloe.vance@company.com.
✅ **GOOD:** Agent sends an email to chloe.vance@company.com.

**Verb cheat sheet**

| Sub-type | Verbs to reach for |
|---|---|
| Objective Compliance 1.1 (write actions) | sends, creates, updates, posts, schedules, assigns |
| Objective Compliance 1.2 (action content) | includes, mentions, states, covers, references, names |
| Objective Compliance 2.1 (findings) | identifies, reports, flags, lists, recommends, concludes |
| Process | verifies, confirms, checks, reviews, reconciles, notifies (before X) |

**The three fields every rubric needs**

- **Criterion** — the specific yes/no claim the judge evaluates. Self-contained, objective, atomic, verifiable.
- **Justification** — 1–2 sentences explaining why this rubric exists.
- **Evidence** — what to look for in the trajectory or final response to prove pass or fail.

**Per-item fields (declared on every rubric)**

Beyond the criterion / justification / evidence, every rubric item also declares five structured fields:

| Field | What it is |
|---|---|
| category | Exactly one of: Objective Compliance, Expert Assessment, or Process. |
| grading_method | How it's graded: deterministic (an exact/code check) or LLM judge. |
| score type | discrete (fixed outcomes, e.g. 0/1 or scored bands), continuous (a value in [0,1]), or programmatic (a script returns a score in [0,1] with a valid/invalid status). |
| weight | How much the item counts toward the partial-credit score (see Weighting). |
| dependencies | What the judge reads to grade the item: the trajectory, the produced artifact / final environment state, or a reference (gold source). Sets what the item is graded against, not the score scale. |

**Weighting**

Every item carries a weight — a positive integer that sets how much it counts toward the partial-credit score. Only the ratios matter, so use small integers:

| Weight | Use for |
|---|---|
| 1 | Normal item (default) |
| 2 | Important item |
| 3 | Most critical outcomes (and the strongest penalties) |

**What every criterion must be**

Each criterion must be atomic, objective and verifiable, self-contained, clearly specify what counts as PRESENT and NOT PRESENT, be written in positive language, with any must-not-happen behavior expressed as a penalty item (0/−1/−2/−3) rather than a negatively-worded criterion.

| Property | Wrong | Fixed |
|---|---|---|
| **Self-contained** — Evaluable against the response alone; no need for the prompt, other criteria, or external facts. | "Response identifies the first president of the USA." / "The response addresses the bug mentioned in the prompt." | "Response identifies the first president of the USA as George Washington." / "The response addresses the bug where the submit button doesn't work." |
| **Atomic** — Tests one thing only; no bundling. | "The agent includes columns named 'party', 'season', and 'beverages'." | Three separate criteria — one per column name. |
| **Objective** — Measurable; no vague qualifiers without a definition. | "The response should have good formatting." | "The response should include a title." |
| **Positive language** — Write positively; express any must-not-happen behavior as a penalty item, not a negatively-worded criterion; no double negatives. | "The model does not hallucinate tool outputs." | "The response correctly references only information returned by tools." (cover a must-not-happen behavior with a penalty item scored 0/−1/−2/−3, not a negative weight) |

## 4. Outcome first — when to use Process

> **CORE RULE**
> Write all Outcome rubrics first — Outcome is the default training signal. After writing every Outcome, review the full set for gaps no Outcome can cover. Only add a Process rubric when a correct final output alone won't reliably prove the task was done right, and a stricter Outcome can't capture the same requirement. When in doubt, tighten the Outcome instead.

Add a Process rubric only when all three conditions hold:

1. **Required by every valid path.** Phrased broadly enough that any valid solution passes ("Agent notifies legal," not "Agent emails legal").
2. **Outcome can't cover it.** If a stricter Outcome (precise values, derived math, exact IDs) would prove the step happened, prefer that. If the Outcome rubrics already prove the behavior through precise values the agent could only produce by doing the work, don't add a Process rubric.
3. **Verification, not execution trace.** Describe what was verified, not which tool was called.

If any condition fails, drop the Process rubric or tighten the Outcome.

> **ORDERING CAN BE EXPLICIT AND STILL NEED PROCESS**
> An ordering constraint can be spelled out in the prompt ("notify legal before scheduling the meeting") and still require a Process rubric — because no Outcome rubric can verify ordering. What makes it Process is that Outcome can't capture it. Atomicity applies: one ordering constraint per rubric. If A-before-C and B-before-C both matter, write two Process rubrics.

**When Process is warranted**

The prompt requires emailing legal before scheduling a contract meeting. The scheduling outcome doesn't prove the email came first.

> **PROCESS RUBRIC:** Agent emails the legal team before scheduling the contract signing meeting.

**When Outcome is enough**

The prompt requires finding a rate-lock overcharge by comparing a payment record to a PDF. Don't write "Agent retrieves both sources" — that's reward-hackable. Instead, force the work through a precise number.

> ❌ **REWARD-HACKABLE:** Agent retrieves both the payment record and the closing disclosure.
> ✅ **TIGHTER OUTCOME:** Agent identifies a $264 overcharge — the difference between the $792 charge and the $528 closing-disclosure amount. (the agent can't get all three numbers right without doing the work)

## 5. How strict should a rubric be?

Match strictness to the kind of value you're checking. Too strict rejects valid solutions (overfitting); too loose accepts invalid ones (underfitting).

| Strictness | When to use it | How to phrase |
|---|---|---|
| Strict (exact match) | One correct answer: email addresses, dates, IDs, exact strings, specific numbers from tool outputs. | Quote the exact value: "…to robert.hayward@keystone.com." |
| Flexible (fuzzy) | Multiple valid expressions: freetext queries, email subjects, issue titles, agent-generated content. | Describe intent + add "(or similar)." |
| Required elements | Agent content with several specific requirements. | "must include: (a) reason, (b) city name, (c) cost comparison." |
| "Approximately" | Calculated or rounded values only. Never for counts, IDs, dates, or discrete quantities. | "approximately $1,240." |
| Method-agnostic | When the prompt names a goal, not a method. | "Agent notifies legal," not "Agent emails legal." |

**Multiple valid answers**

- "must be one of: A, B, or C" → closed set.
- "including but not limited to: A, B" → open set.
- "at least one of: A, B, or C" → any one suffices.

> **NEVER USE OPEN-ENDED EXAMPLE WORDING TO DEFINE CORRECTNESS**
> Never use "such as," "like," or "for example" when defining what counts as correct. Those make the criterion unfalsifiable. Criteria may name specific answers only as illustrative examples (in parentheses).

## 6. Rubric structure rules

**Critical event coverage**

Every critical outcome or milestone required for the task must have a corresponding rubric — producing the final artifact, completing a required integration, executing a key decision rule, generating the required output format. Critical steps that can fail independently must not be bundled into a single criterion.

**Atomic rubrics for multiple write actions**

When the prompt asks for multiple write actions of the same type (update all tickets, create tickets for all follow-up items), write one Outcome rubric per item grounded in ground truth — never bundle into "at least N" thresholds. "At least N" is reward-hackable.

For open-ended prompts ("create tickets for anything needing follow-up"), go to the universe, identify the actual ground-truth items, and write one rubric per item. "At least one" is only acceptable when ground truth is genuinely indeterminate.

**Spot checks for repeated actions**

When a task repeats an action across many items (processing rows, sending many emails) and enumerating each is impractical, use a spot check that includes both:

- **Aggregate count verification** — e.g., "The agent sends all 16 required emails."
- **Specific instance verification** — check ≥3 randomly selected instances, e.g., "Email #2, #7, and #14 contain the correct personalized information."

**Stacked rubrics (OR logic)**

- When multiple outcomes are genuinely valid but not all appear in every correct solution, use stacked rubrics to represent alternative correct outcomes.
- OR logic: triggering any one of the valid outcomes counts as success; the agent need not satisfy all stacked criteria.
- Use stacking only when multiple solutions are truly valid — never to hide missing rubric coverage.

## 7. Justifying failures

Every criterion the agent scored NOT PRESENT (that fails across most runs) must have a written justification covering all three areas.

| Area | Bad | Good |
|---|---|---|
| **Why correct** — Why this check is valid; quote the prompt/input that grounds it. | "It checks an important thing." | "The prompt explicitly states 'produce a ranked table sorted by risk score' — this rubric verifies the sorting exists." |
| **Why present** — Why it matters and distinguishes correct from incorrect. | "It matters for quality." | "Without this check the model could produce an unsorted dump and still pass → it distinguishes a response that followed the scoring logic from one that didn't." |
| **What the model did wrong** — State definitively, citing specific trajectory actions. No hedging. | "The model probably didn't do it." | "The model produced a summary table but did not apply the 3-factor scoring rule (cost × urgency × reliability). The table contains raw values with no computed score column." |

> **THE DELETION RULE**
> If you cannot justify a criterion in all three areas — it can't be grounded in the prompt, explained as meaningful, or tied to a concrete model failure — delete it. Justifications must be definitive, reference the prompt or trajectory directly, and never cite other models, pass rates, or run statistics.

## 8. Common errors to avoid

**The six classic rubric errors**

1. **Incorrect criteria** — checks something not aligned with prompt requirements, or contains a factual/misleading error.
2. **Overlapping / redundant criteria** — fully or partially duplicate other criteria, including a positive and an oppositely-weighted negative that evaluate the same aspect (double-penalizes the same issue).
3. **Overfitting / underfitting** — overfit criteria are too rigid and reject valid implementations; underfit criteria are too broad and accept invalid ones. Name specific answers only as examples.
4. **Subjective criteria** — vague/immeasurable wording ("clear and natural," "appropriate tone," "sufficient depth").
5. **Missing criteria** — an explicit requirement or critical implicit expectation has no coverage (major); a non-critical requirement has no coverage (moderate).
6. **Incorrect weights** — off by two levels (major, e.g., 1 where 3 belongs) or one level (minor, e.g., 1 vs 2).

**Phrasing & structure mistakes**

- Vague targets — "Agent sent an email to the CEO" → name the address: "…to elena.rostova@company.com (CEO)."
- Passive / artifact-centric phrasing — "The email mentions the storm" → "Agent mentions the storm in the email to Chloe."
- Tool-name annotations — drop "(via send_email)" and any tool names.
- Bundling independent actions into one rubric.
- Writing a Process rubric when a stricter Outcome would prove the same thing.
- Locking a Process rubric to one method/tool when the prompt named a goal.
- Overlapping rubrics that punish the same mistake more than once.
- Subjective language — "enough," "professional," "thorough," "helpful," "good."
- Using "approximately" for counts, IDs, or dates.
- Double-negative phrasing anywhere in a criterion.
- Rubrics the judge can't verify from the trajectory or final response.

## Rubric quality checklist

Run this before you submit.

- [ ] The rubric exposes the model's failures — the agent does not pass every item.
- [ ] Every criterion evaluates outcomes (with Process reserved for what Outcomes can't prove).
- [ ] All critical events / required outputs have a rubric.
- [ ] Every rubric has all three fields: criterion + justification + evidence.
- [ ] Every criterion is agent-centric, self-contained, objective, atomic, and verifiable.
- [ ] Repeated actions use spot checks (aggregate count + ≥3 specific instances), not one rubric per instance.
- [ ] Multiple same-type write actions get one rubric per ground-truth item — not an "at least N" threshold.
- [ ] Stacked rubrics use OR-logic correctly when multiple outcomes are valid.
- [ ] Must-not-happen behaviors are penalty items (0/−1/−2/−3), written as positive statements; no double negatives.
- [ ] Any must-not-happen behavior is covered by a penalty item.
- [ ] Calculated/rounded numbers use "approximately"; counts, IDs, and dates use exact values.
- [ ] Fuzzy values include examples + "(or similar)."
- [ ] No rubric penalizes a valid alternative solution path.
- [ ] Every NOT-PRESENT criterion is justified in all three areas — any that can't be are deleted.
- [ ] Every important ask in the prompt is covered, with no big gaps or overlaps.
- [ ] The gate (must-pass) set is small, objective, and covers the non-negotiables; nothing subjective is in the gate.
- [ ] Every item declares category, grading_method, score type, weight, and dependencies.
- [ ] Expert-Assessment items use distinct, falsifiable scored bands.
- [ ] Penalties only subtract (0/−1/−2/−3); anything that must fail the run is a gate item instead.

## Quick reference — key terms

| Term | What it means |
|---|---|
| Objective Compliance | Rubric category — did the agent do the concrete, verifiable thing correctly (right action, content, facts)? Binary 0/1. Sub-types 1.1 / 1.2 / 2.1. |
| Expert Assessment | Rubric category — is the work actually good / would a senior professional trust it? Scored on the fixed −1…+1 band scale (this is where partial credit comes from). |
| Process | Rubric category — did the agent work soundly along the way, verified from the trajectory? Optional and rare. |
| Outcome | Collective shorthand for Objective Compliance + Expert Assessment (everything that isn't Process). |
| Gate (must-pass) | The small set of objective, non-negotiable criteria that decide Pass/Fail — all must pass, regardless of weight. |
| Partial credit | The weighted-average quality score from the non-gate criteria; diagnostic only, never decides Pass/Fail. |
| Band | A discrete score level on an Expert-Assessment item (from the fixed scale), each with a label + a falsifiable description. |
| Penalty | A subtract-only item (0 / −1 / −2 / −3) for must-not-happen behavior (e.g., fabrication). |
| Weight | A positive integer (1–3) setting how much a criterion counts toward partial credit. |
| Per-item fields | The five fields every rubric declares: category, grading_method, score type, weight, dependencies. |
| grading_method | How a criterion is graded: deterministic (exact/code check) or LLM judge. |
| Score type | discrete / continuous / programmatic. |
| Dependencies | What the judge reads to grade an item: trajectory, produced artifact / final environment state, or a reference (gold source). |
| Pass@5 | Difficulty metric — the share of runs (Gemini checkpoint, fully-specified prompt) over the model trajectories that clear the gate; must be under 30%. |
| Golden solution (GTFA) | The correct outcome (ground-truth final answer) you establish for the task (LLM assistance is fine); your reference for writing rubrics. |
| Agent trajectory | Collective term for the recorded agent runs (model, silver, and clean trajectories). |
| Model trajectory | The recorded agent run(s) on the fully specified prompt; where the Pass@5 difficulty gate is measured. |
| Silver trajectory | The recorded agent run on the under-specified prompt, guided with hints (expert-guided) — your source of truth for the rubric. |
| Clean trajectory | The silver trajectory reproduced without hints — the same trajectory run without the help of hints. |
