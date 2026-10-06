#!/usr/bin/env bash
# Собирает unsigned IPA для установки через Scarlet / Sideloadly / TrollStore.
# Нужен macOS с Xcode и iOS SDK. На Linux этот скрипт завершится с ошибкой.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild не найден. IPA для iPhone собирается только на Mac с Xcode." >&2
  exit 1
fi

OUT="$ROOT/dist"
DERIVED="$ROOT/build"
rm -rf "$OUT" "$DERIVED" "$ROOT/Payload"
mkdir -p "$OUT" "$DERIVED"

xcodebuild \
  -project "$ROOT/Dew.xcodeproj" \
  -scheme Dew \
  -configuration Release \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$DERIVED" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  DEVELOPMENT_TEAM="" \
  ARCHS=arm64 \
  ONLY_ACTIVE_ARCH=NO \
  build

APP="$(find "$DERIVED/Build/Products" -name 'Dew.app' -type d | head -n 1)"
if [[ -z "$APP" ]]; then
  echo "Не найден Dew.app после сборки." >&2
  exit 1
fi

mkdir -p "$ROOT/Payload"
cp -R "$APP" "$ROOT/Payload/Dew.app"
(
  cd "$ROOT"
  zip -qr "$OUT/Dew.ipa" Payload
)
rm -rf "$ROOT/Payload"

echo "Готово: $OUT/Dew.ipa"
ls -lh "$OUT/Dew.ipa"
