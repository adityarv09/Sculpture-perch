-- trello_actions paginated (~5,294 rows). Bump OFFSET by 2000 each run until empty.
SELECT 'trello.trello_actions', to_jsonb(t)
FROM trello.trello_actions t
ORDER BY t.ctid
LIMIT 2000 OFFSET 0;
