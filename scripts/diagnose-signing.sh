#!/usr/bin/env bash
set -euo pipefail

TEAM_ID="${TEAM_ID:-H79G72QG4F}"
APP_BUNDLE_ID="${APP_BUNDLE_ID:-com.momi0216yama.nomidaitracker}"
WIDGET_BUNDLE_ID="${WIDGET_BUNDLE_ID:-com.momi0216yama.nomidaitracker.widget}"
APP_GROUP_ID="${APP_GROUP_ID:-group.com.momi0216yama.nomidaitracker}"
PROJECT_FILE="${PROJECT_FILE:-NomidaiTracker.xcodeproj/project.pbxproj}"
APP_ENTITLEMENTS="${APP_ENTITLEMENTS:-NomidaiTracker/NomidaiTracker.entitlements}"
WIDGET_ENTITLEMENTS="${WIDGET_ENTITLEMENTS:-NomidaiTrackerWidget/NomidaiTrackerWidget.entitlements}"
PROFILE_DIR="${PROFILE_DIR:-$HOME/Library/MobileDevice/Provisioning Profiles}"
XCODE_PROFILE_DIR="${XCODE_PROFILE_DIR:-$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles}"

failures=0

ok() {
  printf 'OK: %s\n' "$1"
}

warn() {
  printf 'WARN: %s\n' "$1" >&2
}

fail() {
  printf 'NG: %s\n' "$1" >&2
  failures=$((failures + 1))
}

require_command() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1 command available"
  else
    fail "$1 command is required"
  fi
}

require_text() {
  local file="$1"
  local text="$2"
  local label="$3"

  if [ -f "$file" ] && grep -Fq "$text" "$file"; then
    ok "$label"
  else
    fail "$label"
  fi
}

profile_matches() {
  local profile="$1"
  local bundle_id="$2"
  local require_app_group="$3"
  local decoded
  decoded="$(mktemp)"

  if ! security cms -D -i "$profile" >"$decoded" 2>/dev/null; then
    rm -f "$decoded"
    return 1
  fi

  local team app_id groups name uuid expires
  team=$(/usr/libexec/PlistBuddy -c "Print :TeamIdentifier:0" "$decoded" 2>/dev/null || true)
  app_id=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:application-identifier" "$decoded" 2>/dev/null || true)
  groups=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:com.apple.security.application-groups" "$decoded" 2>/dev/null || true)
  name=$(/usr/libexec/PlistBuddy -c "Print :Name" "$decoded" 2>/dev/null || true)
  uuid=$(/usr/libexec/PlistBuddy -c "Print :UUID" "$decoded" 2>/dev/null || true)
  expires=$(/usr/libexec/PlistBuddy -c "Print :ExpirationDate" "$decoded" 2>/dev/null || true)
  rm -f "$decoded"

  if [ "$team" != "$TEAM_ID" ]; then
    return 1
  fi

  if [ "$app_id" != "$TEAM_ID.$bundle_id" ]; then
    return 1
  fi

  if [ "$require_app_group" = "1" ] && ! printf '%s\n' "$groups" | grep -Fq "$APP_GROUP_ID"; then
    return 1
  fi

  printf 'PROFILE_MATCH:%s:%s:%s\n' "${name:-unknown}" "${uuid:-unknown}" "${expires:-unknown}"
  return 0
}

find_profile_for_bundle() {
  local bundle_id="$1"
  local label="$2"
  local found=0
  local any_dir=0

  local dir
  for dir in "$PROFILE_DIR" "$XCODE_PROFILE_DIR"; do
    if [ ! -d "$dir" ]; then
      continue
    fi

    any_dir=1
    shopt -s nullglob
    local profile
    for profile in "$dir"/*.mobileprovision; do
      local match
      match="$(profile_matches "$profile" "$bundle_id" "1" || true)"
      if [ -n "$match" ]; then
        ok "$label provisioning profile found: ${match#PROFILE_MATCH:}"
        found=1
        break
      fi
    done
    shopt -u nullglob

    if [ "$found" -eq 1 ]; then
      break
    fi
  done

  if [ "$any_dir" -eq 0 ]; then
    fail "Provisioning profile directories are missing: $PROFILE_DIR and $XCODE_PROFILE_DIR"
  elif [ "$found" -eq 0 ]; then
    fail "$label provisioning profile not found for $bundle_id with App Group $APP_GROUP_ID"
  fi
}

require_command security
require_command xcodebuild
require_command /usr/libexec/PlistBuddy

require_text "$PROJECT_FILE" "DEVELOPMENT_TEAM = $TEAM_ID;" "Project uses Team ID $TEAM_ID"
require_text "$PROJECT_FILE" "PRODUCT_BUNDLE_IDENTIFIER = $APP_BUNDLE_ID;" "Project app bundle ID is $APP_BUNDLE_ID"
require_text "$PROJECT_FILE" "PRODUCT_BUNDLE_IDENTIFIER = $WIDGET_BUNDLE_ID;" "Project widget bundle ID is $WIDGET_BUNDLE_ID"
require_text "$PROJECT_FILE" "CODE_SIGN_STYLE = Manual;" "Release signing is manual for App Store profiles"
require_text "$PROJECT_FILE" "PROVISIONING_PROFILE_SPECIFIER = \"NomidaiTracker AppStore\";" "App Store profile is specified for app target"
require_text "$PROJECT_FILE" "PROVISIONING_PROFILE_SPECIFIER = \"NomidaiTrackerWidget AppStore\";" "App Store profile is specified for widget target"
require_text "$APP_ENTITLEMENTS" "$APP_GROUP_ID" "App entitlement has App Group"
require_text "$WIDGET_ENTITLEMENTS" "$APP_GROUP_ID" "Widget entitlement has App Group"

find_profile_for_bundle "$APP_BUNDLE_ID" "App"
find_profile_for_bundle "$WIDGET_BUNDLE_ID" "Widget"

if [ "$failures" -eq 0 ]; then
  printf 'Signing diagnostics passed.\n'
else
  warn "Signing diagnostics found $failures issue(s). Re-login to Apple ID in Xcode and create App IDs/App Group/profiles, then run again."
fi

exit "$failures"
