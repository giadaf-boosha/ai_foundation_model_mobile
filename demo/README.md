# Demo Live — Seminario UniBO

Esecuzione interamente da CLI delle 5 demo del blocco D del seminario "Foundation Models On-Device su iOS e Android" (Prof. Federico Montori, maggio 2026).

Il **terminale sostituisce le slide 43-50** del deck: durante il talk, dopo la slide 43 (intro demo), si passa a tutto schermo nel terminale e si lancia `make seminar`.

## Setup (una tantum)

```bash
# 1. Accetta licenza Xcode (richiede sudo, una volta sola)
sudo xcodebuild -license accept

# 2. Verifica ambiente
cd demo
make doctor

# 3. Scarica modelli Gemma se mancanti
make doctor-pull

# 4. Compila i binari Swift Apple
make build-apple
```

## Esecuzione durante il talk

```bash
make seminar
```

Avvia la sequenza completa con pause `[invio per continuare]` tra le 5 demo. Giada controlla il ritmo dal terminale stesso, senza tornare al deck.

## Demo singole

| Target | Cosa fa | Tempo |
|---|---|---|
| `make demo-1` | Apple BasicChat (LanguageModelSession + respond) | ~2 min |
| `make demo-2` | Apple Streaming (streamResponse + TTFT) | ~3 min |
| `make demo-3` | Apple Tool Calling (Weather + Calculator) | ~4 min |
| `make demo-4` | Google Gemma BasicChat (ollama) | ~2 min |
| `make demo-5` | Google Function Calling Pattern (structured prompt + dispatch) | ~3 min |

## Stack

| Layer | Apple | Google |
|---|---|---|
| Modello | SystemLanguageModel.default (Apple Intelligence, ~3B) | gemma3:4b (4B params) |
| Runtime | FoundationModels (Swift 6, macOS 26) | ollama + Metal |
| API canonica device | iOS 26+ FoundationModels | Android: AICore + Gemini Nano |
| Surrogato CLI | macOS host con stesso framework | Gemma via ollama (stessa famiglia) |

## Onestà didattica

- **Apple**: stiamo usando il *vero* framework FoundationModels su Mac host. È esattamente lo stesso codice Swift che gira su iPhone con Apple Intelligence. Scelta architettonica: Mac come surrogato di iPhone per affidabilità in aula.
- **Google**: su Android moderno useresti `AICore + GenerativeModel` con Gemini Nano. Nano non gira su Mac. Sostituiamo con Gemma 3 via ollama — **stessa famiglia Google, stessa filosofia on-device**, paradigma API equivalente (input → output, tutto locale). Lo dichiariamo apertamente alla demo 4.
- **Function calling Google**: l'API canonica 2026 è AppFunctions (Android 16/API 36) + FunctionGemma 270M fine-tuned. Qui mostriamo il *pattern* equivalente con structured prompt + JSON dispatch su Gemma 3 generico. Il pattern è universale.

## Struttura

```
demo/
├── Makefile                # entry point
├── README.md               # questo file
├── DEMO_RUNBOOK.md         # cosa fare prima/durante/se fallisce
├── _runner/
│   ├── theme.sh            # colori, banner, helpers presentation-grade
│   ├── banner.sh           # header demo N/5
│   ├── step.sh             # esecuzione step con pausa
│   ├── doctor.sh           # health check
│   └── seminar.sh          # orchestratore 5 demo
├── apple/
│   ├── Package.swift       # Swift 6, macOS 26+
│   └── Sources/
│       ├── BasicChat/      # demo 1
│       ├── StreamingChat/  # demo 2
│       └── ToolCalling/    # demo 3 (Weather + Calculator)
└── google/
    ├── basic-chat.sh       # demo 4
    ├── function-calling.sh # demo 5
    └── prompts/
        └── function-template.txt
```

## Variabili ambiente

- `GEMMA_MODEL` — override modello ollama (default: `gemma3:4b`)
- `NO_COLOR` — disabilita output colorato (utile se proiettore ha problemi ANSI)
