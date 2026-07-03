#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="${REMOTE_NAME:-origin}"
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/momiyama-AI/nomidai-tracker.git}"
BRANCH="${BRANCH:-master}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "This script must be run inside the git repository." >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree is not clean. Commit or stash changes before pushing." >&2
  git status --short >&2
  exit 1
fi

if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  current_url="$(git remote get-url "$REMOTE_NAME")"
  if [ "$current_url" != "$REPOSITORY_URL" ]; then
    echo "Remote '$REMOTE_NAME' already points to '$current_url'." >&2
    echo "Expected '$REPOSITORY_URL'. Update it manually if this is intentional." >&2
    exit 1
  fi
else
  git remote add "$REMOTE_NAME" "$REPOSITORY_URL"
fi

git push -u "$REMOTE_NAME" "$BRANCH"
