#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-NomidaiTracker.xcodeproj}"
SCHEME="${SCHEME:-NomidaiTracker}"
ARCHIVE_PATH="${ARCHIVE_PATH:-/tmp/NomidaiTracker.xcarchive}"
LOG_PATH="${LOG_PATH:-/tmp/nomidai_archive_latest.log}"

rm -rf "$ARCHIVE_PATH"
rm -f "$LOG_PATH"

set +e
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates 2>&1 | tee "$LOG_PATH"
status=${PIPESTATUS[0]}
set -e

echo "ARCHIVE_EXIT_STATUS:$status"
echo "ARCHIVE_PATH:$ARCHIVE_PATH"
echo "LOG_PATH:$LOG_PATH"

exit "$status"
