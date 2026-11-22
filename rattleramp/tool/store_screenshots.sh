#!/usr/bin/env bash
# App Store screenshots, repeatable (landscape — the game is landscape only).
#
#   tool/store_screenshots.sh                # both devices
#   tool/store_screenshots.sh ios-phone
#
# Devices:
#   ios-phone   iPhone 6.9" (2868×1320)  simulator iPhone 18/17 Pro Max
#   ios-tablet  iPad 13"   (2752×2064)   simulator iPad Pro 13-inch (M5/M4)
#
# Output: ../fastlane/metadata/ios/<cs|en-US>/screenshots/<device>_<n>_<scene>.png
# The UI is Czech only, so both locales get the same set. Scenes: integration_test/store_screenshots_test.dart.
# Upload: python3 tool/upload_store_screenshots.py ios
#
# Note: `flutter drive` may migrate ios/ to Swift Package Manager — revert that (git checkout -- ios).
set -euo pipefail

APP="$(cd "$(dirname "$0")/.." && pwd)"            # rattleramp/
META="$APP/../fastlane/metadata"
RAW="$APP/build/store_screenshots"
DEVICES=("$@"); [ ${#DEVICES[@]} -eq 0 ] && DEVICES=(ios-phone ios-tablet)
export FLUTTER_XCODE_COMPILATION_CACHE_ENABLE_CACHING=NO

sim_udid() { # first available simulator from the names
  for name in "$@"; do
    local id
    id=$(xcrun simctl list devices available | grep -F "    $name (" | head -1 | grep -oE '[0-9A-F-]{36}' || true)
    [ -n "$id" ] && { echo "$id"; return; }
  done
  echo "missing simulator: $*" >&2; exit 1
}

ios() { # ios <kind> <prefix> <width> <height> <simulators…>
  local kind=$1 prefix=$2 w=$3 h=$4; shift 4
  local udid booted=0; udid=$(sim_udid "$@")
  xcrun simctl list devices | grep -q "$udid) (Booted)" && booted=1
  xcrun simctl boot "$udid" 2>/dev/null || true
  xcrun simctl bootstatus "$udid" -b >/dev/null
  xcrun simctl status_bar "$udid" override --time 9:41 --dataNetwork wifi --wifiBars 3 \
    --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
  rm -rf "${RAW:?}/$kind"; mkdir -p "$RAW/$kind"
  (cd "$APP" && SCREENSHOT_DIR="$RAW/$kind" flutter drive \
    --driver=test_driver/screenshot_driver.dart \
    --target=integration_test/store_screenshots_test.dart -d "$udid")
  xcrun simctl status_bar "$udid" clear
  [ $booted = 1 ] || xcrun simctl shutdown "$udid"
  for f in "$RAW/$kind"/*.png; do
    # Portrait capture of the rotated landscape layout (iPad) → turn it upright.
    [ "$(sips -g pixelWidth "$f" | awk '/pixelWidth/{print $2}')" = "$h" ] && sips -r 270 "$f" >/dev/null
    local size; size=$(sips -g pixelWidth -g pixelHeight "$f" | awk '/pixelWidth|pixelHeight/{printf "%s ", $2}')
    [ "$size" = "$w $h " ] || { echo "$f is ${size}, expected ${w}x${h}" >&2; exit 1; }
  done
  for loc in cs en-US; do
    local out="$META/ios/$loc/screenshots"; mkdir -p "$out"; rm -f "$out/${prefix}"_*.png
    for f in "$RAW/$kind"/*.png; do cp "$f" "$out/${prefix}_$(basename "$f")"; done
  done
}

for d in "${DEVICES[@]}"; do
  echo "== $d"
  case $d in
    ios-phone)  ios ios-phone iphone69 2868 1320 "iPhone 18 Pro Max" "iPhone 17 Pro Max" ;;
    ios-tablet) ios ios-tablet ipad13 2752 2064 "iPad Pro 13-inch (M5)" "iPad Pro 13-inch (M4)" ;;
    *) echo "unknown device: $d" >&2; exit 1 ;;
  esac
done
echo "done: $META"
