-- trello schema. trello_actions has ~5,294 rows; if this fails to parse,
-- comment out trello_actions and use 04b_trello_actions_paged.sql.
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
SELECT 'trello.trello_organizations', to_jsonb(t) FROM trello.trello_organizations t
UNION ALL
SELECT 'trello.trello_actions', to_jsonb(t) FROM trello.trello_actions t;
