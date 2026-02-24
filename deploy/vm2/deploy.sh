#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/apps/barrett-software-site"
CONTAINER_NAME="barrett-software-site"
HOST_PORT="8092"

mkdir -p "$HOME/apps"

if [ ! -d "$REPO_DIR/.git" ]; then
  echo "Repo missing at $REPO_DIR"
  exit 1
fi

cd "$REPO_DIR"
git fetch origin main
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
  git reset --hard origin/main
else
  echo "No git changes detected"
fi

if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container missing; forcing (re)build"
fi

docker build -t "$CONTAINER_NAME:latest" .

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER_NAME" --restart unless-stopped -p "$HOST_PORT":80 "$CONTAINER_NAME:latest"

echo "Deployed $CONTAINER_NAME on port $HOST_PORT"
