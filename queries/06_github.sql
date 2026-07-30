-- github: small/medium tables. The large tables are paginated separately in
-- 06b_github_big_paged.sql (github_commit_map, github_commits,
-- github_pull_request_commits, github_timeline_events).
SELECT 'github.github_branches', to_jsonb(t) FROM github.github_branches t
UNION ALL
SELECT 'github.github_issues', to_jsonb(t) FROM github.github_issues t
UNION ALL
SELECT 'github.github_labels', to_jsonb(t) FROM github.github_labels t
UNION ALL
SELECT 'github.github_pr_comments', to_jsonb(t) FROM github.github_pr_comments t
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
SELECT 'github.github_users', to_jsonb(t) FROM github.github_users t;
