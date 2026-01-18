<div align="center">

# Foundation Models On-Device

**Guida completa ai Large Language Models su dispositivi mobili iOS e Android**

[![Research Status](https://img.shields.io/badge/status-research-blue?style=for-the-badge)](https://github.com/giadaf-boosha/ai_foundation_model_mobile)
[![Last Updated](https://img.shields.io/badge/updated-January%202026-green?style=for-the-badge)](#)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-lightgrey?style=for-the-badge)](#)
[![Language](https://img.shields.io/badge/lang-IT-red?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/license-MIT-orange?style=for-the-badge)](LICENSE)

<br/>

[**Quick Start**](#-quick-start) · [**Documentation**](#-contenuti) · [**Examples**](#-esempi-di-codice) · [**Contribute**](#-contribuire)

<br/>

<img src="https://developer.apple.com/news/images/og/apple-intelligence-og.png" alt="On-Device AI" width="600"/>

*Esegui LLM direttamente su smartphone: privacy totale, zero latenza, funzionamento offline*

</div>

---

## Overview

Questo repository contiene una **ricerca approfondita** sui foundation model che possono essere eseguiti localmente su dispositivi mobili, senza dipendenza dal cloud.

### Perche on-device AI?

| Vantaggio | Descrizione |
|-----------|-------------|
| **Privacy** | I dati non lasciano mai il dispositivo |
| **Latenza** | Risposte istantanee senza round-trip di rete |
| **Offline** | Funziona senza connessione internet |
| **Costi** | Zero costi di inference cloud |

### Quando usare questa guida

- Stai sviluppando un'app iOS/Android con AI locale
- Vuoi capire le differenze tra Apple FM, Gemini Nano e Gemma
- Hai bisogno di implementare function calling on-device
- Vuoi ottimizzare modelli LLM per mobile (quantizzazione)

---

## Key Features

- **Documentazione completa** - Guide teoriche e pratiche in italiano
- **Ecosistema Apple** - Foundation Models Framework, guided generation, LoRA
- **Ecosistema Google** - Gemini Nano, Gemma 3n, MediaPipe, FunctionGemma
- **Tabelle comparative** - iOS vs Android, modelli, hardware NPU, performance
- **Codice pronto all'uso** - 6 esempi Swift e Kotlin funzionanti
- **100+ risorse curate** - Link a docs ufficiali, paper, tutorial

---

## Quick Start

### Per capire i concetti (no codice)

```bash
# Leggi la guida teorica
open concepts_theory.md
```

### Per implementare subito (iOS)

```swift
import FoundationModels

let session = LanguageModelSession()
let response = try await session.respond(to: "Ciao!")
print(response)
```

### Per implementare subito (Android)

```kotlin
val inference = InferenceClient.create(context)
val response = inference.generate("Ciao!")
println(response)
```

> **Vedi [examples/](examples/)** per codice completo pronto da copiare.

---

## Contenuti

### Documenti principali

| File | Descrizione |
|:-----|:------------|
| [**concepts_theory.md**](concepts_theory.md) | Guida teorica completa (no codice) |
| [**original_report.md**](original_report.md) | Report con esempi Swift e Kotlin |
| [**RESOURCES.md**](RESOURCES.md) | 100+ link curati |
| [**comparisons.md**](comparisons.md) | Tabelle comparative dettagliate |

### Approfondimenti tematici

| File | Argomento |
|:-----|:----------|
| [**deep_dives/quantization.md**](deep_dives/quantization.md) | GGUF, GPTQ, AWQ, QAT vs PTQ |
| [**deep_dives/agentic_architectures.md**](deep_dives/agentic_architectures.md) | ReAct, planning agents, multi-agent |
| [**deep_dives/function_calling.md**](deep_dives/function_calling.md) | Tool calling Apple/Google, MCP |
| [**deep_dives/personal_intelligence.md**](deep_dives/personal_intelligence.md) | Google Personal Intelligence (Gen 2026) |

---

## Esempi di codice

### iOS (Swift)

| File | Complessita | Descrizione |
|:-----|:------------|:------------|
| [BasicChat.swift](examples/ios/BasicChat.swift) | Base | Chat semplice con sessione |
| [StreamingChat.swift](examples/ios/StreamingChat.swift) | Intermedio | Streaming token-by-token |
| [ToolCallingExample.swift](examples/ios/ToolCallingExample.swift) | Avanzato | Weather, Calculator, Reminder tools |

### Android (Kotlin)

| File | Complessita | Descrizione |
|:-----|:------------|:------------|
| [BasicChatActivity.kt](examples/android/BasicChatActivity.kt) | Base | Chat con Gemini Nano |
| [MediaPipeLLMExample.kt](examples/android/MediaPipeLLMExample.kt) | Intermedio | Modelli Gemma custom |
| [FunctionCallingExample.kt](examples/android/FunctionCallingExample.kt) | Avanzato | FunctionGemma tools |

<details>
<summary><strong>Requisiti per gli esempi</strong></summary>

#### iOS
- Xcode 17+
- iOS 26+ / macOS 26+
- Dispositivo con Apple Intelligence (A17 Pro+)

#### Android
- Android Studio Ladybug+
- Android 14+ (API 34+)
- Dispositivo con AICore o MediaPipe

</details>

---

## Argomenti trattati

| # | Argomento | Copertura |
|:-:|:----------|:----------|
| 1 | Foundation model on-device | Definizione, vantaggi, sfide, stato 2026 |
| 2 | Ecosistema Apple | FM Framework, guided generation, LoRA |
| 3 | Ecosistema Google | Gemini Nano, Gemma 3n, MediaPipe |
| 4 | Parametri di generazione | Temperature, top-k, top-p, context window |
| 5 | Architetture agentiche | ReAct, planning, multi-agent, memoria |
| 6 | Function calling | MCP, FunctionGemma, Tool protocol |
| 7 | Quantizzazione | PTQ, QAT, GGUF, AWQ, GPTQ |
| 8 | Confronto piattaforme | Hardware, API, DX, decision matrix |
| 9 | Personal Intelligence | Cloud vs on-device, context packing |

---

## Struttura del repository

```
ai/
├── README.md                     # Questo file
├── concepts_theory.md            # Guida teorica
├── original_report.md            # Report con codice
├── RESOURCES.md                  # Link curati
├── comparisons.md                # Tabelle comparative
│
├── deep_dives/                   # Approfondimenti
│   ├── quantization.md
│   ├── agentic_architectures.md
│   ├── function_calling.md
│   └── personal_intelligence.md
│
└── examples/                     # Codice
    ├── ios/                      # Swift examples
    └── android/                  # Kotlin examples
```

---

## Quick Links

<table>
<tr>
<td width="50%">

### Apple

- [Foundation Models Docs](https://developer.apple.com/documentation/FoundationModels)
- [WWDC25: Meet FM Framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25: Deep Dive FM](https://developer.apple.com/videos/play/wwdc2025/301/)
- [Apple ML Research](https://machinelearning.apple.com/research/)

</td>
<td width="50%">

### Google

- [Gemini Nano](https://developer.android.com/ai/gemini-nano)
- [ML Kit GenAI](https://developers.google.com/ml-kit/genai)
- [MediaPipe LLM](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference)
- [Gemma 3n](https://developers.googleblog.com/en/introducing-gemma-3n/)

</td>
</tr>
</table>

### GitHub essenziali

| Repository | Descrizione |
|:-----------|:------------|
| [ml-explore/mlx-swift](https://github.com/ml-explore/mlx-swift) | MLX per Swift |
| [google-gemini/gemma-cookbook](https://github.com/google-gemini/gemma-cookbook) | Cookbook Gemma |
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | LLM inference C++ |
| [google-ai-edge/gallery](https://github.com/google-ai-edge/gallery) | AI Edge Gallery |

---

## Roadmap / Status

| Status | Descrizione |
|:------:|:------------|
| Done | Ricerca completata (Gennaio 2026) |
| Done | Documentazione teorica |
| Done | Esempi codice iOS/Android |
| Done | Deep dives tematici |
| Done | 100+ risorse curate |
| Ongoing | Aggiornamenti periodici |

> **Note:** Questo e un progetto di **ricerca e documentazione**, non una libreria software.

---

## Contribuire

I contributi sono benvenuti! Ecco come puoi aiutare:

- **Segnala errori** - Apri una [issue](https://github.com/giadaf-boosha/ai_foundation_model_mobile/issues)
- **Suggerisci risorse** - Conosci link utili non inclusi?
- **Traduzioni** - Aiuta a tradurre in altre lingue
- **Esempi di codice** - Aggiungi implementazioni

```bash
# Fork e clone
git clone https://github.com/YOUR_USERNAME/ai_foundation_model_mobile.git

# Crea branch
git checkout -b feature/my-contribution

# Commit e push
git commit -m "docs: add new resource"
git push origin feature/my-contribution

# Apri Pull Request
```

---

## License

Distribuito sotto licenza **MIT**. Vedi [LICENSE](LICENSE) per dettagli.

```
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

<div align="center">

**Se trovi utile questo repository, lascia una star!**

<br/>

[Torna all'inizio](#foundation-models-on-device)

<br/>

*Ricerca completata: Gennaio 2026*

</div>
