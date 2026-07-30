-- slack: small tables. slack_files (~47,968) and slack_messages (~587,828)
-- are HUGE and must be paginated separately in 08b_slack_big_paged.sql.
SELECT 'slack.slack_channels', to_jsonb(t) FROM slack.slack_channels t
UNION ALL
SELECT 'slack.slack_drafts', to_jsonb(t) FROM slack.slack_drafts t
UNION ALL
SELECT 'slack.slack_emojis', to_jsonb(t) FROM slack.slack_emojis t
UNION ALL
SELECT 'slack.slack_scheduled_messages', to_jsonb(t) FROM slack.slack_scheduled_messages t
UNION ALL
SELECT 'slack.slack_users', to_jsonb(t) FROM slack.slack_users t;
