-- Full universe data dump
-- Each row: source = 'schema.table', data = to_jsonb of the row
-- Run in the SQL sandbox. NOTE: some tables are very large
-- (slack.slack_messages ~587k, slack.slack_files ~48k, gdrive.drive_files ~54k,
--  gmail.gmail_messages ~25k, gmail.gmail_threads ~21k, github.github_commit_map ~21k).
-- Consider commenting those out or adding LIMITs if the result set is too big.

-- ===== confluence =====
SELECT 'confluence.confluence_attachments', to_jsonb(t) FROM confluence.confluence_attachments t
UNION ALL
SELECT 'confluence.confluence_comments', to_jsonb(t) FROM confluence.confluence_comments t
UNION ALL
SELECT 'confluence.confluence_labels', to_jsonb(t) FROM confluence.confluence_labels t
UNION ALL
SELECT 'confluence.confluence_page_versions', to_jsonb(t) FROM confluence.confluence_page_versions t
UNION ALL
SELECT 'confluence.confluence_pages', to_jsonb(t) FROM confluence.confluence_pages t
UNION ALL
SELECT 'confluence.confluence_spaces', to_jsonb(t) FROM confluence.confluence_spaces t
UNION ALL
SELECT 'confluence.confluence_users', to_jsonb(t) FROM confluence.confluence_users t
UNION ALL

-- ===== contacts =====
SELECT 'contacts.contacts', to_jsonb(t) FROM contacts.contacts t
UNION ALL

-- ===== gcal =====
SELECT 'gcal.gcal_calendars', to_jsonb(t) FROM gcal.gcal_calendars t
UNION ALL
SELECT 'gcal.gcal_events', to_jsonb(t) FROM gcal.gcal_events t
UNION ALL

-- ===== gdocs =====
SELECT 'gdocs.docs_documents', to_jsonb(t) FROM gdocs.docs_documents t
UNION ALL

-- ===== gdrive =====
SELECT 'gdrive.drive_files', to_jsonb(t) FROM gdrive.drive_files t
UNION ALL
SELECT 'gdrive.drive_sheets', to_jsonb(t) FROM gdrive.drive_sheets t
UNION ALL
SELECT 'gdrive.drive_users', to_jsonb(t) FROM gdrive.drive_users t
UNION ALL

-- ===== github =====
SELECT 'github.github_branches', to_jsonb(t) FROM github.github_branches t
UNION ALL
SELECT 'github.github_commit_map', to_jsonb(t) FROM github.github_commit_map t
UNION ALL
SELECT 'github.github_commits', to_jsonb(t) FROM github.github_commits t
UNION ALL
SELECT 'github.github_issues', to_jsonb(t) FROM github.github_issues t
UNION ALL
SELECT 'github.github_labels', to_jsonb(t) FROM github.github_labels t
UNION ALL
SELECT 'github.github_pr_comments', to_jsonb(t) FROM github.github_pr_comments t
UNION ALL
SELECT 'github.github_pull_request_commits', to_jsonb(t) FROM github.github_pull_request_commits t
UNION ALL
SELECT 'github.github_pull_requests', to_jsonb(t) FROM github.github_pull_requests t
UNION ALL
SELECT 'github.github_releases', to_jsonb(t) FROM github.github_releases t
UNION ALL
SELECT 'github.github_repositories', to_jsonb(t) FROM github.github_repositories t
UNION ALL
SELECT 'github.github_review_comments', to_jsonb(t) FROM github.github_review_comments t
UNION ALL
SELECT 'github.github_reviews', to_jsonb(t) FROM github.github_reviews t
UNION ALL
SELECT 'github.github_tags', to_jsonb(t) FROM github.github_tags t
UNION ALL
SELECT 'github.github_timeline_events', to_jsonb(t) FROM github.github_timeline_events t
UNION ALL
SELECT 'github.github_users', to_jsonb(t) FROM github.github_users t
UNION ALL

