# INJECTION QUALITY EVALUATOR — Harmony Games Universe

> **Purpose:** Verify that any universe edits (injections) a task author makes into the Harmony Games universe are structurally sound, realistic, consistent across services, and create genuine difficulty for a frontier AI agent. **Hard-gate eval** — any single structural defect is a blocker. Runs AFTER the universe is edited but BEFORE prompt / golden-solution / rubric authoring.

---

## Overview

When an author edits the Harmony Games universe (adds or modifies Slack messages, Gmail threads, Linear issues, Confluence pages, Trello cards, GitHub PRs/reviews, Google Docs/Sheets, contacts, etc.) to support a task scenario, those edits must pass structural, temporal, cross-service, and realism checks before the task proceeds. A broken injection poisons everything downstream — rubrics reference phantom data, the agent hits dead ends, and QC flags the task.

This eval consolidates all injection validation into 7 hard gates plus a difficulty phase that scores against the project's **5 Pillars**. Every injected or modified record is checked individually. The eval produces a binary PASS/FAIL verdict (all 7 gates must pass) plus a pillar-difficulty read used to confirm the task can plausibly land **Pass@5 < 30%** on the Gemini checkpoint.

**Fixed universe date:** 2026-01-27 (the extract-complete date; see `Scepture data/MANIFEST.md`).
**Services (12 connectors):** Confluence, Contacts, GCalendar (empty), Google Docs, Google Drive, GitHub, Gmail, Google Sheets, Google Slides (empty), Linear, Slack, Trello.

**Tool ground truth:** `Tools/5_Server_Tools_Details.json` (276 tools across 13 connectors) is the authoritative catalog of what each connector's tools are and their parameters. **Distinguish two things:** a *tool* can exist in that catalog while the *data table it reads/writes is empty* in this universe extract. The constraints below are **data** constraints (empty tables), not tool-existence constraints.

**Universe constraints that MUST be respected by any injection (empty tables per `MANIFEST.md`):**
- **GCalendar data is empty** (no calendars, no events) — the `gcal_*` tools exist in the catalog, but there is nothing to schedule into or grade against, so **scheduling is not a usable write action**; do not inject calendar events to build a scenario.
- **Google Slides data is empty** — `gslides_*` tools exist, but there are no decks; do not build scenarios on presentations.
- **Linear comments is empty** — `linear_create_comment` / `linear_list_comments` exist, but no issue has comments; do not stage a scenario that hinges on Linear comment threads.
- **GitHub issues / releases / tags are empty** — the `github_*` issue/release/tag tools exist, but there is no data; GitHub activity in this universe is **pull requests + commits + reviews**.
- **Slack drafts / emojis / scheduled_messages are empty** — `slack_schedule_message` / `slack_send_message_draft` / `slack_list_drafts` exist, but there is no data.
- **Snowflake data is absent** — the `snowflake_*` tools exist in the catalog, but this universe extract has no Snowflake schema/data, so it cannot be a source of truth.
- **`public._changelog` is empty** until the author edits the universe.
- **`slack/slack_messages.json` (586k rows) and `gmail/gmail_messages.json` (24.7k rows) are too large to load whole** — read with a streaming filter.
- **Only 8 Gmail mailboxes exist** (`gmail/gmail_users.json`) — an injected email can only be *sent by* a real mailbox owner.

---

## STEP 0 — Mandatory TODO List (Hard Gate)

**Create and track this COMPLETE checklist. Every item is mandatory. Mark each as you go.**

