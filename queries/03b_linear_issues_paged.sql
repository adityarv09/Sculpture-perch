-- linear_issues paginated (~3,852 rows). Run once per chunk, bumping OFFSET.
-- Chunk 1: OFFSET 0, Chunk 2: OFFSET 2000, Chunk 3: OFFSET 4000 (stop when empty).
SELECT 'linear.linear_issues', to_jsonb(t)
FROM linear.linear_issues t
ORDER BY t.ctid
LIMIT 2000 OFFSET 0;
