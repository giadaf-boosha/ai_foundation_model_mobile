# Seminario — Foundation Models On-Device su iOS e Android

> **Sede**: Università di Bologna · **Docente referente**: Prof. Federico Montori
> **Relatrice**: Giada Franceschini
> **Durata**: 2 ore (120 minuti) · **Slot proposti**: 11-14 maggio 2026 (lun 16-18, mar 9-11, gio 9-11)
> **Audience**: studenti di Informatica/Ingegneria Informatica/Data Science (laurea magistrale e triennale avanzata)
> **Lingua**: italiano (codice e termini tecnici in inglese)

---

## 1. Abstract

I Foundation Models hanno smesso di essere un'esclusiva del cloud. Tra il 2024 e il 2026 due cambiamenti hanno reso possibile l'inferenza di LLM da 1-4 miliardi di parametri direttamente su smartphone: l'arrivo di NPU dedicate (Apple Neural Engine, Google Tensor TPU, Qualcomm Hexagon) e la maturazione di tecniche di quantizzazione aggressive (4-bit standard, 1.58-bit con BitNet, sub-1-bit con NanoQuant). Il risultato è una nuova categoria di applicazioni: **personali per costruzione, offline per default, a costo marginale di inferenza nullo per lo sviluppatore**.

Il seminario presenta lo stato dell'arte ad aprile 2026 dei foundation model on-device sui due ecosistemi mobili dominanti — Apple Foundation Models Framework (iOS 26) e Google Gemma 4 / Gemini Nano 4 / LiteRT-LM (Android) — confrontando API, modelli, hardware e pattern di integrazione nativa. Si analizzano le tecniche di quantizzazione, le architetture agentiche con tool calling on-device, l'adozione del Model Context Protocol e i benchmark pubblici (MLPerf v6.0). Una demo live mostra la stessa funzionalità implementata su Swift e Kotlin.

---

## 2. Learning outcomes

Al termine del seminario, il partecipante sarà in grado di:

1. **Spiegare** quando l'inferenza on-device è una scelta architetturale corretta (privacy, latenza, costi, offline) e quando il cloud rimane preferibile.
2. **Descrivere** l'architettura del modello on-device Apple (~3B, MoE sparse, 2-bit QAT) e della famiglia Gemma 4 (E2B/E4B con MatFormer + PLE) confrontandone le scelte.
3. **Implementare** una chat e un'integrazione tool-calling con `LanguageModelSession` (Swift) e ML Kit GenAI APIs / LiteRT-LM (Kotlin).
4. **Scegliere** la quantizzazione corretta tra GGUF, AWQ, GPTQ, BitNet 1.58, NanoQuant valutando trade-off qualità/dimensione/latenza.
5. **Progettare** un agente ReAct on-device con memoria episodica usando le primitive Apple (Tool protocol) o FunctionGemma 270M.
6. **Valutare** i risultati pubblici MLPerf v6.0 e i benchmark di terze parti (Argmax, llmcheck.net) per scegliere il dispositivo target.

---

## 3. Prerequisiti

- Conoscenza di base dei LLM (transformer, tokenizzazione, prompt) — copertura rapida nei primi 5 min.
- Esperienza con almeno un linguaggio tra Swift e Kotlin (la demo mostra entrambi).
- Familiarità con concetti di mobile development (lifecycle, MVVM) — bonus, non requisito.

---

## 4. Struttura temporale (120 min)

| Slot | Min. | Topic | Attività |
|------|------|-------|----------|
| **0** | 5  | Apertura, contesto, motivazioni | Speech |
| **1** | 10 | Perché on-device? Quattro vantaggi e tre limiti | Speech + tabella |
| **2** | 15 | Apple Foundation Models Framework — architettura e API | Speech + codice |
| **3** | 15 | Google Gemma 4 / Gemini Nano 4 / LiteRT-LM | Speech + codice |
| **4** | 10 | Hardware: A19 Pro, M5, Tensor G5, Snapdragon 8 Elite Gen 5 | Tabella comparativa |
| **5** | 15 | Quantizzazione: dal GGUF a BitNet 1.58 e NanoQuant | Speech + esempi numerici |
| **6** | 15 | **Demo live**: Swift `LanguageModelSession` + Kotlin ML Kit | Demo dal vivo |
| **7** | 10 | Function calling / Tool protocol / FunctionGemma — pattern agentico | Speech + diagramma |
| **8** | 5  | MCP: stato e prospettive mobile | Speech |
| **9** | 5  | Benchmark MLPerf v6.0 + numeri pubblici da Argmax e llmcheck | Tabella |
| **10**| 10 | Q&A | Discussione |
| **11**| 5  | Risorse, repository, take-away | Slide finale |

