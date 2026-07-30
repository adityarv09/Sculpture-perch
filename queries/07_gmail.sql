-- gmail: small tables. gmail_messages (~24,738) and gmail_threads (~21,209)
-- are paginated separately in 07b_gmail_big_paged.sql.
SELECT 'gmail.gmail_attachments', to_jsonb(t) FROM gmail.gmail_attachments t
UNION ALL
SELECT 'gmail.gmail_labels', to_jsonb(t) FROM gmail.gmail_labels t
UNION ALL
SELECT 'gmail.gmail_users', to_jsonb(t) FROM gmail.gmail_users t;
