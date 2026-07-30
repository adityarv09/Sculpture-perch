-- drive_files paginated (~53,702 rows => ~27 runs at 2000/chunk).
-- Bump OFFSET by 2000 each run until an empty result is returned.
SELECT 'gdrive.drive_files', to_jsonb(t)
FROM gdrive.drive_files t
ORDER BY t.ctid
LIMIT 2000 OFFSET 0;
