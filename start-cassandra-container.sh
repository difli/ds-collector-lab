#!/bin/bash

set -e

IMAGE_NAME="cassandra-collector"
CONTAINER_NAME="cassandra-collector"

echo "🛠️  Building Cassandra Docker image..."
docker build -t $IMAGE_NAME .

echo "🧹 Removing existing container if it exists..."
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f $CONTAINER_NAME
fi

echo "🚀 Starting Cassandra container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 9042:9042 \
  -p 7199:7199 \
  -p 22:22 \
  $IMAGE_NAME

echo "⏳ Waiting for Cassandra to become available..."
until docker exec $CONTAINER_NAME nodetool status > /dev/null 2>&1; do
  sleep 2
  echo -n "."
done

echo ""
echo "✅ Cassandra is up and running in container: $CONTAINER_NAME"
docker exec $CONTAINER_NAME nodetool status
