#!/usr/bin/env bash
# Installs an APK on the running emulator, opens it and checks that the app
# starts and draws its UI. Saves the log, a screenshot and the UI tree to the
# output directory.
#
# Usage: android_smoke.sh <apk> <output dir>
set -uo pipefail

apk="$1"
out="$2"
pkg=io.github.zacharymikus.openconverter
mkdir -p "$out"

adb install -r "$apk" || exit 1
adb logcat -c
adb shell monkey -p "$pkg" -c android.intent.category.LAUNCHER 1 > /dev/null
sleep 30

adb exec-out screencap -p > "$out/screen.png"
adb shell uiautomator dump /sdcard/ui.xml > /dev/null 2>&1 && adb pull /sdcard/ui.xml "$out/ui.xml" > /dev/null
adb logcat -d > "$out/logcat.txt"
pid="$(adb shell pidof "$pkg" || true)"

echo "::group::App log"
grep -E "flutter|AndroidRuntime|$pkg|${pid:-no-pid}" "$out/logcat.txt" | tail -200
echo "::endgroup::"

failed=0
if [ -z "$pid" ]; then
  echo "::error::The app isn't running 30 s after launch."
  failed=1
fi
if grep -qE "FATAL EXCEPTION|E/flutter" "$out/logcat.txt"; then
  echo "::error::The app logged an error; see the App log group and logcat.txt."
  failed=1
fi
# The converter screen always shows the keypad's "=" key once it has drawn.
if ! grep -q 'text="="\|content-desc="="' "$out/ui.xml" 2>/dev/null; then
  echo "::error::The converter screen isn't showing (still on the launch screen?). See screen.png."
  failed=1
fi
exit "$failed"
