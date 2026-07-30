-- gdrive: small tables here. drive_files (~53,702 rows) is paginated separately
-- in 05b_gdrive_files_paged.sql.
SELECT 'gdrive.drive_sheets', to_jsonb(t) FROM gdrive.drive_sheets t
UNION ALL
SELECT 'gdrive.drive_users', to_jsonb(t) FROM gdrive.drive_users t;
