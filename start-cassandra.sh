#!/bin/bash
set -e

echo "Starting Cassandra with root override (-R)..."
exec cassandra -R -f
