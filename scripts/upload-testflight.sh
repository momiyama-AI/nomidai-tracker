#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVE_PATH="${ARCHIVE_PATH:-/tmp/NomidaiTracker.xcarchive}"
EXPORT_OPTIONS_PLIST="${EXPORT_OPTIONS_PLIST:-$ROOT_DIR/AppStore/ExportOptions.plist}"
EXPORT_PATH="${EXPORT_PATH:-/tmp/NomidaiTrackerExport}"
LOG_PATH="${LOG_PATH:-/tmp/nomidai_upload_latest.log}"

rm -rf "$EXPORT_PATH"
rm -f "$LOG_PATH"

set +e
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" \
  -exportPath "$EXPORT_PATH" \
  -allowProvisioningUpdates 2>&1 | tee "$LOG_PATH"
status=${PIPESTATUS[0]}
set -e

echo "UPLOAD_EXIT_STATUS:$status"
echo "ARCHIVE_PATH:$ARCHIVE_PATH"
echo "EXPORT_PATH:$EXPORT_PATH"
echo "LOG_PATH:$LOG_PATH"

exit "$status"
