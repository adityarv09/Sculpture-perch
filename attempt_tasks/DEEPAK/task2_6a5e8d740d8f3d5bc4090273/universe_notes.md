# Universe exploration notes (Harmony Games)

Verified directly against `Scepture data copy/<schema>/<table>.json`. Every number below was
counted from the raw files, not taken from the MANIFEST or the evaluator README.

## Hard constraints that shape any task here

### 1. There is no way to send email

The tool catalog (`Tools/5_Server_Tools_Details.json`, 276 tools) has 27 gmail tools and NOT ONE
of them sends, composes, drafts, or replies to a message. Gmail is read plus label, trash,
archive and delete only. Searching the whole catalog for send, compose or draft returns only
`slack_send_message`, `slack_send_message_draft` and `slack_list_drafts`.

Consequence: email is an evidence source, never a deliverable. Any "tell leadership" step has to
resolve to Slack, or be phrased method-agnostically. ADITYA task1 handles this correctly, its
rubrics say "any direct written channel available" rather than naming email.

Write actions actually available: Slack post and DM, Linear create and update issue, Confluence
create and update page plus comment, Google Docs create and update, Sheets create and update,
Drive create and move, Trello cards, GitHub branch, file and PR.

### 2. The persona is effectively forced to Robert

Only two named mailboxes carry real mail, and only one reaches 2026:

| mailbox | total | sent | by year |
|---|---:|---:|---|
| robert@harmonygames.co | 19,192 | 114 | 2023: 2,561 / 2024: 8,573 / 2025: 7,199 / 2026: 859 |
| victor.barnes@harmonygames.co | 4,370 | 15 | 2023: 524 / 2024: 2,819 / 2025: 1,027 |

The other six mailboxes are placeholder tokens (EMPLOYEE_xxxx, SVC_xxxx). Victor's mailbox is
about 78 percent automated build notices from one service address and stops on 2025-04-15, so he
cannot carry a task dated 2026. Victor is an Art person, Linear shows issues assigned to
`usr_Victor Barnes` on team_ART.

ADITYA task1 also used Robert, so this task has to differ by scenario, not by persona.

### 3. Data recency, and what sits after the universe date

Last substantive activity per service:

- Slack: 2026-02 (3,081 messages), after 2026-01 (10,650)
- Gmail, Robert: 2026-02-13
- GitHub pull requests: 2026-02-22
- Confluence: 2026-01-29
- Linear: 2026-01-28
- Trello: 2025-11-13

The fixed universe date is 2026-01-27. Slack, Linear and Confluence all run right up to it, so the
universe is live as of that date. Note the reverse hazard instead: roughly 3,873 substantive Slack
messages, 88 GitHub pull requests, 2 Linear issues and 1 Confluence page are dated AFTER
2026-01-27, including the entire Feb 2026 studio wind-down thread. That material is in the future
relative to the agent and must not be treated as already-happened.

### 4. The 708 Slack rows dated 2026-07-30 are export artifacts, not content

They all sit in `FC:` file-comment channels, all carry an empty `text`, and all have a null
`user_id`. Their `ts` decodes to 2026-07-30T12:37 which is the extract moment, six months past the
universe date. They are noise and must not be treated as live activity.

### 5. The live 2026 narrative is the studio wind-down

Robert's 2026 mail and the `executives` Slack channel both end on the shutdown: "Combo Fighter
Data and Harmony Games Shut-Down", "Harmony Games wind-down support request", "Sunset -
Dissolution Services Agreement SOW", repeated "Termination of Independent Contractor Agreement",
"Closing Harmony Games Inc.'s file", and "Singular - Past Due Invoices". In the executives channel
on 2026-02-11 Leonard Hayes settles on a wind-down vendor at roughly 15K, plans to auction the IP,
and expects the whole thing to take four to six weeks.

## Inventory

Connectors with data: Confluence, Contacts, Gdocs, Gdrive, GitHub, Gmail, Gsheets, Linear, Slack,
Trello. Empty: GCalendar, Google Slides, Snowflake, github issues/releases/tags, linear_comments,
slack drafts/scheduled/emojis, drive_sheets, public._changelog.

Confluence: 31 pages across 4 spaces (ENG 14, PROD 9, OPS 5, COMPANY 3).
Linear: 3,852 issues, 296 open, teams ENG 2,331 / ZOM 657 / ART 597 / DES 247 / EPI 20.
Slack: 985 channels, 586,319 messages. Named channels of interest: `executives`, `zombie-ops`,
`live-incidents`, `zombie-bugs`, `god-bugs`, `issuefeed`, `analytics`, `builds`, `company-internal`,
`prototype`, `zombie-match3d`. `submission-blockers` is archived.
Docs 67, Sheets 26, Drive files 53,702, GitHub 16 repos and 2,629 pull requests.

## Known incident set (recurring across Confluence, Linear and Slack)

- Nov 2024 quest incident, population and reset regression
- May 2025 font and asset download stall, frozen on splash at about 22 percent
- Jun 2025 device-ID wipe, saves orphaned, players dropped to level 1
- Jul 2025 live-ops scheduler outage, roughly two weeks, events did not fire
- Aug 2025 Plague Race scoring and matchmaking bug, skewed leaderboard settlement

These are documented in `page_support_playbook`, `page_liveops_calendar`, `page_live_ops_engine`
and `page_quest_postmortem`, and they have matching open Linear bugs and Slack threads.

## Status

Exploration complete. Scenario chosen: consolidated live-incident and player-compensation ledger.
Both prompts written and passing the prompt evaluator's mechanical checks. Golden solution,
rubrics, verifier and metadata still to do. No agent runs are possible from here, so the Pass@5
gate, the silver trajectory and the clean trajectory remain open on the platform.