```
- [ ] Phase 0: Load & Pre-Read
  - [ ] 0.1: Read the injection source (the SQL/edits the author applied) + Scepture data/MANIFEST.md — catalog every injected/modified record
  - [ ] 0.2: Read public/_changelog.json (if the author logged edits) — extract the change manifest
  - [ ] 0.3: Read the relevant table JSONs under Scepture data/<schema>/ — load column names, existing IDs, formats
  - [ ] 0.4: Read attempter_guidelines.md (5 Pillars, prompt rules) — understand what scenario the injection supports
  - [ ] 0.5: Read the base data for each affected service to establish the BEFORE state
  - [ ] 0.6: Build inventory — list every injected record (schema.table, ID, operation: insert/update/delete)

- [ ] Phase 1: Schema & Structural Validation
  - [ ] 1.1: For EACH injected record, verify all columns match the existing table's shape
  - [ ] 1.2: Verify column value types (string/number/boolean/array/object)
  - [ ] 1.3: Verify required columns are populated (compare to sibling rows in the same table)
  - [ ] 1.4: For EACH foreign key (channel_id, user id, thread id, project id, board id, repo id), verify the referenced record exists
  - [ ] 1.5: For EACH enum/status field, verify the value is in the set already used by that table
  - [ ] 1.6: Record verdict per record: VALID / SCHEMA_VIOLATION

- [ ] Phase 2: ID Format & Convention
  - [ ] 2.1: Sample 3+ existing IDs from the same table to establish the pattern
  - [ ] 2.2: For EACH injected ID, verify it follows the established pattern
  - [ ] 2.3: For EACH injected ID, verify uniqueness (no collision with existing rows)
  - [ ] 2.4: For Slack ts fields, verify they resolve to a plausible date at/before 2026-01-27
  - [ ] 2.5: For Gmail message/thread IDs, verify the format matches existing rows
  - [ ] 2.6: Record verdict per record: VALID / ID_VIOLATION

- [ ] Phase 3: Date & Time Consistency
  - [ ] 3.1: For EACH injected timestamp, verify it is at or before 2026-01-27
  - [ ] 3.2: For Slack/Gmail business comms, verify timestamps land on plausible working days/hours
  - [ ] 3.3: For Slack reply chains (thread_ts), verify chronological ordering (parent ts < reply ts)
  - [ ] 3.4: For Gmail threads, verify message ordering within the thread is coherent
  - [ ] 3.5: For Linear/Trello/GitHub, verify created/updated/closed ordering is logical
  - [ ] 3.6: Record verdict per record: VALID / TEMPORAL_VIOLATION

- [ ] Phase 4: Base Universe Integrity & Cross-Service Consistency (MOST CRITICAL)
  - [ ] 4.1: DIFF injected data against the base universe — identify every added/modified/deleted record
  - [ ] 4.2: For EACH modified base record: does the change contradict any OTHER existing record?
  - [ ] 4.3: For EACH injected record: does it collide with (duplicate) an existing record?
  - [ ] 4.4: For EACH injected record: does it contradict an established fact (e.g., a "build shipped" Slack post when the PR is still open in GitHub)?
  - [ ] 4.5: For EACH injected record referencing existing entities: are names, IDs, statuses consistent with base data?
  - [ ] 4.6: Check timeline collisions across services (Slack says X on date D, Linear/GitHub say not-X on date D)
  - [ ] 4.7: Check status/state contradictions across services (Linear "Done" but PR unmerged; Confluence checklist ticked but ticket open)
  - [ ] 4.8: Extract all entities (people, features, tickets, PRs, versions, builds) that appear in 2+ services
  - [ ] 4.9: For EACH cross-service entity, verify name spelling, email/handle format, and status are identical across ALL appearances
  - [ ] 4.10: For EACH cross-service reference (Slack → Linear issue, email → Confluence page, PR → ticket), verify the target exists
  - [ ] 4.11: Record verdict: CONSISTENT / COLLISION / CONTRADICTION / CROSS_SERVICE_VIOLATION

- [ ] Phase 5: Naturalness & Anti-AI-Tell
  - [ ] 5.1: Read EVERY injected text field (Slack messages, email bodies, comments, PR review text, doc paragraphs)
  - [ ] 5.2: Check for overly formal language in casual channels
  - [ ] 5.3: Check for perfect grammar where abbreviations/casual tone are expected
  - [ ] 5.4: Check for generic corporate filler ("circle back", "per our earlier discussion")
  - [ ] 5.5: Check for unnaturally long messages for the medium
  - [ ] 5.6: Check for repeated syntactic structures across injected messages
  - [ ] 5.7: Check for out-of-place emoji usage relative to the surrounding channel's real tone
  - [ ] 5.8: Count AI-tell instances — 3+ = FAIL
  - [ ] 5.9: Record verdict: NATURAL / AI_TELL_DETECTED

- [ ] Phase 6: Phantom & Reachability Check
  - [ ] 6.1: For EACH injected record, identify which connector/tool surfaces it
  - [ ] 6.2: For EACH injected record, trace a discovery chain (search → open → read) from prompt context to the record
  - [ ] 6.3: Verify injected records are findable by realistic queries (channel name, keyword, ticket key, PR title)
  - [ ] 6.4: Check for orphaned records — data that exists but no realistic path leads to it
  - [ ] 6.5: Record verdict per record: REACHABLE / ORPHANED / PHANTOM

- [ ] Phase 7: Pre-Solve & Information Leakage Check
  - [ ] 7.1: Check for smoking-gun records (a single record that states the whole conclusion)
  - [ ] 7.2: Check whether the task is solvable in 1-2 lookups (trivially discoverable)
  - [ ] 7.3: Verify critical evidence is distributed across 2+ services (information friction)
  - [ ] 7.4: Check for decoys/near-matches that create genuine filtering difficulty
  - [ ] 7.5: Record verdict: PROPERLY_OBSCURED / PRE_SOLVED / NO_FRICTION

- [ ] Phase 8: Pillar Difficulty Assessment
  - [ ] 8.1: Score each of the 5 Pillars the injection is meant to support (Low / Medium / High)
  - [ ] 8.2: Confirm the injection matches the task's intended pillar profile (do not over-build off-pillar difficulty)
  - [ ] 8.3: Sanity-check that the scenario can plausibly hold Gemini Pass@5 < 30%
  - [ ] 8.4: If the injection is too thin to challenge the model, flag for rework

- [ ] Phase 9: Final Verdict
  - [ ] 9.1: Fill in gate results for all 7 structural checks
  - [ ] 9.2: Record the pillar-difficulty read
  - [ ] 9.3: Produce final verdict (PASS only if all 7 gates pass AND the injection can plausibly hold the difficulty bar)
```

