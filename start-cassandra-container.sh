#!/bin/bash

set -euo pipefail

IMAGE_NAME="cassandra-collector"
CONTAINER_NAME="cassandra-collector"
PLATFORMS="linux/amd64,linux/arm64"

echo "🛠️  Building Cassandra Docker image for multiple platforms..."
docker buildx create --name multiarch-builder --use >/dev/null 2>&1 || true
docker buildx inspect multiarch-builder --bootstrap >/dev/null

docker buildx build \
  --platform $PLATFORMS \
  -t $IMAGE_NAME:latest \
  --load .  # Use --push if you want to push to a remote registry

echo "🧹 Removing existing container if it exists..."
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f $CONTAINER_NAME
fi

echo "🚀 Starting Cassandra container..."
docker run -d \
  --platform linux/amd64 \
  --name $CONTAINER_NAME \
  -p 9042:9042 \
  -p 7199:7199 \
  -p 22:22 \
  $IMAGE_NAME:latest

echo "⏳ Waiting for Cassandra to become available..."
for i in {1..30}; do
  if docker exec "$CONTAINER_NAME" nodetool status > /dev/null 2>&1; then
    echo ""
    echo "✅ Cassandra is up and running in container: $CONTAINER_NAME"
    docker exec "$CONTAINER_NAME" nodetool status
    exit 0
  fi
  sleep 2
  echo -n "."
done

echo ""
echo "❌ Timed out waiting for Cassandra to become ready."
docker logs "$CONTAINER_NAME"
exit 1
