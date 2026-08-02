# Harmony Games — Task Evaluators

Evaluator prompts for building and QC-ing Harmony Games tasks, adapted from the reference `Evals/` set (originally written for the StarPM universe) to this project's universe and framework. Each file is a self-contained evaluator prompt: feed it the task artifacts and it produces a PASS/FAIL verdict with evidence.

They follow `attempter_guidelines.md` (the 5 Pillars, persona and prompt rules) and `full_rubrics_guidelines.md` (rubric categories, gate vs partial credit, weights, scored bands, Pass@5).

## The evaluators (run in order)

| File | When to run | What it checks |
|---|---|---|
| `0_Injection_Quality_Eval.md` | After editing the universe, before authoring | Structural, ID, temporal, cross-service, naturalness, reachability, and pre-solve integrity of any universe edits + a 5-pillar difficulty read |
| `1_Prompt_Eval.md` | After writing the two prompts | Persona, naturalness, anti-patterns, dual-prompt consistency, unique ground truth, feasibility, truthfulness, cross-service, clarity, date alignment, pillar profile, difficulty |
| `3_Rubrics_Eval.md` | After writing rubrics | Objective Compliance / Expert Assessment / Process categories, gate vs partial credit, weights, scored bands, penalties, atomicity, self-containment, correctness, coverage, phrasing |
| `4_Verifier_Fails_Eval.md` | After the Pass@5 verifier runs | Diagnoses each failing rubric across runs: Rubric Invalid / Judge Error / Legitimate Fail / Excluded, and the honest Pass@5 |
| `5_Submission_Gate_Eval.md` | Final gate before submission | 7 defect families (impossible-with-connectors, persona/date, process/category, broken/over-strict, tool-output deps, QC patterns, pillar & difficulty) — zero tolerance |

*(File numbering mirrors the reference set; there is no `2_`.)*

## Universe facts every evaluator relies on

- **Company:** Harmony Games (mobile game studio; flagship *Zombie Match 3D*, ships as *Puzzles vs Zombies*).
- **Fixed universe date ("today" for the agent):** **2026-01-27**. Do not confuse this with the extract-complete date of 2026-07-30 recorded in `Scepture data/MANIFEST.md` — that is when the data was pulled, not when the universe is set.
- **Some data is future-dated relative to 2026-01-27 and is OFF-LIMITS as task material.** Rows dated after the universe date: about 3,873 substantive `slack_messages` (the whole Feb 2026 studio wind-down thread), 88 `github_pull_requests`, 2 `linear_issues`, 1 `confluence_page`. A prompt, rubric or golden solution that treats any of it as already-happened is a future-as-past defect. The 708 Slack rows stamped 2026-07-30 are export artifacts with empty `text` and null `user_id`, not content.
- **Data location:** `Scepture data/<schema>/<table>.json` — one flat JSON array per table. Verify every claim/value against these raw files.
- **12 connectors:** Confluence, Contacts, GCalendar, Google Docs, Google Drive, GitHub, Gmail, Google Sheets, Google Slides, Linear, Slack, Trello.
- **Tool ground truth:** `Tools/5_Server_Tools_Details.json` — the authoritative catalog of **276 tools + parameters** across 13 connectors (the 12 above plus Snowflake). Every evaluator checks tool/parameter existence against this file.
- **Tool exists ≠ data exists.** The catalog lists tools for gcal, gslides, Linear comments, GitHub issues/releases, Slack drafts/scheduled, and Snowflake — but those **data tables are empty** in this universe (per `MANIFEST.md`). So any task/rubric depending on them is infeasible on **data** grounds (nothing to read, and a write has no context to anchor/grade), even though the tool call is technically defined:
  - GCalendar (calendars + events) → **no scheduling / calendar invites** (`gcal_*` tools exist, data empty)
  - Google Slides → **no slide decks** (`gslides_*` tools exist, data empty)
  - `linear_comments` → **no Linear ticket comments** (`linear_create_comment` exists; updating the issue itself is fine)
  - `github_issues` / `github_releases` / `github_tags` → **GitHub activity is PRs, commits, reviews** — not issues/releases (tools exist, data empty)
  - `slack_drafts` / `slack_scheduled_messages` / `slack_emojis` → **no drafts / scheduled Slack messages** (`slack_schedule_message` etc. exist, data empty)
  - Snowflake → **`snowflake_*` tools exist in the catalog, but this universe has no Snowflake data**
  - `public._changelog` → empty until the author logs universe edits
- **Two tables too large to load whole** — filter them: `slack/slack_messages.json` (586k rows), `gmail/gmail_messages.json` (24.7k rows).
- **Only 8 Gmail mailboxes** (`gmail/gmail_users.json`) — a persona can only *send* email if they own one.

## Framework facts every evaluator relies on

- **5 Pillars:** P1 Ambiguity & Underspecification, P2 Distributed & Dynamic Context, P3 Adaptive Error Handling, P4 Long-Horizon, P5 Holistic & Responsible Evaluation. Each task targets a pillar profile; evaluators check the intended bands are hit without off-profile over-build.
- **Two prompts per task:** a fully specified prompt (where Pass@5 difficulty is measured) and an under-specified prompt (which exercises the pillars). Both must drive to the same ground-truth end-state.
- **Rubric categories:** Objective Compliance (1.1 write / 1.2 content / 2.1 findings, binary 0/1), Expert Assessment (scored on the fixed −1…+1 band scale — the source of partial credit), Process (optional, rare, three-condition test).
- **Scoring:** a small objective **gate** (all must pass → run passes) + **partial credit** (weighted average, diagnostic only). Weights 1–3. **Penalties** are subtract-only (0 / −1 / −2 / −3) for must-not-happen behavior.
- **Difficulty bar:** **Pass@5 < 30%** on the Gemini checkpoint using the fully-specified prompt.

## Per-task artifacts these evaluators consume

`prompt.txt` (both prompts + any hints), `golden_solution.txt`, `rubrics.json`, `rubric_verifier.txt`, `task_metadata.md`, and `gemini_fully_specified agent runs/trajectory-run-N.json`.