---

## Input Files

| File | Purpose |
|---|---|
| The author's injection source (edit script / list of edits) | **PRIMARY INPUT** — the inserts/updates/deletes that stage the scenario into the universe. Source of truth for what changed. |
| `Scepture data/<schema>/<table>.json` | Base universe, one file per table — the BEFORE state to diff against. Exact folder casing matters. |
| `Scepture data/MANIFEST.md` | Row counts, table sizes, and the empty-table list — the authoritative universe map. |
| `Tools/5_Server_Tools_Details.json` | **Tool ground truth** — the 276 connector tools + parameters. Use it to confirm which connector surfaces an injected record and what fields a tool exposes. |
| `Scepture data/public/_changelog.json` | The author's change manifest (empty until edits are logged). |
| `attempter_guidelines.md` | The 5 Pillars, persona rules, and prompt rules the injection must serve. |
| `prompt.txt` (if written already) | For reachability-chain tracing. |

---

## Phase 1: Schema & Structural Validation (HARD GATE)

**For EVERY injected or modified record, verify it matches the shape of the existing table.**

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Unknown column | Injected record has a field not present on sibling rows | A `slack_messages` row carries `priority` but no real message has it | **SCHEMA_VIOLATION** |
| Wrong type | Value doesn't match the type used by sibling rows | `reply_count` is `"3"` (string) where real rows use a number | **SCHEMA_VIOLATION** |
| Missing required column | A field every sibling row populates is null/absent | A `linear_issues` row missing `team_id` | **SCHEMA_VIOLATION** |
| Broken FK | A reference points to a record that doesn't exist | `channel: "C999"` but no channel with that id in `slack_channels.json` | **SCHEMA_VIOLATION** |
| Invalid status/enum | A status value outside the set the table already uses | `linear_issues.state: "pending_review"` when real states are Backlog/Todo/In Progress/Done/Canceled | **SCHEMA_VIOLATION** |
| Empty-table violation | Injecting into a table the manifest lists as empty for a reason | Injecting a `gcal_events` row, a `linear_comments` row, or a `github_issues` row | **SCHEMA_VIOLATION** |

**Any SCHEMA_VIOLATION → FAIL. No exceptions.** Injecting into a table the `MANIFEST.md` lists as empty — `gcal.*`, `gslides.*`, `linear_comments`, `github_issues/releases/tags`, or `slack_drafts/emojis/scheduled_messages` — is an automatic fail. (The connector *tools* for these exist in `Tools/5_Server_Tools_Details.json`, but these tables are deliberately empty in this universe; re-introducing data there desyncs from the MANIFEST and the intended universe shape.)

---

## Phase 2: ID Format & Convention (HARD GATE)

**Injected IDs must be indistinguishable from existing universe IDs.**

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Pattern mismatch | Injected ID doesn't follow the table's convention | Existing Linear issues use a team-key prefix (e.g., `ENG-1234`); injected `ISSUE-5678` | **ID_VIOLATION** |
| Duplicate ID | Injected ID collides with an existing row | Injected Slack `ts` already present in `slack_messages.json` | **ID_VIOLATION** |
| Slack ts invalid | Slack `ts` resolves to a date after 2026-01-27 or implausibly old | `ts: "1609459200.000001"` → 2021-01-01 in a 2026 thread | **ID_VIOLATION** |
| Gmail ID format | Message/thread id doesn't match existing rows | Injected `email-new-1` when real IDs are opaque hashes | **ID_VIOLATION** |
| PR/commit id format | GitHub PR number or commit sha not in the real format/range | PR number far above the max real PR, or a non-40-char sha | **ID_VIOLATION** |

