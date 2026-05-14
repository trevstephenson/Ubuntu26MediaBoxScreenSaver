#!/usr/bin/env bash
#
# download-aerials.sh - Download 1080p H.264 videos from
# https://aerial-videos.netlify.app/
#
# Usage:   ./download-aerials.sh [output_dir]

set -euo pipefail

# === CONFIG ============================================================
SOURCE_URL="https://aerial-videos.netlify.app/"
OUT_DIR="${1:-./aerials}"
QUALITY="1080p-h264"
PARALLEL=3
# =======================================================================

case "$QUALITY" in
  4k-sdr)     PATTERN='SDR_4K_HEVC\.mov$' ;;
  4k-dv)      PATTERN='HDR_4K_(HEVC|tuned)\.mov$' ;;
  1080p-sdr)  PATTERN='SDR_2K_HEVC\.mov$' ;;
  1080p-dv)   PATTERN='HDR_2K_(HEVC|tuned)\.mov$' ;;
  1080p-h264) PATTERN='SDR_2K_AVC\.mov$' ;;
  all)        PATTERN='\.mov$' ;;
  *) echo "Unknown QUALITY: $QUALITY"; exit 1 ;;
esac

for cmd in curl grep xargs; do
  command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd"; exit 1; }
done

mkdir -p "$OUT_DIR"
cd "$OUT_DIR"

echo "Fetching video list from $SOURCE_URL ..."
mapfile -t URLS < <(
  curl -fsSL "$SOURCE_URL" \
    | grep -oE 'https://sylvan\.apple\.com/[^)"[:space:]]+\.mov' \
    | grep -E "$PATTERN" \
    | sort -u
)

TOTAL="${#URLS[@]}"
if [ "$TOTAL" -eq 0 ]; then
  echo "No URLs matched pattern: $PATTERN"
  exit 1
fi

echo "Found $TOTAL videos. Saving to: $(pwd)"
echo

URL_LIST="$(mktemp)"
trap 'rm -f "$URL_LIST"' EXIT
printf '%s\n' "${URLS[@]}" > "$URL_LIST"

xargs -a "$URL_LIST" -P "$PARALLEL" -I URL \
    curl -k -fL --retry 5 --retry-delay 2 -C - --progress-bar -O URL \
  && echo "All downloads finished." \
  || { echo "Some downloads failed - re-run the script to resume."; exit 1; }
