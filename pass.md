
admin - 6xgAYEqy
user - D2E0Q6mv

Transactions per second
sum(rate(pg_stat_database_xact_commit{job="$host"}[5m]))

Connections in use
max(pg_stat_activity_count{job="$host"})/max(pg_settings_max_connections{job="$host"})*100

Database size
pg_database_size_bytes{job="$host", datname!~"template[0-9]|postgres"}


Queries per second
sum(irate(pg_stat_database_xact_commit{datname=~"$db",job="$host"}[5m])) + sum(irate(pg_stat_database_xact_rollback{datname=~"$db",job="$host"}[5m]))

Last scrape status
pg_exporter_last_scrape_error{job="$host"}

Buffers
irate(pg_stat_bgwriter_buffers_alloc{job='$host'}[5m])


Rows
sum(irate(pg_stat_database_tup_fetched{datname=~"$db",job="$host"}[5m]))

Longest Transaction
pg_stat_activity_max_tx_duration{job='$host'}

Locks count
pg_locks_count{datname=~"$db",job="$host"}>0

Deadlocks and Conflicts
sum(rate(pg_stat_database_deadlocks{datname=~"$db",job="$host"}[5m]))