-- ===== gmail =====
SELECT 'gmail.gmail_attachments', to_jsonb(t) FROM gmail.gmail_attachments t
UNION ALL
SELECT 'gmail.gmail_labels', to_jsonb(t) FROM gmail.gmail_labels t
UNION ALL
SELECT 'gmail.gmail_messages', to_jsonb(t) FROM gmail.gmail_messages t
UNION ALL
SELECT 'gmail.gmail_threads', to_jsonb(t) FROM gmail.gmail_threads t
UNION ALL
SELECT 'gmail.gmail_users', to_jsonb(t) FROM gmail.gmail_users t
UNION ALL

-- ===== gsheets =====
SELECT 'gsheets.sheets_sheets', to_jsonb(t) FROM gsheets.sheets_sheets t
UNION ALL
SELECT 'gsheets.sheets_spreadsheets', to_jsonb(t) FROM gsheets.sheets_spreadsheets t
UNION ALL

-- ===== gslides =====
SELECT 'gslides.slides_page_elements', to_jsonb(t) FROM gslides.slides_page_elements t
UNION ALL
SELECT 'gslides.slides_pages', to_jsonb(t) FROM gslides.slides_pages t
UNION ALL
SELECT 'gslides.slides_presentations', to_jsonb(t) FROM gslides.slides_presentations t
UNION ALL

-- ===== linear =====
SELECT 'linear.linear_comments', to_jsonb(t) FROM linear.linear_comments t
UNION ALL
SELECT 'linear.linear_issues', to_jsonb(t) FROM linear.linear_issues t
UNION ALL
SELECT 'linear.linear_projects', to_jsonb(t) FROM linear.linear_projects t
UNION ALL
SELECT 'linear.linear_team_memberships', to_jsonb(t) FROM linear.linear_team_memberships t
UNION ALL
SELECT 'linear.linear_teams', to_jsonb(t) FROM linear.linear_teams t
UNION ALL
SELECT 'linear.linear_users', to_jsonb(t) FROM linear.linear_users t
UNION ALL

-- ===== public =====
SELECT 'public._changelog', to_jsonb(t) FROM public._changelog t
UNION ALL

-- ===== slack =====
SELECT 'slack.slack_channels', to_jsonb(t) FROM slack.slack_channels t
UNION ALL
SELECT 'slack.slack_drafts', to_jsonb(t) FROM slack.slack_drafts t
UNION ALL
SELECT 'slack.slack_emojis', to_jsonb(t) FROM slack.slack_emojis t
UNION ALL
SELECT 'slack.slack_files', to_jsonb(t) FROM slack.slack_files t
UNION ALL
SELECT 'slack.slack_messages', to_jsonb(t) FROM slack.slack_messages t
UNION ALL
SELECT 'slack.slack_scheduled_messages', to_jsonb(t) FROM slack.slack_scheduled_messages t
UNION ALL
SELECT 'slack.slack_users', to_jsonb(t) FROM slack.slack_users t
UNION ALL

-- ===== trello =====
SELECT 'trello.trello_actions', to_jsonb(t) FROM trello.trello_actions t
UNION ALL
SELECT 'trello.trello_attachments', to_jsonb(t) FROM trello.trello_attachments t
UNION ALL
SELECT 'trello.trello_boards', to_jsonb(t) FROM trello.trello_boards t
UNION ALL
SELECT 'trello.trello_cards', to_jsonb(t) FROM trello.trello_cards t
UNION ALL
SELECT 'trello.trello_check_items', to_jsonb(t) FROM trello.trello_check_items t
UNION ALL
SELECT 'trello.trello_checklists', to_jsonb(t) FROM trello.trello_checklists t
UNION ALL
SELECT 'trello.trello_labels', to_jsonb(t) FROM trello.trello_labels t
UNION ALL
SELECT 'trello.trello_lists', to_jsonb(t) FROM trello.trello_lists t
UNION ALL
SELECT 'trello.trello_members', to_jsonb(t) FROM trello.trello_members t
UNION ALL
SELECT 'trello.trello_organizations', to_jsonb(t) FROM trello.trello_organizations t;
