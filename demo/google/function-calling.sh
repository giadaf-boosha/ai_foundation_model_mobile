#!/usr/bin/env bash
# Function calling on-device pattern con Gemma + structured prompt.
# In produzione si userebbe FunctionGemma 270M fine-tuned o l'API AppFunctions
# di Android 16. Qui dimostriamo il pattern equivalente con Gemma 3.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../_runner/theme.sh"

MODEL="${GEMMA_MODEL:-gemma3:4b}"
USER_PROMPT="${1:-Che tempo fa a Bologna oggi?}"
TEMPLATE_FILE="$HERE/prompts/function-template.txt"

MODEL_LIST="$(ollama list 2>/dev/null || true)"
if ! echo "$MODEL_LIST" | grep -q "^${MODEL%% *}"; then
  status_warn "Modello $MODEL non trovato. Esegui: make doctor-pull"
  exit 1
fi

status_info "Modello: $MODEL"
status_info "Tools disponibili: getWeather, calculate, createReminder"
status_info "Prompt utente: $USER_PROMPT"
echo

# Inietta il prompt nel template
FULL_PROMPT="$(sed "s|%PROMPT%|${USER_PROMPT//|/\\|}|" "$TEMPLATE_FILE")"

echo "─── PROMPT STRUTTURATO ───"
echo "$FULL_PROMPT" | sed 's/^/  /'
echo "──────────────────────────"
echo

status_info "Modello sceglie il tool e argomenti..."
echo
echo "─── OUTPUT MODELLO (tool call JSON) ───"
RAW="$(ollama run "$MODEL" "$FULL_PROMPT" 2>/dev/null)"
echo "$RAW"
echo "───────────────────────────────────────"
echo

# Parsing JSON con python (sempre disponibile su macOS)
TOOL_NAME=$(echo "$RAW" | /usr/bin/python3 -c "
import sys, json, re
text = sys.stdin.read()
m = re.search(r'\{.*\}', text, re.DOTALL)
if not m:
    print('PARSE_ERROR')
    sys.exit(0)
try:
    obj = json.loads(m.group(0))
    print(obj.get('tool', 'NO_TOOL'))
except Exception as e:
    print('PARSE_ERROR')
" 2>/dev/null)

case "$TOOL_NAME" in
  getWeather)
    status_ok "Tool dispatch: getWeather"
    echo "  Risultato simulato: { city: 'Bologna', temp: 18, sky: 'soleggiato' }"
    ;;
  calculate)
    status_ok "Tool dispatch: calculate"
    echo "  Risultato simulato: 42"
    ;;
  createReminder)
    status_ok "Tool dispatch: createReminder"
    echo "  Promemoria creato (mock)"
    ;;
  PARSE_ERROR|NO_TOOL)
    status_warn "Modello non ha prodotto JSON valido — caso reale: si reinvia con few-shot o si fallisce gracefully"
    ;;
  *)
    status_warn "Tool sconosciuto: $TOOL_NAME"
    ;;
esac
