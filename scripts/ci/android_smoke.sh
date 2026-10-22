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
adb shell am start -n "$pkg/.MainActivity" > /dev/null

# Wait up to a minute for the converter screen, which always shows the
# keypad's "=" key once it has drawn.
shown=0
for _ in $(seq 1 20); do
  sleep 3
  if adb shell uiautomator dump /sdcard/ui.xml > /dev/null 2>&1 \
    && adb pull /sdcard/ui.xml "$out/ui.xml" > /dev/null 2>&1 \
    && grep -q 'text="="\|content-desc="="' "$out/ui.xml"; then
    shown=1
    break
  fi
done
sleep 2 # let startup errors reach the log

adb exec-out screencap -p > "$out/screen.png"
adb logcat -d > "$out/logcat.txt"
pid="$(adb shell pidof "$pkg" || true)"

echo "::group::App log"
grep -E "flutter|AndroidRuntime|$pkg|${pid:-no-pid}" "$out/logcat.txt" | tail -200
echo "::endgroup::"

failed=0
if [ -z "$pid" ]; then
  echo "::error::The app isn't running after launch."
  failed=1
fi
if grep -qE "FATAL EXCEPTION| E flutter |E/flutter" "$out/logcat.txt"; then
  echo "::error::The app logged an error; see the App log group and logcat.txt."
  failed=1
fi
if [ "$shown" != 1 ]; then
  echo "::error::The converter screen isn't showing (still on the launch screen?). See screen.png."
  failed=1
fi
exit "$failed"
