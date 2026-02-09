#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

APP_CSPROJ="src/FieldOps.App/FieldOps.App.csproj"
AVD_NAME="${AVD_NAME:-Medium_Phone_API_36.1}"
ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}"
PKG="${PKG:-com.calypso.fieldkit}"

export ANDROID_SDK_ROOT
export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 21)}"

echo "[info] restarting adb..."
adb kill-server >/dev/null 2>&1 || true
adb start-server >/dev/null

echo "[info] killing any running emulators (to avoid double-boot/offline)..."
# Best-effort kill if any emulator is connected
while adb devices | awk 'NR>1 {print $1, $2}' | grep -q "^emulator-"; do
  SERIAL="$(adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $1; exit}')"
  echo "[info] stopping $SERIAL ..."
  adb -s "$SERIAL" emu kill >/dev/null 2>&1 || true
  sleep 2
done

# Also kill any stray emulator process if needed
pkill -f "emulator.*$AVD_NAME" >/dev/null 2>&1 || true

echo "[info] starting emulator: $AVD_NAME"
nohup emulator -avd "$AVD_NAME" -netdelay none -netspeed full >/tmp/emulator.log 2>&1 &

echo "[info] waiting for device..."
adb wait-for-device

echo "[info] waiting for device state=device (not offline)..."
until adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $2; exit}' | grep -q "^device$"; do
  sleep 2
done

echo "[info] waiting for sys.boot_completed..."
until adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' | grep -q "^1$"; do
  sleep 2
done

echo "[info] waiting for ABI..."
ABI=""
until [[ "${ABI:-}" =~ (arm64-v8a|x86_64|armeabi-v7a) ]]; do
  ABI="$(adb shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r' || true)"
  sleep 2
done
echo "[info] ABI: $ABI"

echo "[info] device ready:"
adb devices -l

echo "[info] uninstalling old package (ignore failures)..."
adb uninstall "$PKG" >/dev/null 2>&1 || true

echo "[info] cleaning..."
dotnet clean "$APP_CSPROJ" >/dev/null
rm -rf src/FieldOps.App/bin src/FieldOps.App/obj

echo "[info] building + deploying..."
dotnet build "$APP_CSPROJ" -t:Run -f net9.0-android \
  -p:AndroidSdkDirectory="$ANDROID_SDK_ROOT" \
  -p:JavaSdkDirectory="$JAVA_HOME"

echo "[success] deployed."
