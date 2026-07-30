-- confluence schema (all small, safe to run at once)
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
SELECT 'confluence.confluence_users', to_jsonb(t) FROM confluence.confluence_users t;
