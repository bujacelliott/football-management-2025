#!/usr/bin/env bash
set -euo pipefail

# Builds assets.swf using Apache Flex SDK 4.16.1 + playerglobal from nexussays/playerglobal
# Output: ./assets.swf

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLEX_DIR="$ROOT_DIR/.flexsdk"
OUT="$ROOT_DIR/assets.swf"

if [[ ! -d "$FLEX_DIR" ]]; then
  echo "Flex SDK not found at $FLEX_DIR" >&2
  exit 1
fi

"$FLEX_DIR/bin/mxmlc" \
  -target-player=11.2 \
  -default-size 800 600 \
  -default-frame-rate=30 \
  -default-background-color=0x000000 \
  -use-network=false \
  -static-link-runtime-shared-libraries=true \
  -source-path+="$ROOT_DIR/src" \
  -output "$OUT" \
  "$ROOT_DIR/src/AssetsRoot.as"

echo "Built: $OUT"
