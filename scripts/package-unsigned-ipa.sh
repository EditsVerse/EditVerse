#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

CONFIGURATION="${CONFIGURATION:-Release}"
DERIVED_DATA="${DERIVED_DATA:-$ROOT_DIR/build/DerivedData}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/build/ipa}"
PRODUCT_NAME="${PRODUCT_NAME:-EditVerse}"
DEPLOYMENT_TARGET="${IPHONEOS_DEPLOYMENT_TARGET:-17.0}"

mkdir -p "$OUTPUT_DIR"
rm -rf "$DERIVED_DATA"
mkdir -p "$DERIVED_DATA"

echo "==> Building unsigned $PRODUCT_NAME (iphoneos, iOS $DEPLOYMENT_TARGET)"

xcodebuild \
  -project EditVerse.xcodeproj \
  -scheme EditVerse \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -derivedDataPath "$DERIVED_DATA" \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="" \
  IPHONEOS_DEPLOYMENT_TARGET="$DEPLOYMENT_TARGET" \
  build

APP_PATH="$(find "$DERIVED_DATA/Build/Products" -path "*iphoneos/$PRODUCT_NAME.app" -print -quit)"
if [[ -z "$APP_PATH" || ! -d "$APP_PATH" ]]; then
  echo "error: $PRODUCT_NAME.app not found under $DERIVED_DATA" >&2
  find "$DERIVED_DATA/Build/Products" -name '*.app' -print >&2 || true
  exit 1
fi

STAGE="$(mktemp -d)"
mkdir -p "$STAGE/Payload"
cp -R "$APP_PATH" "$STAGE/Payload/"

IPA_PATH="$OUTPUT_DIR/${PRODUCT_NAME}-unsigned.ipa"
rm -f "$IPA_PATH"
(
  cd "$STAGE"
  zip -qry "$IPA_PATH" Payload
)

rm -rf "$STAGE"

echo "==> IPA ready: $IPA_PATH"
ls -lh "$IPA_PATH"
