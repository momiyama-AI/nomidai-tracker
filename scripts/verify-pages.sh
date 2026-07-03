#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-https://momiyama-ai.github.io/nomidai-tracker}"

paths=(
  "/"
  "/terms/"
  "/privacy/"
  "/support/"
)

for path in "${paths[@]}"; do
  url="${BASE_URL%/}${path}"
  printf 'Checking %s ... ' "$url"
  curl -fsSIL "$url" >/dev/null
  printf 'OK\n'
done

printf 'All GitHub Pages URLs are reachable.\n'
