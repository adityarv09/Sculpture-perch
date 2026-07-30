-- gmail large tables, paginated. Run ONE statement at a time, bumping OFFSET by
-- 2000 until an empty result is returned. gmail_messages bodies can be large;
-- if a 2000-chunk still fails to parse, lower LIMIT to 500.

-- gmail_messages (~24,738 rows)
SELECT 'gmail.gmail_messages', to_jsonb(t)
FROM gmail.gmail_messages t
ORDER BY t.ctid
LIMIT 2000 OFFSET 0;

-- gmail_threads (~21,209 rows)
-- SELECT 'gmail.gmail_threads', to_jsonb(t)
-- FROM gmail.gmail_threads t
-- ORDER BY t.ctid
-- LIMIT 2000 OFFSET 0;
