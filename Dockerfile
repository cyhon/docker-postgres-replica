FROM postgres:9.6
MAINTAINER linhaitao

ENV PG_WAL_LEVEL hot_standby
ENV PG_HOT_STANDBY on
ENV PG_MAX_WAL_SENDERS 8
ENV PG_WAL_KEEP_SEGMENTS 8
ENV PG_MASTER_MAX_CONNECTIONS 100
ENV PG_SLAVE_MAX_CONNECTIONS 1000

COPY setup-replication.sh /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup-replication.sh /docker-entrypoint.sh

RUN echo 'psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -h 127.0.0.1 -p 5432' > ~/.bash_history