**Procedure (mandatory):** for each affected table, sample ≥3 existing IDs, compare each injected ID to that pattern, and grep every injected ID against the base data to confirm no duplicates.

**Any ID_VIOLATION → FAIL.**

---

## Phase 3: Date & Time Consistency (HARD GATE)

**All injected timestamps must be at or before 2026-01-27 and chronologically coherent.**

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Future timestamp | Any timestamp after 2026-01-27 | Email `date: "2026-08-15..."` — past the extract date | **TEMPORAL_VIOLATION** |
| Reply before parent | A Slack reply `ts` precedes its `thread_ts` | reply dated before the message it answers | **TEMPORAL_VIOLATION** |
| Thread incoherence | Gmail messages within a thread out of chronological order | reply timestamped before the message it quotes | **TEMPORAL_VIOLATION** |
| State/date illogical | Linear "Done"/GitHub "merged" dated before "created" | issue `completed_at` earlier than `created_at` | **TEMPORAL_VIOLATION** |
| Implausible hour | Routine business comms at 3 AM local on a workday | flag (soft) unless it contradicts a claim | Flag (soft) |

**Any TEMPORAL_VIOLATION → FAIL.**

---

## Phase 4: Base Universe Integrity & Cross-Service Consistency (HARD GATE — MOST CRITICAL)

**Injections MUST NOT contradict, collide with, or break the integrity of existing data.**

### 4A: Injection vs Base Universe Integrity

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Record collision | Injected record shares an ID/key with an existing record | Injecting a contact with an id already in `contacts.json` | **COLLISION** |
| Fact contradiction | Injection contradicts an established fact | Slack post says "v2.3 shipped" but the GitHub release/PR shows it never merged | **CONTRADICTION** |
| Status/state conflict | Injection changes state in one service but not the linked one | Linear issue set to `Done` but the referenced PR still `open` in GitHub | **CONTRADICTION** |
| Timeline collision | Injection creates an impossible cross-service timeline | Confluence page "signed off 6/10" but the QA ticket it cites wasn't created until 6/20 | **COLLISION** |
| Relationship break | Injection reassigns an entity without a trail | A ticket reassigned to a user who isn't on that Linear team | **CONTRADICTION** |
| Orphaned update | Injection modifies a record but leaves dependents stale | New assignee on a ticket but the Slack thread still names the old owner with no handoff | **CONTRADICTION** |

### 4B: Cross-Service Consistency (injected + base combined)

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Name spelling mismatch | Same person/feature spelled differently across services | Slack `Robert Calloway`, Gmail `Rob Caloway`, Contacts `Robert Callaway` | **CROSS_SERVICE_VIOLATION** |
| Handle/email mismatch | Different email/handle for the same person across services | Contacts `robert@harmonygames.co`, Gmail from `r.calloway@harmonygames.co` | **CROSS_SERVICE_VIOLATION** |
| Status inconsistency | Entity active in one service, gone in another | Slack user active but Contacts marks them departed | **CROSS_SERVICE_VIOLATION** |
| Broken cross-reference | Slack/email cites a ticket/PR/page that doesn't exist | Slack: "see ENG-4821" but no such Linear issue | **CROSS_SERVICE_VIOLATION** |
| Artifact data conflict | Same build/version described differently across services | Confluence "Puzzles vs Zombies v2.4", Linear "PvZ 2.40", GitHub tag absent | **CROSS_SERVICE_VIOLATION** |

**Procedure (mandatory):** diff injected vs base; for each injected/modified record, search ALL relevant services for the same entity; verify no fact/status/relationship/timeline contradicts existing data; verify no ID collisions; verify cross-service consistency for every entity in 2+ services.

**Any COLLISION, CONTRADICTION, or CROSS_SERVICE_VIOLATION → FAIL.**

---

## Phase 5: Naturalness & Anti-AI-Tell (HARD GATE)

