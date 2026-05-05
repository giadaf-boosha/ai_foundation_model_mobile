# Makefile — orchestratore demo seminario UniBO.
# Tutti i comandi pensati per essere eseguiti in ordine durante il talk.

SHELL := /usr/bin/env bash
DEMO_ROOT := $(shell pwd)
APPLE_DIR := $(DEMO_ROOT)/apple
GOOGLE_DIR := $(DEMO_ROOT)/google
RUNNER := $(DEMO_ROOT)/_runner

GEMMA_MODEL ?= gemma3:4b

.PHONY: help doctor doctor-pull seminar \
        demo-1 demo-2 demo-3 demo-4 demo-5 \
        demo-reset clean build-apple

help:
	@echo ""
	@echo "  Demo runner — Seminario UniBO Foundation Models On-Device"
	@echo ""
	@echo "  Setup:"
	@echo "    make doctor          Verifica ambiente (Xcode, ollama, modelli)"
	@echo "    make doctor-pull     Scarica modelli Gemma necessari"
	@echo "    make build-apple     Compila i 3 binari Swift Apple"
	@echo ""
	@echo "  Esecuzione:"
	@echo "    make seminar         Lancia tutta la sezione demo guidata (~16 min)"
	@echo "    make demo-1          Solo Apple BasicChat"
	@echo "    make demo-2          Solo Apple Streaming"
	@echo "    make demo-3          Solo Apple Tool Calling"
	@echo "    make demo-4          Solo Google Gemma BasicChat"
	@echo "    make demo-5          Solo Google Function Calling"
	@echo ""
	@echo "  Manutenzione:"
	@echo "    make demo-reset      Pulisce stato per replay"
	@echo "    make clean           Rimuove .build (Swift)"
	@echo ""

doctor:
	@bash $(RUNNER)/doctor.sh

doctor-pull:
	@echo "→ Pull Gemma 3 (4B) — ~3 GB, una tantum"
	@ollama pull gemma3:4b || true
	@echo "→ Pull Gemma 3n E2B (se disponibile) — ~1.5 GB"
	@ollama pull gemma3n:e2b 2>/dev/null || echo "  gemma3n:e2b non ancora pubblicato — useremo gemma3:4b"
	@echo "→ Modelli disponibili:"
	@ollama list | grep -i gemma || echo "  nessun gemma trovato"

build-apple:
	@cd $(APPLE_DIR) && swift build

seminar: build-apple
	@bash $(RUNNER)/seminar.sh

demo-1: build-apple
	@bash $(RUNNER)/banner.sh 1 5 "Apple FM Framework · BasicChat" "LanguageModelSession + respond(to:)"
	@cd $(APPLE_DIR) && swift run BasicChat

demo-2: build-apple
	@bash $(RUNNER)/banner.sh 2 5 "Apple FM Framework · Streaming" "streamResponse(to:) per UX reattiva"
	@cd $(APPLE_DIR) && swift run StreamingChat

demo-3: build-apple
	@bash $(RUNNER)/banner.sh 3 5 "Apple FM Framework · Tool Calling" "@Generable + Tool protocol"
	@cd $(APPLE_DIR) && swift run ToolCalling

demo-4:
	@bash $(RUNNER)/banner.sh 4 5 "Google Gemma · BasicChat" "Pattern equivalente AICore/Gemini Nano"
	@bash $(GOOGLE_DIR)/basic-chat.sh "Spiegami in 3 frasi cosa e un foundation model on-device."

demo-5:
	@bash $(RUNNER)/banner.sh 5 5 "Google · Function Calling Pattern" "Structured prompt + JSON dispatch"
	@bash $(GOOGLE_DIR)/function-calling.sh "Che tempo fa a Bologna oggi?"

demo-reset:
	@echo "→ Reset stato demo (nessuna persistenza al momento)"
	@echo "✓ Pronto per replay"

clean:
	@cd $(APPLE_DIR) && rm -rf .build
	@echo "✓ .build rimosso"
