#!/bin/bash

# Generate IP for Cassandra
IP=$(hostname -i)

echo "Setting Cassandra listen_address and seeds to $IP"

# Update cassandra.yaml dynamically
sed -i "s/^listen_address:.*/listen_address: $IP/" /etc/cassandra/cassandra.yaml
sed -i "s/^rpc_address:.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml
sed -i "s/- seeds:.*/- seeds: \"$IP\"/" /etc/cassandra/cassandra.yaml
sed -i "s/^# broadcast_address:.*/broadcast_address: $IP/" /etc/cassandra/cassandra.yaml
sed -i "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: $IP/" /etc/cassandra/cassandra.yaml
sed -i "s/^# start_native_transport:.*/start_native_transport: true/" /etc/cassandra/cassandra.yaml
sed -i "s/^# commitlog_sync:.*/commitlog_sync: periodic/" /etc/cassandra/cassandra.yaml
sed -i "s/^# commitlog_sync_period_in_ms:.*/commitlog_sync_period_in_ms: 10000/" /etc/cassandra/cassandra.yaml
sed -i "s/^# partitioner:.*/partitioner: org.apache.cassandra.dht.Murmur3Partitioner/" /etc/cassandra/cassandra.yaml

# Start SSH
service ssh start

# Start Cassandra
cassandra -f
