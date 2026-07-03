#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-NomidaiTracker.xcodeproj}"
SCHEME="${SCHEME:-NomidaiTracker}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 16 Pro}"
RUN_XCODE_TESTS="${RUN_XCODE_TESTS:-1}"
RUN_ARCHIVE="${RUN_ARCHIVE:-0}"
EVIDENCE_DIR="${EVIDENCE_DIR:-/tmp/nomidai-release-evidence-$(date +%Y%m%d-%H%M%S)}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$EVIDENCE_DIR"
cd "$ROOT_DIR"

run_logged() {
  local label="$1"
  shift
  local log_file="$EVIDENCE_DIR/${label}.log"

  printf 'RUN: %s\n' "$*" | tee "$log_file"
  "$@" 2>&1 | tee -a "$log_file"
}

{
  printf 'Nomidai Tracker release evidence\n'
  printf 'Generated at: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'Repository: %s\n' "$ROOT_DIR"
  printf 'Git HEAD: %s\n' "$(git rev-parse HEAD)"
  printf 'Git branch: %s\n' "$(git rev-parse --abbrev-ref HEAD)"
  printf 'Project: %s\n' "$PROJECT"
  printf 'Scheme: %s\n' "$SCHEME"
  printf 'Destination: %s\n' "$DESTINATION"
  printf 'RUN_XCODE_TESTS: %s\n' "$RUN_XCODE_TESTS"
  printf 'RUN_ARCHIVE: %s\n' "$RUN_ARCHIVE"
} >"$EVIDENCE_DIR/summary.txt"

git status --short >"$EVIDENCE_DIR/git-status.txt"
git log --oneline -10 >"$EVIDENCE_DIR/git-log.txt"

if [ -s "$EVIDENCE_DIR/git-status.txt" ]; then
  printf 'Working tree is not clean. Commit or stash changes before collecting release evidence.\n' >&2
  cat "$EVIDENCE_DIR/git-status.txt" >&2
  printf 'Evidence directory: %s\n' "$EVIDENCE_DIR" >&2
  exit 1
fi

run_logged verify-release-readiness bash scripts/verify-release-readiness.sh

if [ "$RUN_XCODE_TESTS" = "1" ]; then
  run_logged xcodebuild-test \
    xcodebuild test \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -destination "$DESTINATION" \
      CODE_SIGNING_ALLOWED=NO \
      -resultBundlePath "$EVIDENCE_DIR/NomidaiTrackerTests.xcresult"
fi

if [ "$RUN_ARCHIVE" = "1" ]; then
  run_logged archive-testflight \
    env \
      ARCHIVE_PATH="$EVIDENCE_DIR/NomidaiTracker.xcarchive" \
      LOG_PATH="$EVIDENCE_DIR/archive-testflight.log" \
      bash scripts/archive-testflight.sh
fi

printf 'Release evidence collected: %s\n' "$EVIDENCE_DIR"
