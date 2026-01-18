# Foundation Model On-Device per Dispositivi Mobili

> Ricerca approfondita sui foundation model locali per iOS e Android, architetture agentiche e integrazione nelle app mobile.

---

## Contenuti del repository

| File | Descrizione |
|------|-------------|
| **[concepts_theory.md](concepts_theory.md)** | Guida teorica completa ai concetti fondamentali. Solo testo, nessun codice. Ideale per comprendere i concetti. |
| **[original_report.md](original_report.md)** | Report completo con esempi di codice Swift e Kotlin. Include implementazioni passo-passo per iOS e Android. |
| **[RESOURCES.md](RESOURCES.md)** | Raccolta curata di link a documentazione, tutorial, articoli, repository GitHub, paper accademici e cookbook. |

---

## Argomenti trattati

1. **Foundation model on-device** - Definizione, vantaggi, sfide tecniche, stato dell'arte 2026
2. **Ecosistema Apple** - Foundation Models Framework, guided generation, tool calling, LoRA
3. **Ecosistema Google** - Gemini Nano, Gemma 3n, ML Kit GenAI, MediaPipe
4. **Parametri di configurazione** - Temperature, top-k, top-p, context window, seed
5. **Architetture agentiche** - ReAct, planning agents, multi-agent, memoria gerarchica
6. **Function calling e tools** - MCP, FunctionGemma, implementazioni pratiche
7. **Quantizzazione** - PTQ, QAT, GGUF, ottimizzazioni mobile
8. **Confronto iOS vs Android** - Hardware, API, facilità di sviluppo, quando scegliere cosa

---

## Quick links

### Documentazione ufficiale

#### Apple
- [Foundation Models Documentation](https://developer.apple.com/documentation/FoundationModels)
- [WWDC25: Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25: Deep dive into Foundation Models](https://developer.apple.com/videos/play/wwdc2025/301/)
- [Apple ML Research](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates)

#### Google
- [Gemini Nano Overview](https://developer.android.com/ai/gemini-nano)
- [ML Kit GenAI APIs](https://developers.google.com/ml-kit/genai)
- [MediaPipe LLM Inference](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference)
- [Gemma 3n Announcement](https://developers.googleblog.com/en/introducing-gemma-3n/)
- [FunctionGemma](https://blog.google/technology/developers/functiongemma/)
- [Google AI Edge Gallery](https://github.com/google-ai-edge/gallery)

### Repository GitHub essenziali

| Repository | Descrizione |
|------------|-------------|
| [ml-explore/mlx-swift](https://github.com/ml-explore/mlx-swift) | MLX per Swift (Apple) |
| [ml-explore/mlx-swift-examples](https://github.com/ml-explore/mlx-swift-examples) | Esempi MLX Swift |
| [google-gemini/gemma-cookbook](https://github.com/google-gemini/gemma-cookbook) | Cookbook ufficiale Gemma |
| [google-ai-edge/gallery](https://github.com/google-ai-edge/gallery) | Google AI Edge Gallery |
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | Inference LLM in C/C++ |
| [stevelaskaridis/awesome-mobile-llm](https://github.com/stevelaskaridis/awesome-mobile-llm) | Lista curata mobile LLM |

### Tutorial consigliati

| Titolo | Piattaforma | Link |
|--------|-------------|------|
| Getting Started with Apple's Foundation Models | iOS | [Blog](https://artemnovichkov.com/blog/getting-started-with-apple-foundation-models) |
| The Ultimate Guide To Foundation Models Framework | iOS | [AzamSharp](https://azamsharp.com/2025/06/18/the-ultimate-guide-to-the-foundation-models-framework.html) |
| Complete Guide to Running LLMs on Android with MediaPipe | Android | [Medium](https://rockyshikoku.medium.com/running-llm-on-android-devices-complete-guide-with-mediapipe-on-device-inference-957daa537f52) |
| LLM Inference on Edge with React Native | Cross-platform | [Hugging Face](https://huggingface.co/blog/llm-inference-on-edge) |
| On-Device Function Calling with FunctionGemma | Android | [Medium](https://medium.com/google-developer-experts/on-device-function-calling-with-functiongemma-39f7407e5d83) |

> **Vedi [RESOURCES.md](RESOURCES.md) per la lista completa di risorse!**

---

## Come usare questo repository

### Per capire i concetti teorici
Inizia da **[concepts_theory.md](concepts_theory.md)** - spiega tutto in linguaggio discorsivo senza codice.

### Per implementare
Passa a **[original_report.md](original_report.md)** - contiene esempi di codice Swift e Kotlin pronti all'uso.

### Per approfondire
Consulta **[RESOURCES.md](RESOURCES.md)** - contiene link a tutorial, paper, cookbook e repository per ogni argomento.

---

## Contribuire

Se conosci risorse utili non incluse, apri una issue o una pull request!

---

*Ricerca completata: Gennaio 2026*
