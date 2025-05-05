#!/bin/bash
set -e

# Start background services
service sysstat start
service cron start
service ntp start
service ssh start

# Log current IP setup for debugging
echo "Setting Cassandra listen_address and seeds to ${HOSTNAME}"
export CASSANDRA_SEEDS=$(hostname -i)

# Ensure permissions (optional safety step)
chown -R cassandrauser /var/lib/cassandra /var/log/cassandra /etc/cassandra || true

# Start Cassandra (force -R to run as root, -f for foreground)
exec /start-cassandra.sh
