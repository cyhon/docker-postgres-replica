#!/bin/bash

if [ "x$REPLICATE_FROM" == "x" ]; then

cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = $PG_WAL_LEVEL
max_wal_senders = $PG_MAX_WAL_SENDERS
wal_keep_segments = $PG_WAL_KEEP_SEGMENTS
max_connections = $PG_MASTER_MAX_CONNECTIONS
EOF

else

cat >> ${PGDATA}/postgresql.conf <<EOF
hot_standby = $PG_HOT_STANDBY
max_connections = $PG_SLAVE_MAX_CONNECTIONS
max_standby_streaming_delay = 30s
wal_receiver_status_interval = 1s
hot_standby_feedback = on
EOF

cat > ${PGDATA}/recovery.conf <<EOF
standby_mode = on
primary_conninfo = 'host=${REPLICATE_FROM} port=5432 user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}'
trigger_file = '/tmp/touch_me_to_promote_to_me_master'
EOF
chown postgres ${PGDATA}/recovery.conf
chmod 600 ${PGDATA}/recovery.conf

fi
