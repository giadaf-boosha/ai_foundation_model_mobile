#!/usr/bin/env bash
# step.sh — esegue un comando con narrative + show + pause.
# Usage: step.sh "narrative" "command to show" -- actual command [args...]
# Se "command to show" e il comando reale coincidono, usa due volte la stessa stringa.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/theme.sh"

NARRATIVE="$1"; shift
SHOWN="$1"; shift
[ "$1" = "--" ] && shift

narrate "$NARRATIVE"
show_cmd "$SHOWN"
pause_msg "eseguire"
"$@"
echo
pause
