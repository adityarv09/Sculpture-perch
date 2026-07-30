-- github large tables, paginated. Run ONE statement at a time (select the block),
-- bumping OFFSET by 2000 until an empty result is returned.

-- github_commit_map (~21,208 rows)
SELECT 'github.github_commit_map', to_jsonb(t)
FROM github.github_commit_map t
ORDER BY t.ctid
LIMIT 2000 OFFSET 0;

-- github_commits (~12,687 rows)
-- SELECT 'github.github_commits', to_jsonb(t)
-- FROM github.github_commits t
-- ORDER BY t.ctid
-- LIMIT 2000 OFFSET 0;

-- github_pull_request_commits (~15,938 rows)
-- SELECT 'github.github_pull_request_commits', to_jsonb(t)
-- FROM github.github_pull_request_commits t
-- ORDER BY t.ctid
-- LIMIT 2000 OFFSET 0;

-- github_timeline_events (~12,437 rows)
-- SELECT 'github.github_timeline_events', to_jsonb(t)
-- FROM github.github_timeline_events t
-- ORDER BY t.ctid
-- LIMIT 2000 OFFSET 0;
