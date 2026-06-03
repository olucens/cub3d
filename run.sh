#!/usr/bin/env bash
set -euo pipefail

TIMEOUT=60
SVC_NAME=dev

echo "🚀 Building and starting container..."
docker compose up -d --build

echo "⏳ Waiting for VNC port 5900 (timeout ${TIMEOUT}s)..."
start_ts=$(date +%s)
while true; do
  if nc -z localhost 5900 >/dev/null 2>&1; then
    break
  fi

  if (( $(date +%s) - start_ts >= TIMEOUT )); then
    echo "❗ Timeout waiting for VNC port 5900. See logs:"
    docker compose logs ${SVC_NAME}
    exit 1
  fi
  sleep 1
done

echo "✅ VNC available on localhost:5900 — launching TigerVNC Viewer..."

echo "✅ Opening container shell..."
docker compose exec ${SVC_NAME} bash

# I use it for stops and remove containers
# But if for some reasone you still needed just comment it
echo "✅ Cleaning up and stopping container..."
docker compose down