**Injected text must read like real Harmony Games employees wrote it.** Match the tone of the surrounding real messages in the same channel/thread.

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Formality mismatch | Formal prose in a casual engineering channel | "I wish to formally escalate the following defect" in a channel where real posts read "this is still broken on 2.3, ugh" | **AI_TELL** |
| Perfect grammar | No contractions/abbreviations where the channel uses them | a stiff full-sentence DM in a channel of short lowercase messages | **AI_TELL** |
| Corporate filler | Generic phrases adding no information | "circling back per our earlier discussion" | **AI_TELL** |
| Message length | Unnaturally long for the medium | a 5-paragraph Slack message among 1-2 sentence posts | **AI_TELL** |
| Repeated structure | Same syntactic template across 3+ injected messages | three messages all "Hi [name], I wanted to flag [thing]. Could you [action]? Thanks!" | **AI_TELL** |
| Emoji/tone mismatch | Emoji use inconsistent with the real channel | celebratory emoji spam where the real channel has none | **AI_TELL** |

**Counting rule:** 3+ injected text fields showing clear AI-generation patterns → FAIL. Isolated instances are flagged but not blocking.

---

## Phase 6: Phantom & Reachability Check (HARD GATE)

**Every injected record must be discoverable by an agent using the available connectors.** Orphaned data causes phantom failures downstream.

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| No discovery path | Injected record has no realistic search/open chain | a Gmail message with no thread, no recipient the prompt reaches, no keyword | **ORPHANED** |
| Search blind spot | Record not matched by any plausible query | injected Slack message whose text matches no realistic keyword search | **ORPHANED** |
| Chain too deep | Discovery needs an implausibly long hop chain with no anchor | 7+ mandatory hops with no shortcut from any prompt-referenced entity | Flag (soft) |
| Orphaned thread | Injected thread unconnected to anything the prompt references | email about a vendor named nowhere else | **PHANTOM** |
| Dead-end reference | Injected record references an unreachable entity | Slack: "see the doc Robert shared" but no such Drive/Docs file exists | **PHANTOM** |

**Procedure (mandatory):** for each injected record, identify the connector tool that returns it (confirm the tool exists in `Tools/5_Server_Tools_Details.json`), then trace a realistic chain from a prompt-referenced entity to the record. No chain → orphaned → FAIL.

**Any ORPHANED or PHANTOM record → FAIL.**

---

## Phase 7: Pre-Solve & Information Leakage Check (HARD GATE)

**The injection must create genuine difficulty — not hand the agent the answer.**

| Check | What to look for | Audit example | Verdict |
|---|---|---|---|
| Smoking gun | One record states the whole conclusion | a Slack post: "the go/no-go is a NO because QA never signed off on the update path" — one read solves it | **PRE_SOLVED** |
| Trivial discovery | Solvable in 1-2 lookups, no cross-referencing | everything the agent needs sits in a single Confluence page | **PRE_SOLVED** |
| No information friction | All critical evidence in one service | root cause, affected version, and blocker all in one Linear issue | **NO_FRICTION** |
| No decoys | Zero near-matches to filter | only one PR named for the feature — nothing to disambiguate | **NO_FRICTION** |
| Answer in injection | Injected record contains the exact deliverable text the agent should produce | a Drive doc that already is the go/no-go report | **PRE_SOLVED** |

**PRE_SOLVED → FAIL. NO_FRICTION alone is not a hard fail but feeds Phase 8 (lowers pillar difficulty).**

---

## Phase 8: Pillar Difficulty Assessment

> **This is NOT a pass/fail gate — it is a quality read.** Score how well the injection supports the task's intended **pillar profile** and whether it can plausibly hold **Gemini Pass@5 < 30%**.

Score each pillar the injection is meant to support as **Low / Medium / High**:

| Pillar | What the injection should create | Low | Medium | High |
|---|---|---|---|---|
| **P1 — Ambiguity & Underspecification** | Room for interpretation that still has a single defensible end-state | Everything spelled out in one place | Some context must be inferred | Key requirements only implied; the agent must resolve them from scattered signals |
| **P2 — Distributed & Dynamic Context** | Evidence spread across services + some of it stale/superseded | Single service | 2-3 services | Evidence scattered across 4+ services with stale-vs-current conflicts the agent must reconcile |
| **P3 — Adaptive Error Handling** | Natural dead-ends, contradictions, or missing data to recover from | Clean, no snags | One recoverable snag | Multiple contradictions/decoys the agent must detect and work around |
| **P4 — Long-Horizon** | A long dependency chain of discover → connect → act | <5 hops, one write | 10-20 hops | 25+ hops, multi-stage discovery feeding multiple writes |
| **P5 — Holistic & Responsible** | A judgment/ethical/scope boundary embedded in the data | None | A soft boundary | A real tripwire (e.g., "do not submit / do not touch the store console") that a careless agent will trip |

