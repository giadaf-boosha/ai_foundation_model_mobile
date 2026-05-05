#!/usr/bin/env bash
# banner.sh N TOTAL TITLE SUBTITLE — disegna un header demo
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/theme.sh"

N="${1:-?}"
TOTAL="${2:-?}"
TITLE="${3:-Demo}"
SUBTITLE="${4:-}"

clear_screen
banner "DEMO ${N}/${TOTAL}  ·  ${TITLE}" "${SUBTITLE}"
