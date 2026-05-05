#!/usr/bin/env bash
# seminar.sh — orchestratore demo seminario UniBO. 5 demo in sequenza, ritmo
# controllato da [invio per continuare]. Pensato per essere eseguito a tutto
# schermo: il terminale SOSTITUISCE le slide 43-50 del deck.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_ROOT="$(cd "$HERE/.." && pwd)"
source "$HERE/theme.sh"

TOTAL=5

# ============================================================
# Intro
# ============================================================
clear_screen
banner "BLOCCO DEMO LIVE" "Foundation Models On-Device · 5 demo · ~16 minuti"
narrate "In questa sezione lasciamo le slide e passiamo al terminale."
narrate "Eseguiamo 3 demo Apple (FoundationModels su macOS host) e 2 demo Google"
narrate "(Gemma via ollama). Tutto on-device, zero rete."
echo
status_info "Setup: macOS 26 · Apple Silicon · Apple Intelligence attivo"
status_info "Modello Apple: SystemLanguageModel.default (~3B parametri quantizzato)"
status_info "Modello Google: gemma3:4b (4B parametri, GPU Metal)"
pause_msg "iniziare"

# ============================================================
# DEMO 1 — Apple BasicChat
# ============================================================
clear_screen
banner "DEMO 1/${TOTAL}  ·  Apple FM Framework  ·  BasicChat" \
       "LanguageModelSession + respond(to:)"

narrate "Una sessione, un prompt, una risposta. La cosa piu semplice possibile."
narrate "Il modello e' lo stesso che alimenta Writing Tools, Genmoji, Image Playground."
echo
status_info "Codice (10 righe Swift):"
echo "${C_GREY}"
cat <<'SWIFT'
    import FoundationModels

    let session = LanguageModelSession()
    let response = try await session.respond(
        to: "Spiegami in 3 frasi cos'e un foundation model on-device."
    )
    print(response.content)
SWIFT
echo "${C_RESET}"
show_cmd "cd apple && swift run BasicChat"
pause_msg "eseguire"

cd "$DEMO_ROOT/apple"
swift run BasicChat 2>&1 || status_warn "Build fallita — verifica licenza Xcode + Apple Intelligence"
cd "$DEMO_ROOT"
pause

# ============================================================
# DEMO 2 — Apple Streaming
# ============================================================
clear_screen
banner "DEMO 2/${TOTAL}  ·  Apple FM Framework  ·  Streaming" \
       "streamResponse(to:) per UX reattiva"

narrate "Streaming token-by-token: la differenza tra 'app lenta' e 'app reattiva'."
narrate "Time-to-first-token e' la metrica che conta, non la latenza totale."
echo
status_info "Codice differenza chiave: streamResponse vs respond"
echo "${C_GREY}"
cat <<'SWIFT'
    let stream = session.streamResponse(to: prompt)
    for try await partial in stream {
        // partial.content si aggiorna progressivamente
        update(ui: partial.content)
    }
SWIFT
echo "${C_RESET}"
show_cmd "cd apple && swift run StreamingChat"
pause_msg "eseguire"

cd "$DEMO_ROOT/apple"
swift run StreamingChat 2>&1 || status_warn "Errore demo streaming"
cd "$DEMO_ROOT"
pause

# ============================================================
# DEMO 3 — Apple Tool Calling
# ============================================================
clear_screen
banner "DEMO 3/${TOTAL}  ·  Apple FM Framework  ·  Tool Calling" \
       "@Generable + Tool protocol = orchestrator gratis"

narrate "Definiamo 2 tool (meteo + calcolatrice). Li passiamo alla sessione."
narrate "Il modello decide AUTONOMAMENTE quale tool chiamare e con quali argomenti."
narrate "Nessuna logica di routing scritta da noi. @Guide aiuta il modello sui parametri."
echo
status_info "Codice — Weather tool (estratto):"
echo "${C_GREY}"
cat <<'SWIFT'
    struct WeatherTool: Tool {
        let name = "getWeather"
        let description = "Restituisce il meteo per una citta italiana."

        @Generable
        struct Arguments {
            @Guide(description: "Nome della citta")
            let city: String
        }

        func call(arguments: Arguments) async throws -> ToolOutput { ... }
    }

    let session = LanguageModelSession(tools: [WeatherTool(), CalculatorTool()])
    try await session.respond(to: "Tempo a Bologna? 144 / 12?")
SWIFT
echo "${C_RESET}"
show_cmd "cd apple && swift run ToolCalling"
pause_msg "eseguire"

cd "$DEMO_ROOT/apple"
swift run ToolCalling 2>&1 || status_warn "Errore demo tool calling"
cd "$DEMO_ROOT"
pause

# ============================================================
# DEMO 4 — Google Gemma BasicChat
# ============================================================
clear_screen
banner "DEMO 4/${TOTAL}  ·  Google Gemma  ·  BasicChat" \
       "Su Android: AICore + Gemini Nano. Su Mac: Gemma via ollama."

narrate "Su Android, l'API canonica e' la GenerativeModel di AICore con Gemini Nano."
narrate "Da CLI Mac usiamo Gemma 3 — stessa famiglia Google, stessa filosofia"
narrate "on-device. Concettualmente equivalente per dimostrare l'API pattern."
echo
status_info "Equivalente Android (Kotlin):"
echo "${C_GREY}"
cat <<'KOTLIN'
    val client = GenerativeModel(GenerationConfig.builder().build())
    val response = client.generateContent("Spiegami...")
    println(response.text)
KOTLIN
echo "${C_RESET}"
show_cmd "ollama run gemma3:4b 'Spiegami in 3 frasi cos'\\''e un foundation model on-device.'"
pause_msg "eseguire"

bash "$DEMO_ROOT/google/basic-chat.sh" "Spiegami in 3 frasi cos'e un foundation model on-device."
pause

# ============================================================
# DEMO 5 — Google Function Calling pattern
# ============================================================
clear_screen
banner "DEMO 5/${TOTAL}  ·  Google  ·  Function Calling Pattern" \
       "Structured prompting · pattern equivalente a FunctionGemma 270M / AppFunctions API"

narrate "Su Android moderno: AppFunctions API (Android 16/API 36) +"
narrate "FunctionGemma 270M fine-tuned. Qui dimostriamo il pattern equivalente"
narrate "con Gemma 3 + structured prompt: il modello genera una tool-call JSON,"
narrate "noi facciamo dispatch. Stesso paradigma, modello piu generico."
echo
show_cmd "bash google/function-calling.sh 'Che tempo fa a Bologna oggi?'"
pause_msg "eseguire"

bash "$DEMO_ROOT/google/function-calling.sh" "Che tempo fa a Bologna oggi?"
pause

# ============================================================
# Wrap-up
# ============================================================
clear_screen
banner "DEMO LIVE COMPLETATA" "Cosa abbiamo visto in 16 minuti"

echo
status_ok "Apple FM Framework: 10 righe Swift per integrare AI in un'app iOS"
status_ok "@Generable + Tool: il modello orchestra i tool autonomamente"
status_ok "Streaming: time-to-first-token come metrica di UX"
status_ok "Google Gemma on-device: stesso paradigma, ecosistema diverso"
status_ok "Function calling: pattern universale (structured prompt + dispatch)"
echo
narrate "Tutto on-device. Zero round-trip di rete. Zero costi cloud."
narrate "Privacy by default. Latenza determinata solo dall'hardware locale."
echo
status_info "Torniamo alle slide per il wrap-up: decision matrix, anti-pattern, futuro."
echo
pause_msg "tornare al deck"
