#!/usr/bin/env bash
# Google Gemma basic chat via ollama.
# Su Android giri Gemini Nano via AICore. Da CLI macOS usiamo il fratello
# Gemma (stessa famiglia, stessa filosofia on-device, on-device anche su Mac).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../_runner/theme.sh"

MODEL="${GEMMA_MODEL:-gemma3:4b}"
DEFAULT_PROMPT="Spiegami in 3 frasi cosa e un foundation model on-device."
PROMPT="${1:-$DEFAULT_PROMPT}"

status_info "Modello: $MODEL  ·  on-device, GPU Metal"
status_info "Prompt: $PROMPT"
echo

MODEL_LIST="$(ollama list 2>/dev/null || true)"
if ! echo "$MODEL_LIST" | grep -q "^${MODEL%% *}"; then
  status_warn "Modello $MODEL non trovato. Esegui: make doctor-pull"
  exit 1
fi

echo "─── RISPOSTA ───"
start=$(date +%s)
ollama run "$MODEL" "$PROMPT" 2>/dev/null
end=$(date +%s)
echo "───────────────"
echo
status_info "Latenza totale: $((end - start))s"
status_info "Round-trip di rete: 0 (modello locale)"
