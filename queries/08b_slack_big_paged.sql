-- slack HUGE tables, paginated. Run ONE statement at a time, bumping OFFSET.
-- slack_messages is ~587,828 rows => ~118 runs at 5000/chunk (or 294 at 2000).
-- This is a lot of manual runs; strongly consider filtering instead of dumping
-- everything (see 09_persona_filtered.sql).

-- slack_messages (~587,828 rows)
SELECT 'slack.slack_messages', to_jsonb(t)
FROM slack.slack_messages t
ORDER BY t.ctid
LIMIT 5000 OFFSET 0;

-- slack_files (~47,968 rows)
-- SELECT 'slack.slack_files', to_jsonb(t)
-- FROM slack.slack_files t
-- ORDER BY t.ctid
-- LIMIT 5000 OFFSET 0;