> **Buffer**: l'agenda include 5 min di buffer cumulativo distribuiti tra Q&A e demo (riserva per eventuali rallentamenti tecnici).

---

## 5. Outline slide (proposta — ~45 slide)

### Parte I — Motivazioni e panorama (slide 1-8)

1. **Cover** — titolo, autrice, sede, data.
2. **Chi sono** — profilo brevissimo, contesto Boosha AI / UniBO.
3. **L'AI è arrivata sul telefono** — una frase, una statistica (es. 2.5 miliardi smartphone Apple Intelligence-ready entro fine 2026).
4. **Perché ora?** — convergenza NPU + quantizzazione + modelli small+capable.
5. **I quattro vantaggi** — privacy, latenza (<100 ms), offline, zero costo inferenza.
6. **I tre limiti** — qualità < frontier cloud, context window limitato, modello unico per app.
7. **Quando on-device, quando cloud** — decision tree.
8. **Roadmap del seminario** — agenda visiva.

### Parte II — Apple ecosystem (slide 9-17)

9. **Apple Intelligence: la pila** — Foundation Models Framework, Core ML/Core AI, MLX.
10. **Modello on-device** — ~3B, MoE, 2-bit QAT, 4096 context, 16 lingue.
11. **`LanguageModelSession`** — codice minimo (chat, streaming).
12. **`@Generable` e guided generation** — esempio struct + uso con `respond(generating:)`.
13. **Tool protocol** — funzione calcolatrice come Tool, esempio.
14. **iOS 26.4 novità** — `contextSize`, `tokenCount(for:)`, retrocompatibilità.
15. **MLX e Neural Accelerators M5** — 4× TTFT vs M4, sessione WWDC25 #298.
16. **LoRA adapters** — workflow training + entitlement App Store.
17. **WWDC 2026 anticipazioni** — Core AI, Siri Gemini, Siri Extensions (label "rumor").

### Parte III — Google ecosystem (slide 18-25)

18. **Android AI stack** — App → ML Kit/AICore → LiteRT-LM → Hardware.
19. **Gemini Nano: storia in 4 versioni** — Nano-1 (1.8B) → Nano-4 (E2B/E4B Gemma 4 base).
20. **Gemma 4: 4 varianti, 1 codebase** — tabella E2B/E4B/26B-MoE/31B Dense.
21. **MatFormer + Per-Layer Embeddings** — diagramma architetturale concettuale.
22. **ML Kit GenAI APIs** — Summarization/Rewriting/Proofreading/Image Description (codice Kotlin).
23. **LiteRT-LM** — runtime cross-platform, perché sostituisce MediaPipe LLM.
24. **FunctionGemma 270M** — function calling specializzato edge, 85% mobile-actions accuracy.
25. **AICore Developer Preview** — come accedere oggi a Gemini Nano 4.

### Parte IV — Hardware e quantizzazione (slide 26-32)

26. **Hardware iOS** — tabella A17 Pro / A18 / A19 / A19 Pro + RAM minima 8 GB.
27. **Hardware Android** — Tensor G4/G5, Snapdragon 8 Elite/Gen 5 (~100 TOPS).
28. **Energia: NPU vs CPU** — 10-14× a 64 token, 35-60× a 1024 token.
29. **Quantizzazione: il panorama** — GGUF, AWQ, GPTQ, AQLM, HQQ, SpinQuant, NVFP4/MXFP4.
30. **BitNet b1.58 2B4T** — 0.4 GB di RAM, 1.58 bit nativi, smartphone 4 GB senza offload.
31. **NanoQuant** — Llama2-70B da 138 GB → 5.35 GB (sub-1-bit PTQ).
32. **i-quants in llama.cpp** — IQ4_NL come SOTA accessibile.

### Parte V — Demo live e agenti (slide 33-40)

