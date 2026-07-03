#!/usr/bin/env bash
set -euo pipefail

failures=0

ok() {
  printf 'OK: %s\n' "$1"
}

fail() {
  printf 'NG: %s\n' "$1" >&2
  failures=$((failures + 1))
}

require_file() {
  if [ -f "$1" ]; then
    ok "$1 exists"
  else
    fail "$1 is missing"
  fi
}

require_dir() {
  if [ -d "$1" ]; then
    ok "$1 exists"
  else
    fail "$1 is missing"
  fi
}

require_text() {
  local file="$1"
  local text="$2"
  local label="$3"

  if grep -Fq "$text" "$file"; then
    ok "$label"
  else
    fail "$label"
  fi
}

require_command() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1 command available"
  else
    fail "$1 command is required"
  fi
}

require_png_size() {
  local file="$1"
  local expected_width="$2"
  local expected_height="$3"

  require_file "$file"
  if ! command -v sips >/dev/null 2>&1; then
    fail "sips command is required to inspect $file"
    return
  fi

  local width
  local height
  width=$(sips -g pixelWidth "$file" 2>/dev/null | awk '/pixelWidth/ { print $2 }')
  height=$(sips -g pixelHeight "$file" 2>/dev/null | awk '/pixelHeight/ { print $2 }')

  if [ "$width" = "$expected_width" ] && [ "$height" = "$expected_height" ]; then
    ok "$file is ${expected_width}x${expected_height}"
  else
    fail "$file is ${width:-unknown}x${height:-unknown}, expected ${expected_width}x${expected_height}"
  fi
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

require_command plutil
require_command python3
require_command sips

require_file "NomidaiTracker.xcodeproj/project.pbxproj"
require_file "NomidaiTracker/Resources/PrivacyInfo.xcprivacy"
require_file "NomidaiTracker/NomidaiTracker.entitlements"
require_file "NomidaiTrackerWidget/NomidaiTrackerWidget.entitlements"
require_file "NomidaiTracker/Supporting/ProductIDs.swift"
require_file "NomidaiTracker/Supporting/LegalLinks.swift"
require_file "NomidaiTracker/Supporting/AppGroup.swift"
require_file "StoreKit/NomidaiTracker.storekit"
require_file ".github/workflows/ios-ci.yml"
require_file "AppStore/review-notes.md"
require_file "AppStore/app-store-connect-fields.md"
require_file "AppStore/privacy-answers.md"
require_file "AppStore/export-compliance.md"
require_file "AppStore/age-rating.md"
require_file "AppStore/iap-products.md"
require_file "scripts/collect-release-evidence.sh"
require_dir "docs"

plutil -lint NomidaiTracker/Resources/PrivacyInfo.xcprivacy >/dev/null && ok "PrivacyInfo.xcprivacy plist is valid" || fail "PrivacyInfo.xcprivacy plist is invalid"
plutil -lint NomidaiTracker/NomidaiTracker.entitlements >/dev/null && ok "App entitlements plist is valid" || fail "App entitlements plist is invalid"
plutil -lint NomidaiTrackerWidget/NomidaiTrackerWidget.entitlements >/dev/null && ok "Widget entitlements plist is valid" || fail "Widget entitlements plist is invalid"

require_text "NomidaiTracker.xcodeproj/project.pbxproj" "DEVELOPMENT_TEAM = K4RPQR296Y;" "Team ID is K4RPQR296Y"
require_text "NomidaiTracker.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = com.momi0216yama.nomidaitracker;" "App bundle ID is configured"
require_text "NomidaiTracker.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = com.momi0216yama.nomidaitracker.widget;" "Widget bundle ID is configured"
require_text "NomidaiTracker.xcodeproj/project.pbxproj" "CODE_SIGN_STYLE = Automatic;" "Automatic signing is enabled"
require_text "NomidaiTracker.xcodeproj/project.pbxproj" "INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO;" "App export compliance flag is false"
require_text "NomidaiTrackerWidget/Info.plist" "ITSAppUsesNonExemptEncryption" "Widget export compliance key exists"
require_text "NomidaiTrackerWidget/Info.plist" "<false/>" "Widget export compliance flag is false"

privacy_resource_count=$(grep -c "PrivacyInfo.xcprivacy in Resources" NomidaiTracker.xcodeproj/project.pbxproj || true)
if [ "$privacy_resource_count" -ge 2 ]; then
  ok "PrivacyInfo.xcprivacy is included in app and widget resources"
else
  fail "PrivacyInfo.xcprivacy should be included in app and widget resources"
fi

require_text "NomidaiTracker/Resources/PrivacyInfo.xcprivacy" "NSPrivacyAccessedAPICategoryUserDefaults" "Privacy manifest declares UserDefaults API"
require_text "NomidaiTracker/Resources/PrivacyInfo.xcprivacy" "CA92.1" "Privacy manifest declares CA92.1 reason"
require_text "NomidaiTracker/Resources/PrivacyInfo.xcprivacy" "NSPrivacyCollectedDataTypes" "Privacy manifest declares collected data types"
require_text "NomidaiTracker/Resources/PrivacyInfo.xcprivacy" "NSPrivacyTracking" "Privacy manifest declares tracking"

require_text "NomidaiTracker/NomidaiTracker.entitlements" "group.com.momi0216yama.nomidaitracker" "App entitlement has App Group"
require_text "NomidaiTrackerWidget/NomidaiTrackerWidget.entitlements" "group.com.momi0216yama.nomidaitracker" "Widget entitlement has App Group"
require_text "NomidaiTracker/Supporting/AppGroup.swift" "group.com.momi0216yama.nomidaitracker" "AppGroup helper matches entitlement"

require_text "NomidaiTracker/Supporting/ProductIDs.swift" "nomidai.pro.lifetime" "Lifetime product ID is in code"
require_text "NomidaiTracker/Supporting/ProductIDs.swift" "nomidai.pro.monthly" "Monthly product ID is in code"
require_text "StoreKit/NomidaiTracker.storekit" "\"productID\" : \"nomidai.pro.lifetime\"" "Lifetime product ID is in StoreKit config"
require_text "StoreKit/NomidaiTracker.storekit" "\"productID\" : \"nomidai.pro.monthly\"" "Monthly product ID is in StoreKit config"
require_text "StoreKit/NomidaiTracker.storekit" "\"recurringSubscriptionPeriod\" : \"P1M\"" "Monthly StoreKit period is one month"

require_text "NomidaiTracker/Supporting/LegalLinks.swift" "https://momiyama-ai.github.io/nomidai-tracker/terms/" "Terms URL is configured"
require_text "NomidaiTracker/Supporting/LegalLinks.swift" "https://momiyama-ai.github.io/nomidai-tracker/privacy/" "Privacy URL is configured"
require_text "NomidaiTracker/Supporting/LegalLinks.swift" "https://momiyama-ai.github.io/nomidai-tracker/support/" "Support URL is configured"

require_text "NomidaiTracker/Resources/Localizable.strings" "paywall.subscription.disclosure" "Subscription disclosure string exists"
require_text "NomidaiTracker/Resources/Localizable.strings" "paywall.restore" "Restore purchase string exists"
require_text "NomidaiTracker/Resources/Localizable.strings" "paywall.terms" "Paywall terms string exists"
require_text "NomidaiTracker/Resources/Localizable.strings" "paywall.privacy" "Paywall privacy string exists"

for page in index terms privacy support; do
  require_file "docs/${page}.md"
done
require_text "docs/terms.md" "permalink: /terms/" "Terms page permalink is configured"
require_text "docs/privacy.md" "permalink: /privacy/" "Privacy page permalink is configured"
require_text "docs/support.md" "permalink: /support/" "Support page permalink is configured"

for screenshot in home quickRecord calendar settings paywall; do
  require_png_size "AppStore/screenshots/${screenshot}.png" 1206 2622
done
require_png_size "NomidaiTracker/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png" 1024 1024

bash -n scripts/archive-testflight.sh && ok "archive-testflight.sh syntax is valid" || fail "archive-testflight.sh syntax is invalid"
bash -n scripts/collect-release-evidence.sh && ok "collect-release-evidence.sh syntax is valid" || fail "collect-release-evidence.sh syntax is invalid"
bash -n scripts/verify-pages.sh && ok "verify-pages.sh syntax is valid" || fail "verify-pages.sh syntax is invalid"
bash -n scripts/push-github.sh && ok "push-github.sh syntax is valid" || fail "push-github.sh syntax is invalid"
python3 scripts/verify-app-store-metadata.py && ok "App Store metadata is within configured limits" || fail "App Store metadata check failed"

if [ "$failures" -eq 0 ]; then
  printf 'Release readiness local checks passed.\n'
else
  printf 'Release readiness local checks failed: %d issue(s).\n' "$failures" >&2
fi

exit "$failures"
