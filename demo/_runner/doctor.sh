#!/usr/bin/env bash
# doctor.sh — health check pre-talk
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/theme.sh"
DEMO_ROOT="$(cd "$HERE/.." && pwd)"

clear_screen
banner "DEMO DOCTOR" "Verifica ambiente prima del seminario"

ok=0
warn=0
err=0

check() {
  local name="$1"
  local cmd="$2"
  local expected="${3:-}"
  if eval "$cmd" >/dev/null 2>&1; then
    local out
    out="$(eval "$cmd" 2>/dev/null | head -1)"
    if [ -n "$expected" ] && ! echo "$out" | grep -qE "$expected"; then
      status_warn "$name: $out (atteso: $expected)"
      warn=$((warn + 1))
    else
      status_ok "$name: $out"
      ok=$((ok + 1))
    fi
  else
    status_err "$name: non disponibile"
    err=$((err + 1))
  fi
}

section "Sistema"
check "macOS" "sw_vers -productVersion" "^26\."
check "Architettura" "uname -m" "arm64"
check "RAM (GB)" "echo \$(( \$(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))"
check "Modello Mac" "sysctl -n hw.model"

section "Toolchain Apple"
check "Xcode" "xcodebuild -version 2>/dev/null | head -1" "^Xcode (1[789]|2[0-9])"
check "Swift" "swift --version 2>/dev/null | head -1" "Swift|swiftlang"
if xcode-select -p 2>/dev/null | grep -q "Xcode.app"; then
  status_ok "xcode-select punta a Xcode.app"
  ok=$((ok + 1))
else
  status_err "xcode-select punta a CommandLineTools — esegui: sudo xcode-select -s /Applications/Xcode.app"
  err=$((err + 1))
fi

section "Toolchain Google"
check "ollama" "ollama --version 2>/dev/null | head -1"
OLLAMA_LIST="$(ollama list 2>/dev/null || true)"
if echo "$OLLAMA_LIST" | grep -q "gemma3:4b\|gemma3n\|gemma3:2b"; then
  status_ok "Modello Gemma disponibile (gemma3:4b o variante)"
  ok=$((ok + 1))
else
  status_warn "Nessun modello Gemma trovato — esegui: make doctor-pull"
  warn=$((warn + 1))
fi

section "Runner CLI (opzionali)"
if command -v gum >/dev/null 2>&1; then
  status_ok "gum: $(gum --version 2>/dev/null | head -1)"
  ok=$((ok + 1))
else
  status_info "gum: non installato (opzionale, runner funziona senza)"
fi
if command -v bat >/dev/null 2>&1; then
  status_ok "bat: $(bat --version 2>/dev/null | head -1)"
  ok=$((ok + 1))
else
  status_info "bat: non installato (opzionale, runner funziona senza)"
fi

section "Apple FoundationModels (build test)"
if [ -f "$DEMO_ROOT/apple/Package.swift" ]; then
  cd "$DEMO_ROOT/apple"
  if swift build --target BasicChat 2>/tmp/swift_build.log >/dev/null; then
    status_ok "Apple package compila (FoundationModels disponibile)"
    ok=$((ok + 1))
  else
    if grep -q "no such module 'FoundationModels'" /tmp/swift_build.log 2>/dev/null; then
      status_err "FoundationModels non disponibile — Apple Intelligence attivo? macOS 26+?"
    else
      status_warn "Build Apple fallita — vedi /tmp/swift_build.log"
    fi
    err=$((err + 1))
  fi
  cd "$DEMO_ROOT"
else
  status_warn "Apple Package.swift non trovato"
  warn=$((warn + 1))
fi

section "Riepilogo"
echo "  ${C_GREEN}OK: $ok${C_RESET}   ${C_YELLOW}WARN: $warn${C_RESET}   ${C_RED}ERR: $err${C_RESET}"
echo

if [ $err -eq 0 ]; then
  status_ok "Pronto per il seminario."
  exit 0
else
  status_err "Risolvi gli errori prima del talk. Vedi DEMO_RUNBOOK.md."
  exit 1
fi