33. **Demo: setup** — Xcode 17 + Android Studio, dispositivi target.
34. **Demo Swift**: chat → guided generation → tool calling (live).
35. **Demo Kotlin**: ML Kit Summarization → Prompt API → FunctionGemma stub (live).
36. **Architetture agentiche on-device** — ReAct, Plan-and-Execute, Mobile-Agent-v2.
37. **Memoria episodica** — quattro tipologie, perché conta.
38. **Model Context Protocol** — cos'è, dove sta, su mobile (developer tooling oggi, consumer attesa H2 2026).
39. **Pattern: agente personale offline** — diagramma end-to-end.
40. **Privacy by design** — Private Cloud Compute (Apple) vs Private Compute Core (Google).

### Parte VI — Chiusura (slide 41-45)

41. **Benchmark MLPerf v6.0** — task edge object-detection, mobile sub-suite.
42. **Numeri reali** — A19 Pro 3.1× iPhone 16 Pro (Argmax), iPad Pro M5 1.2-2.2× iPhone 17 Pro.
43. **Cosa proverei domani mattina** — 3 esercizi pratici.
44. **Risorse** — repo GitHub `ai_foundation_model_mobile`, link RESOURCES.md, SOTA_2026.md.
45. **Q&A + grazie**.

---

## 6. Demo live — script ed esecuzione

### 6.1 Setup hardware

| Item | Specifica |
|------|-----------|
| Mac | Apple Silicon M2/M3 (per Xcode + Simulator) |
| iPhone reale | iPhone 15 Pro o successivo (Apple Intelligence abilitato) |
| Android | Pixel 9/10 (per ML Kit GenAI + Gemini Nano) |
| Cavi | Lightning/USB-C, dock USB, HDMI per proiettore |
| Backup | Video pre-registrato delle stesse demo (fallback) |

### 6.2 Script demo Swift (5 min)

```swift
import FoundationModels

// 1. Chat semplice
let session = LanguageModelSession()
let r = try await session.respond(to: "Spiega in 2 frasi cosa fa il Neural Engine.")
print(r)

// 2. Guided generation
@Generable
struct ConceptCard {
    @Guide(description: "Titolo del concetto, max 60 caratteri") var title: String
    @Guide(.anyOf(["base", "intermedio", "avanzato"])) var level: String
    @Guide(description: "Spiegazione in massimo 3 frasi") var explanation: String
}
let card = try await session.respond(
    to: "Crea una scheda concetto per: quantizzazione 4-bit",
    generating: ConceptCard.self
)
// 3. Tool calling
struct WeatherTool: Tool {
    let name = "getWeather"
    let description = "Restituisce il meteo di una città"
    @Generable struct Arguments { var city: String }
    func call(arguments: Arguments) async throws -> String {
        "A \(arguments.city) ci sono 22°C e sole."
    }
}
let s2 = LanguageModelSession(tools: [WeatherTool()])
let r2 = try await s2.respond(to: "Che tempo fa a Bologna?")
```

### 6.3 Script demo Kotlin (5 min)

```kotlin
// 1. ML Kit GenAI Summarization
val summarizer = Summarization.getClient(
    SummarizerOptions.builder(context)
        .setOutputType(SummarizerOptions.OutputType.ONE_BULLET)
        .build()
)
summarizer.runInference(longArticle).get()

// 2. Prompt API (free-form)
val genAi = GenAi.getClient(GenAiOptions.builder(context).build())
val out = genAi.runInference("Spiega in italiano cosa fa LiteRT-LM in 3 punti.").get()

// 3. FunctionGemma stub (concettuale)
val tools = listOf(
    Tool("getWeather", schema = mapOf("city" to "string"))
)
val agent = FunctionAgent(model = FunctionGemma270M, tools = tools)
agent.run("Che tempo fa a Bologna?")
```

### 6.4 Piano B — fallback

Se Apple Intelligence non è abilitato/disponibile, usare lo **Xcode Playground per Foundation Models** che gira nel Simulator. Per Android, fallback su **AI Studio web** mostrando lo stesso prompt sui modelli cloud (con disclaimer "non è on-device, è solo per illustrare lo schema").

---

## 7. Bibliografia per approfondimento

### Primarie

