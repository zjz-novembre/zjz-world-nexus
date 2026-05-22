#!/bin/zsh
set -euo pipefail

ROOT="/Users/zjz/Documents/zjz-world-nexus"
SOURCE_PATH="$ROOT/dist/zjz-world-nexus-browser-extension/web-extension"
PROJECT_PATH="$ROOT/dist/zjz-world-nexus-browser-extension/safari-project"
APP_NAME="Nexus Extension"
BUNDLE_IDENTIFIER="world.zjz.nexus.extension"

if [[ ! -d "$SOURCE_PATH" ]]; then
  echo "Safari web extension source is missing: $SOURCE_PATH" >&2
  echo "Run: python3 $ROOT/build-zjz-world-nexus-browser-extension.py" >&2
  exit 1
fi

if ! xcrun --find safari-web-extension-packager >/dev/null 2>&1; then
  echo "Missing Apple tool: safari-web-extension-packager" >&2
  echo "Install full Xcode or select its developer directory with xcode-select before packaging." >&2
  exit 1
fi

xcrun safari-web-extension-packager \
  "$SOURCE_PATH" \
  --project-location "$PROJECT_PATH" \
  --app-name "$APP_NAME" \
  --bundle-identifier "$BUNDLE_IDENTIFIER" \
  --swift
