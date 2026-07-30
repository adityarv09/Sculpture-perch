-- OPTIONAL: instead of dumping all ~588k slack + ~54k drive rows, pull only what
-- matters for the persona you build the task around. Fill in the persona's real
-- identifiers first (find them in slack.slack_users / gmail.gmail_users /
-- linear.linear_users), then run these.

-- 1) Find the persona's ids by name (replace 'Julia'):
SELECT 'slack.slack_users', to_jsonb(t) FROM slack.slack_users t
WHERE t::text ILIKE '%Julia%';

-- 2) Slack messages authored by that user (replace <SLACK_USER_ID>):
-- SELECT 'slack.slack_messages', to_jsonb(t)
-- FROM slack.slack_messages t
-- WHERE t.user = '<SLACK_USER_ID>'
-- ORDER BY t.ctid
-- LIMIT 5000 OFFSET 0;

-- 3) Gmail messages to/from the persona (replace email):
-- SELECT 'gmail.gmail_messages', to_jsonb(t)
-- FROM gmail.gmail_messages t
-- WHERE t::text ILIKE '%julia%@%'
-- ORDER BY t.ctid
-- LIMIT 2000 OFFSET 0;

-- 4) Linear issues assigned to the persona (replace <LINEAR_USER_ID>):
-- SELECT 'linear.linear_issues', to_jsonb(t)
-- FROM linear.linear_issues t
-- WHERE t::text ILIKE '%<LINEAR_USER_ID>%'
-- ORDER BY t.ctid;