- Giada Franceschini, *ai_foundation_model_mobile* — repo: <https://github.com/giadaf-boosha/ai_foundation_model_mobile> (in particolare `SOTA_2026.md`, `concepts_theory.md`, `RESOURCES.md`).
- Apple, *Foundation Models — Apple Developer Documentation*, 2025-2026, <https://developer.apple.com/documentation/FoundationModels>.
- Apple ML Research, *Apple Foundation Models Tech Report 2025*, <https://machinelearning.apple.com/research/apple-foundation-models-tech-report-2025>.
- Apple ML Research, *Updates to Apple's Foundation Models 2025*, <https://machinelearning.apple.com/research/apple-foundation-models-2025-updates>.
- Apple ML Research, *Exploring LLMs with MLX and the Neural Accelerators in the M5 GPU*, gennaio 2026, <https://machinelearning.apple.com/research/exploring-llms-mlx-m5>.
- Google, *Gemma 4*, blog.google, 2 aprile 2026, <https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/>.
- Google, *Announcing Gemma 4 in the AICore Developer Preview*, aprile 2026, <https://android-developers.googleblog.com/2026/04/AI-Core-Developer-Preview.html>.
- Google, *LiteRT-LM Overview*, <https://ai.google.dev/edge/litert-lm/overview>.

### Paper accademici

- *Apple Intelligence Foundation Language Models 2025* — arXiv [2507.13575](https://arxiv.org/abs/2507.13575).
- Ma et al., *BitNet b1.58 2B4T: Native 1-bit LLMs at Scale* — arXiv [2504.12285](https://arxiv.org/abs/2504.12285).
- *NanoQuant: Sub-1-Bit Post-Training Quantization* — arXiv [2602.06694](https://arxiv.org/abs/2602.06694).
- Liu et al., *SpinQuant: LLM quantization with learned rotations* — arXiv [2405.16406](https://arxiv.org/abs/2405.16406).
- Wang et al., *Mobile-Agent-v2*, NeurIPS 2024, <https://neurips.cc/virtual/2024/poster/95398>.
- *GUI Agents: A Survey* — arXiv [2504.19838](https://arxiv.org/abs/2504.19838).
- *Fast On-device LLM Inference with NPUs*, ASPLOS 2025, <https://xumengwei.github.io/files/ASPLOS25-NPU.pdf>.

### Standard ed ecosistema

- *Model Context Protocol Specification*, <https://modelcontextprotocol.io/specification/2025-11-25>.
- *MCP 2026 Roadmap*, <https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/>.
- MLCommons, *MLPerf Inference v6.0 Results*, aprile 2026, <https://mlcommons.org/2026/04/mlperf-inference-v6-0-results/>.

### Open source / runtime

- ggml-org, *llama.cpp*, <https://github.com/ggml-org/llama.cpp>.
- PyTorch, *ExecuTorch*, <https://github.com/pytorch/executorch> · <https://executorch.ai/>.
- Google AI Edge, *LiteRT-LM*, <https://github.com/google-ai-edge/LiteRT-LM>.
- Apple, *MLX*, <https://github.com/ml-explore/mlx>.
- Microsoft, *BitNet*, <https://github.com/microsoft/BitNet>.

---

## 8. Take-away (slide finale)

> Tre cose da portarsi a casa:
>
> 1. **L'on-device non è più un esperimento**: Apple Foundation Models e Google Gemma 4 sono API stabili, GA, con SDK ufficiali e tooling Xcode/Android Studio.
> 2. **La quantizzazione è il vero abilitatore**: senza 4-bit standard e BitNet 1.58 nessun modello da 2-4 B parametri girerebbe sul telefono. Studiate quella, non solo i modelli.
> 3. **Il prossimo salto è l'agente mobile**: tool calling nativo (Tool protocol Apple, Gemma 4) + memoria episodica + MCP = personal AI offline. È l'area dove ci sono ancora le lacune più grandi e quindi le opportunità.

---

## 9. Domande di stimolo per la discussione finale

- Quale use case del vostro corso/progetto trarrebbe il massimo vantaggio dall'on-device?
- Come progettereste un'app che funziona "entrambi": on-device per default, cloud opzionale per qualità?
- Quale evoluzione dell'hardware mobile (RAM? NPU TOPS? bandwidth?) sbloccherebbe il prossimo livello?
- MCP arriverà su mobile consumer? Su quale ecosistema prima — Android o iOS?

---

*Versione 1.0 — 29 aprile 2026 · Giada Franceschini*