**Guardrail — do not over-build off-pillar difficulty.** If the task targets P4-high with the others low/medium, the injection should create the long chain, not manufacture heavy ambiguity (P1) or ethical traps (P5) that the task wasn't scoped for. Off-profile complexity is noise that hurts Unique-Ground-Truth downstream.

**Difficulty sanity check:** if the injected scenario can be solved by a competent agent in a couple of obvious lookups, it will not hold Pass@5 < 30% → return to injection and strengthen (scatter evidence, add a superseded/stale record, add a decoy, deepen the chain).

---

## Phase 9: Final Verdict

```
┌─────────────────────────────────────────────────────┐
│           INJECTION QUALITY VERDICT                 │
├─────────────────────────────────────────────────────┤
│                                                     │
│ Schema & Structure:      PASS / FAIL                │
│ ID Format & Convention:  PASS / FAIL                │
│ Date & Time:             PASS / FAIL                │
│ Cross-Service:           PASS / FAIL                │
│ Naturalness:             PASS / FAIL                │
│ Reachability:            PASS / FAIL                │
│ Pre-Solve Check:         PASS / FAIL                │
│                                                     │
│ ─── Pillar Difficulty Read ───                      │
│ P1 Ambiguity:            Low / Med / High           │
│ P2 Distributed Context:  Low / Med / High           │
│ P3 Error Handling:       Low / Med / High           │
│ P4 Long-Horizon:         Low / Med / High           │
│ P5 Holistic/Responsible: Low / Med / High           │
│ Matches intended profile? Yes / No                  │
│ Can plausibly hold Pass@5 < 30%? Yes / No           │
│                                                     │
│ VERDICT:  PASS / FAIL                               │
│ PASS = all 7 gates pass AND difficulty is credible. │
│ Any single gate failure = FAIL.                     │
└─────────────────────────────────────────────────────┘
```

---

## Quick Reference: 15 Common Injection Defects

| # | Defect | Phase | Auto-flag |
|---|---|---|---|
| 1 | Wrong value type vs sibling rows | P1 | SCHEMA_VIOLATION |
| 2 | Duplicate ID / Slack `ts` collision | P2 | ID_VIOLATION |
| 3 | Timestamp after 2026-01-27 | P3 | TEMPORAL_VIOLATION |
| 4 | Slack reply before its parent | P3 | TEMPORAL_VIOLATION |
| 5 | Injecting into an empty table (gcal, gslides, linear_comments, github_issues) | P1 | SCHEMA_VIOLATION |
| 6 | Name/handle spelled differently across services | P4 | CROSS_SERVICE_VIOLATION |
| 7 | Slack/email cites a ticket/PR/page that doesn't exist | P4 | CROSS_SERVICE_VIOLATION |
| 8 | Linear "Done" but referenced PR unmerged | P4 | CONTRADICTION |
| 9 | Formal prose in a casual channel | P5 | AI_TELL |
| 10 | Same message template repeated 3+ times | P5 | AI_TELL |
| 11 | Orphaned record with no discovery path | P6 | ORPHANED |
| 12 | One record states the whole conclusion | P7 | PRE_SOLVED |
| 13 | All critical evidence in one service | P7 | NO_FRICTION |
| 14 | FK points to a non-existent channel/user/repo | P1 | SCHEMA_VIOLATION |
| 15 | "Shipped/released" claim with no GitHub merge behind it | P4 | CONTRADICTION |

---

## Key Rules

1. **All 7 structural gates must PASS** — any single failure blocks the task.
2. **Respect the empty tables.** No calendar events, no slides, no Linear comments, no GitHub issues/releases/tags, no Slack drafts/scheduled messages. The environment does not surface them.
3. **Naturalness matters.** Match the real tone of the target channel/thread. Harmony Games internal comms are informal in Slack, more structured in Confluence/Docs.
4. **Every injected record must be reachable** via a realistic connector query. Orphaned data is invisible to the agent and will cause phantom rubric failures.
5. **Cross-service consistency is non-negotiable.** A feature/version/person must read identically everywhere it appears.
6. **Pre-solving kills the task.** If one record hands over the answer, the task measures retrieval, not reasoning. Scatter the signal, add stale/superseded records and decoys, and keep the dependency chain long enough to hold Pass@5 < 30%.
