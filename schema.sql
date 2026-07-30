SELECT
    schemaname AS table_schema,
    relname    AS table_name,
    n_live_tup AS approx_rows
FROM pg_stat_user_tables
ORDER BY schemaname, relname;