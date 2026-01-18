# Tabelle Comparative: LLM On-Device per Mobile

> Confronti dettagliati tra piattaforme, modelli, API e performance per lo sviluppo di applicazioni AI mobile.

---

## Indice

1. [iOS vs Android - Overview](#ios-vs-android---overview)
2. [Modelli a confronto](#modelli-a-confronto)
3. [Hardware e NPU](#hardware-e-npu)
4. [API e framework](#api-e-framework)
5. [Performance benchmark](#performance-benchmark)
6. [Developer experience](#developer-experience)
7. [Casi d'uso e raccomandazioni](#casi-duso-e-raccomandazioni)

---

## iOS vs Android - Overview

### Confronto generale

| Aspetto | iOS (Apple) | Android (Google) |
|---------|-------------|------------------|
| **Modello principale** | Apple FM (~3B) | Gemini Nano / Gemma 3n |
| **Framework** | Foundation Models | ML Kit GenAI + MediaPipe |
| **Disponibilità** | iOS/macOS 26+ | Android 14+ (AICore) |
| **Approccio** | Verticalmente integrato | Modulare/flessibile |
| **Modelli custom** | LoRA adapters | Qualsiasi modello GGUF |
| **Privacy** | On-device only | On-device + cloud hybrid |
| **Linguaggio** | Swift | Kotlin/Java |

### Filosofia di piattaforma

| Caratteristica | Apple | Google |
|----------------|-------|--------|
| **Controllo** | Stretto (solo modello Apple) | Aperto (qualsiasi modello) |
| **Integrazione** | Profonda (OS + HW + SW) | Flessibile (componibile) |
| **Personalizzazione** | LoRA, prompt engineering | Fine-tuning, modelli custom |
| **Target dev** | iOS developers | Cross-platform, ML engineers |
| **Learning curve** | Bassa (3 linee di codice) | Media-alta |

---

## Modelli a confronto

### Modelli proprietari on-device

| Modello | Piattaforma | Parametri | Context | Specializzazione |
|---------|-------------|-----------|---------|------------------|
| **Apple FM** | iOS/macOS | ~3B | 4096 | General purpose |
| **Gemini Nano** | Android | Non pubblico | 1M+ | Summarization, rewriting |
| **Gemma 3n 2B** | Android/iOS | 2B | 8192 | Mobile-first |
| **Gemma 3n 4B** | Android/iOS | 4B | 8192 | Mobile balanced |

### Modelli open-source per mobile

| Modello | Parametri | Size (Q4) | Context | Velocità* | Use case |
|---------|-----------|-----------|---------|-----------|----------|
| **Gemma 3 1B** | 1B | ~500 MB | 2048 | ~150 tok/s | Chat veloce |
| **Gemma 3 4B** | 4B | ~2.6 GB | 8192 | ~90 tok/s | General purpose |
| **FunctionGemma** | 270M | ~288 MB | 512 | ~126 tok/s | Function calling |
| **Phi-3 Mini** | 3.8B | ~2.2 GB | 4096 | ~60 tok/s | Reasoning |
| **Llama 3.2 1B** | 1B | ~700 MB | 4096 | ~120 tok/s | Multilingual |
| **Llama 3.2 3B** | 3B | ~1.8 GB | 4096 | ~80 tok/s | General |
| **Qwen2.5 0.5B** | 500M | ~300 MB | 2048 | ~200 tok/s | Ultra-light |

*Velocità indicativa su dispositivi flagship 2025

### Confronto per task specifici

| Task | Miglior modello iOS | Miglior modello Android |
|------|---------------------|-------------------------|
| **Chat generale** | Apple FM | Gemma 3 4B |
| **Summarization** | Apple FM | Gemini Nano |
| **Function calling** | Apple FM (Tool) | FunctionGemma |
| **Code generation** | Apple FM | Gemma 3 4B |
| **Translation** | Apple FM | Gemma 3 4B |
| **Rewriting** | Apple FM | Gemini Nano |
| **Vision + text** | Apple FM* | Gemma 3n 4B |

*Con supporto multimodale in iOS 26

---

## Hardware e NPU

### Neural Processing Unit - Specifiche

| Chip | Dispositivo | NPU TOPS | RAM max | Anno |
|------|-------------|----------|---------|------|
| **A18 Pro** | iPhone 16 Pro | 35-40 | 8 GB | 2024 |
| **A18** | iPhone 16 | 30-35 | 8 GB | 2024 |
| **A17 Pro** | iPhone 15 Pro | 35 | 8 GB | 2023 |
| **M4** | iPad Pro | 38 | 16 GB | 2024 |
| **M4 Pro** | Mac | 40+ | 24 GB | 2024 |
| **Snapdragon 8 Elite** | Flagship Android | 75-100 | 16 GB | 2025 |
| **Snapdragon 8 Gen 3** | Flagship Android | 45-73 | 12 GB | 2024 |
| **Dimensity 9400** | Android high-end | 50+ | 12 GB | 2024 |
| **Tensor G4** | Pixel 9 | 40-45 | 12 GB | 2024 |

### Confronto architetture NPU

| Aspetto | Apple Neural Engine | Qualcomm Hexagon | Google Tensor |
|---------|---------------------|------------------|---------------|
| **Architettura** | Custom ASIC | DSP + AI Engine | TPU-like |
| **Precision** | INT8, FP16 | INT4, INT8, FP16 | INT8, BF16 |
| **Ottimizzazione** | CoreML native | SNPE, QNN | LiteRT native |
| **Power efficiency** | Eccellente | Molto buona | Buona |
| **Flessibilità** | Limitata | Alta | Media |

### Requisiti hardware per modelli

| Modello | RAM minima | NPU consigliato | Storage |
|---------|------------|-----------------|---------|
| **Apple FM** | 6 GB | A17 Pro+ | ~3 GB |
| **Gemini Nano** | 6 GB | Snapdragon 8 Gen 2+ | Variable |
| **Gemma 3 1B Q4** | 2 GB | Qualsiasi | 500 MB |
| **Gemma 3 4B Q4** | 4 GB | 8 Gen 2+ / A16+ | 2.6 GB |
| **FunctionGemma** | 1 GB | Qualsiasi | 288 MB |

---

## API e framework

### Stack tecnologico completo

| Layer | iOS | Android |
|-------|-----|---------|
| **High-level API** | Foundation Models | ML Kit GenAI |
| **Mid-level API** | - | MediaPipe LLM |
| **Low-level API** | CoreML | LiteRT (TFLite) |
| **Custom models** | MLX Swift | GGUF + llama.cpp |
| **Optimization** | Accelerate | XNNPACK, QNN |
| **Hardware** | ANE, GPU | Hexagon, GPU |

### Feature API comparison

| Feature | Foundation Models (iOS) | ML Kit GenAI (Android) |
|---------|-------------------------|------------------------|
| **Text generation** | ✅ | ✅ |
| **Streaming** | ✅ | ✅ |
| **Summarization** | Via prompt | ✅ API dedicata |
| **Rewriting** | Via prompt | ✅ API dedicata |
| **Proofreading** | Via prompt | ✅ API dedicata |
| **Image description** | ✅ iOS 26 | ✅ |
| **Guided generation** | ✅ @Generable | ❌ |
| **Tool calling** | ✅ Tool protocol | Manuale |
| **Session management** | ✅ | ✅ |
| **Custom models** | LoRA only | ✅ Qualsiasi |
| **Fine-tuning** | ❌ | ✅ Offline |

### Confronto API per task comuni

#### Generazione testo

**iOS (Swift)**
```swift
let session = LanguageModelSession()
let response = try await session.respond(to: "Ciao!")
```

**Android (Kotlin)**
```kotlin
val inference = InferenceClient.create(context)
val response = inference.generate("Ciao!")
```

**Linee di codice**: iOS 2, Android 2

#### Summarization

**iOS (Swift)**
```swift
let session = LanguageModelSession()
let response = try await session.respond(
    to: "Riassumi: \(longText)"
)
```

**Android (Kotlin)**
```kotlin
val summarizer = Summarization.getClient(config)
val summary = summarizer.summarize(longText)
```

**Linee di codice**: iOS 3, Android 2 (API dedicata)

---

## Performance benchmark

### Throughput (token/secondo)

| Dispositivo | Apple FM | Gemma 3 1B | Gemma 3 4B | FunctionGemma |
|-------------|----------|------------|------------|---------------|
| **iPhone 16 Pro** | ~136 | ~160 | ~45 | - |
| **iPhone 15 Pro** | ~120 | ~140 | ~40 | - |
| **Galaxy S25 Ultra** | - | ~150 | ~91 | ~126 |
| **Galaxy S24 Ultra** | - | ~130 | ~80 | ~110 |
| **Pixel 9 Pro** | - | ~140 | ~75 | ~115 |

### Time to First Token (TTFT)

| Dispositivo | Apple FM | Gemma 3 1B | Gemma 3 4B |
|-------------|----------|------------|------------|
| **iPhone 16 Pro** | ~150ms | ~80ms | ~200ms |
| **Galaxy S25 Ultra** | - | ~90ms | ~180ms |
| **Pixel 9 Pro** | - | ~100ms | ~220ms |

### Memory footprint

| Modello | Precision | RAM runtime | Storage |
|---------|-----------|-------------|---------|
| **Apple FM** | INT8/FP16 | ~4 GB | ~3 GB |
| **Gemma 3 1B** | Q4_K_M | ~1.5 GB | 500 MB |
| **Gemma 3 4B** | Q4_K_M | ~4 GB | 2.6 GB |
| **FunctionGemma** | INT8 | ~500 MB | 288 MB |
| **Gemini Nano** | Proprietario | ~2 GB | Variable |

### Battery impact

| Scenario | iOS (Apple FM) | Android (Gemma 3 4B) |
|----------|----------------|----------------------|
| **1 min chat** | ~1-2% | ~2-3% |
| **10 min chat** | ~8-10% | ~12-15% |
| **Background summarization** | ~0.5%/task | ~1%/task |

### Confronto qualitativo (benchmark interni)

| Task | Apple FM | Gemma 3 4B | FunctionGemma |
|------|----------|------------|---------------|
| **Coherence** | 9/10 | 8/10 | 7/10 |
| **Instruction following** | 9/10 | 8/10 | 8/10 (specialized) |
| **Factuality** | 8/10 | 8/10 | N/A |
| **Code generation** | 8/10 | 8/10 | N/A |
| **Multilingual** | 7/10 | 9/10 | 6/10 |

---

## Developer experience

### Setup iniziale

| Aspetto | iOS | Android |
|---------|-----|---------|
| **Xcode/IDE support** | Eccellente | Buono |
| **Documentation** | Completa | Frammentata |
| **Tutorials** | WWDC videos | Sparse |
| **Sample code** | Abbondante | In crescita |
| **Community** | Apple forums | GitHub, Stack Overflow |

### Curva di apprendimento

| Task | iOS (giorni) | Android (giorni) |
|------|--------------|------------------|
| **Hello World LLM** | 0.5 | 1 |
| **Chat con streaming** | 1 | 2 |
| **Tool calling** | 2 | 3-4 |
| **Custom model** | 3-5 (LoRA) | 2-3 |
| **Produzione** | 5-7 | 7-10 |

### Debugging e profiling

| Tool | iOS | Android |
|------|-----|---------|
| **Profiler** | Instruments | Android Profiler |
| **Memory debug** | Leaks, Allocations | Memory Profiler |
| **GPU/NPU debug** | Metal debugger | GPU Inspector |
| **Logging** | os_log | Logcat |

### Testing

| Tipo | iOS | Android |
|------|-----|---------|
| **Unit test** | XCTest | JUnit |
| **UI test** | XCUITest | Espresso |
| **ML test** | CoreML Tools | ML Kit test lab |
| **A/B test** | Firebase | Firebase |

---

## Casi d'uso e raccomandazioni

### Matrice decisionale

| Scenario | Piattaforma consigliata | Motivo |
|----------|-------------------------|--------|
| **iOS only app** | iOS + Foundation Models | Integrazione nativa |
| **Android only app** | Android + Gemma | Flessibilità |
| **Cross-platform** | MediaPipe + Gemma | Portabilità |
| **Function calling focus** | iOS (Tool) o FunctionGemma | API dedicate |
| **Summarization focus** | Android ML Kit | API dedicata |
| **Custom domain** | Android + fine-tuning | Più controllo |
| **Massima privacy** | iOS | Privacy by design |
| **Budget limitato** | Android | Più dispositivi economici |

### Quando scegliere iOS

✅ **Scegli iOS se:**
- Target utenti iPhone/iPad premium
- Privacy è requisito primario
- Vuoi integrazione profonda con OS
- Team già esperto in Swift
- UX polish è priorità
- Time-to-market rapido

❌ **Evita iOS se:**
- Serve fine-tuning del modello
- Target mercati emergenti
- Necessità di modelli custom
- Budget development limitato

### Quando scegliere Android

✅ **Scegli Android se:**
- Target mercato ampio/globale
- Serve flessibilità sui modelli
- Team esperto ML/Python
- Necessità di fine-tuning
- Cross-platform è obiettivo
- Hardware eterogeneo

❌ **Evita Android se:**
- Solo target premium
- Team solo mobile (no ML)
- Privacy estrema richiesta
- Setup rapido necessario

### Stack consigliato per progetto

#### Startup MVP (3 mesi)
```
iOS: Foundation Models + SwiftUI
Android: ML Kit GenAI + Compose
```

#### Enterprise (6+ mesi)
```
iOS: Foundation Models + LoRA adapters
Android: MediaPipe + Gemma 3 fine-tuned + MCP
```

#### Research/Sperimentazione
```
iOS: MLX Swift + modelli HuggingFace
Android: llama.cpp + GGUF + custom quantization
```

---

## Tabella riassuntiva finale

### Quick reference

| | iOS | Android |
|-|-----|---------|
| **Facilità** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Flessibilità** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Privacy** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Costo sviluppo** | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Documentazione** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Community** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Modelli custom** | ⭐⭐ | ⭐⭐⭐⭐⭐ |

### Verdict

| Profilo | Raccomandazione |
|---------|-----------------|
| **iOS developer che vuole aggiungere AI** | Foundation Models |
| **Android developer che vuole aggiungere AI** | ML Kit GenAI |
| **ML engineer che vuole mobile** | MediaPipe + Gemma |
| **Startup con risorse limitate** | Una piattaforma prima |
| **Enterprise con team grande** | Entrambe, architettura condivisa |

---

*Ultimo aggiornamento: Gennaio 2026*
