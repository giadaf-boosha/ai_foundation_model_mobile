# Quantizzazione per LLM Mobile: Guida Completa

> Approfondimento tecnico sulle tecniche di [quantizzazione](https://en.wikipedia.org/wiki/Quantization_(signal_processing)) per eseguire [Large Language Models](https://en.wikipedia.org/wiki/Large_language_model) su dispositivi mobili.

![Quantization Overview](https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/blog/hf-bitsandbytes-integration/quantization.png)
*Rappresentazione visiva della quantizzazione: da float32 a int4*

---

## Indice

1. [Cos'è la quantizzazione](#cosè-la-quantizzazione)
2. [Tipi di quantizzazione](#tipi-di-quantizzazione)
3. [Formati e metodi a confronto](#formati-e-metodi-a-confronto)
4. [Quantizzazione su iOS](#quantizzazione-su-ios)
5. [Quantizzazione su Android](#quantizzazione-su-android)
6. [Best practices](#best-practices)
7. [Benchmark e performance](#benchmark-e-performance)

---

## Cos'è la quantizzazione

La quantizzazione è una tecnica di compressione che riduce la precisione numerica dei parametri di un modello. Invece di usare numeri a 16 bit (BFloat16) o 32 bit (Float32), si utilizzano rappresentazioni a precisione inferiore:

| Precisione | Bit | Riduzione memoria | Uso tipico |
|------------|-----|-------------------|------------|
| FP32 | 32 bit | Baseline | Training |
| BF16/FP16 | 16 bit | 2x | Inference standard |
| INT8 | 8 bit | 4x | Inference ottimizzato |
| INT4 | 4 bit | 8x | Mobile/edge |

### Perché è fondamentale per mobile

Un modello come Gemma 3 4B:
- **BF16**: richiede ~8 GB di memoria
- **INT4**: richiede solo ~2.6 GB di memoria

Questa riduzione del 67% rende possibile l'esecuzione su dispositivi con memoria limitata come smartphone.

---

## Tipi di quantizzazione

### Post-Training Quantization (PTQ)

Applica la quantizzazione **dopo** che il modello è stato completamente addestrato.

**Vantaggi:**
- Veloce da applicare
- Non richiede ri-addestramento
- Compatibile con qualsiasi modello pre-addestrato

**Svantaggi:**
- Maggiore degradazione della qualità
- Perplexity drop tipico: 1.5-2.0 punti

### Quantization-Aware Training (QAT)

Incorpora la quantizzazione **durante** il processo di addestramento, simulando operazioni a bassa precisione.

**Vantaggi:**
- Qualità significativamente migliore
- Perplexity drop: solo ~0.8 punti (54% in meno rispetto a PTQ)
- Il modello "impara" a gestire la precisione ridotta

**Svantaggi:**
- Richiede accesso ai dati di training
- Processo più lungo e costoso
- Non sempre disponibile per modelli proprietari

### Confronto QAT vs PTQ (dati reali Gemma 3)

| Metrica | PTQ | QAT | Differenza |
|---------|-----|-----|------------|
| Perplexity drop | 1.75 punti | 0.8 punti | QAT 54% migliore |
| Accuracy recovery | ~33% | ~67% | QAT 2x migliore |
| GPQA accuracy loss | -1.5% | -0.5% | QAT 3x migliore |

---

## Formati e metodi a confronto

### GGUF (ex GGML)

Formato sviluppato per [llama.cpp](https://github.com/ggerganov/llama.cpp), ottimizzato per inference su CPU e [Apple Silicon](https://en.wikipedia.org/wiki/Apple_silicon).

> Specifica formato: [GGUF Specification](https://github.com/ggerganov/ggml/blob/master/docs/gguf.md)

**Caratteristiche:**
- Ottimizzato per CPU e Apple M-series
- Supporta offloading parziale su GPU
- Formato più popolare per uso locale (Ollama, LM Studio)
- **Quality retention: ~92%**

**Varianti comuni:**
| Variante | Bit | Uso consigliato |
|----------|-----|-----------------|
| Q8_0 | 8 bit | Massima qualità, più memoria |
| Q6_K | 6 bit | Ottimo compromesso |
| **Q4_K_M** | 4 bit | **Raccomandato per mobile** |
| Q4_K_S | 4 bit | Più piccolo, qualità leggermente inferiore |
| Q3_K_M | 3 bit | Ultra-compresso |
| Q2_K | 2 bit | Sperimentale, qualità ridotta |

**Performance:** 54.27% su HumanEval (solo 2% sotto baseline)

### GPTQ

Metodo di quantizzazione post-training layer-by-layer che minimizza l'errore di ricostruzione.

> Paper: [GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers](https://arxiv.org/abs/2210.17323)

**Caratteristiche:**
- Ottimizzato per GPU NVIDIA (CUDA)
- Usa dataset di calibrazione
- **Quality retention: ~90%**

**Performance:**
- Con kernel Marlin: 712 tok/s (1.5x più veloce di FP16)
- Senza kernel ottimizzato: 276 tok/s

### AWQ (Activation-Aware Weight Quantization)

Approccio che protegge i pesi "salienti" osservando le distribuzioni delle attivazioni.

> Paper: [AWQ: Activation-aware Weight Quantization](https://arxiv.org/abs/2306.00978)

**Caratteristiche:**
- Migliore per modelli instruction-tuned
- Ottimo per modelli multimodali
- **Quality retention: ~95%**

**Performance:** 51.83% su HumanEval

### Tabella comparativa

| Metodo | Quality | Speed (vLLM) | Best for |
|--------|---------|--------------|----------|
| **GGUF** | 92% | 81 tok/s | CPU, Apple Silicon, uso locale |
| **GPTQ** | 90% | 712 tok/s* | Server GPU, throughput elevato |
| **AWQ** | 95% | 67 tok/s | Modelli instruction-tuned |

*Con kernel Marlin ottimizzato

### Quando usare cosa

```
Volume basso (<1M token/giorno) → GGUF su CPU
Volume alto (>1M token/giorno) → GPTQ/AWQ su GPU
Apple Silicon → GGUF (native support)
Android mobile → INT4 GGUF o LiteRT
iOS mobile → CoreML con INT8/INT4
```

---

## Quantizzazione su iOS

### Apple Neural Engine e precisione

L'[Apple Neural Engine](https://machinelearning.apple.com/research/neural-engine-transformers) ha evoluto il suo supporto per la quantizzazione:

![Apple Neural Engine](https://docs-assets.developer.apple.com/published/0c1d51e4d7e36c61756cf72ca16dd01c/optimizing-performance-with-the-coreml-profiler@2x.png)
*Core ML Profiler per analizzare le performance su Neural Engine*

| Chip | Supporto |
|------|----------|
| A16 e precedenti | Solo weight quantization (INT8 per ridurre dimensioni) |
| **A17 Pro** | INT8-INT8 compute nativo |
| **M4** | INT8-INT8 compute + ottimizzazioni avanzate |

### Core ML Tools - Opzioni disponibili

```
Pesi: INT4, INT8
Attivazioni: INT8 (solo su A17 Pro/M4+)
```

### W8A8 Mode (Weight 8-bit, Activation 8-bit)

Su hardware recente (A17 Pro, M4), la modalità W8A8 offre:
- Latenza significativamente ridotta
- Compute path int8-int8 ottimizzato sul Neural Engine
- Consigliato quando il modello gira principalmente sul NE

### Raccomandazioni per iOS

1. **iPhone 15 Pro / M4+**: usa activation quantization (W8A8)
2. **Hardware precedente**: solo weight quantization
3. **Modelli transformer**: considera batch inference per uscire dal regime bandwidth-bound

### Novità macOS Sequoia / iOS 18

- Quantizzazione lineare block-wise a 4 bit
- Palettizzazione channel group-wise
- Compressione migliorata con meno perdita di accuratezza

---

## Quantizzazione su Android

### Gemma 3 QAT - Modelli ufficiali

Google fornisce modelli [Gemma 3](https://ai.google.dev/gemma) pre-quantizzati con QAT:

> Blog: [Gemma 3 QAT Models](https://developers.googleblog.com/en/gemma-3-quantized-aware-trained-state-of-the-art-ai-to-consumer-gpus/)

| Modello | BF16 | INT4 QAT | Riduzione |
|---------|------|----------|-----------|
| Gemma 3 1B | 2 GB | 0.5 GB | 75% |
| Gemma 3 4B | 8 GB | 2.6 GB | 67% |
| Gemma 3 12B | 24 GB | 6.6 GB | 72% |
| Gemma 3 27B | 54 GB | 14.1 GB | 74% |

### Download e deployment

I modelli sono disponibili su:
- [Hugging Face - Gemma 3 4B QAT](https://huggingface.co/google/gemma-3-4b-it-qat-q4_0-gguf)
- [LiteRT HuggingFace Organization](https://huggingface.co/litert-community)

### Configurazione per mobile Android

Il modello Gemma 3 1B INT4 QAT supporta:
- Prefill lengths: 32, 128, 512, 1024 token
- Context length: 2048 token
- Testato su Samsung Galaxy S24 Ultra

### MediaPipe LLM Inference API

Per Android, usa l'API di Google AI Edge:

```kotlin
// Configurazione con modello quantizzato
val options = LlmInferenceOptions.builder()
    .setModelPath("/path/to/gemma-3-1b-it-q4_0.task")
    .setMaxTokens(1024)
    .setPreferredBackend(LlmInferenceOptions.Backend.GPU)
    .build()
```

---

## Best practices

### 1. Scegli il livello di quantizzazione giusto

| Scenario | Raccomandazione |
|----------|-----------------|
| Massima qualità | Q8_0 o INT8 |
| Bilanciato (consigliato) | **Q4_K_M** |
| Memoria limitata | Q4_K_S |
| Ultra-compresso | Q3_K_M |

### 2. Usa QAT quando disponibile

Se il modello offre versioni QAT (come Gemma 3), preferiscile sempre a PTQ:
- 54% meno degradazione
- 67% accuracy recovery

### 3. Considera l'hardware target

```
A17 Pro / M4 → Abilita activation quantization
A16 e precedenti → Solo weight quantization
Snapdragon 8 Gen 3+ → Usa Hexagon NPU con INT4
```

### 4. Valida la qualità

Prima del deployment, testa sempre:
- Perplexity sul tuo dominio
- Task-specific accuracy
- Latenza end-to-end

### 5. Monitora il trade-off

```
Più compressione = Meno memoria + Velocità maggiore
                   MA
                   Qualità inferiore
```

---

## Benchmark e performance

### Impatto sulla qualità (HumanEval)

| Metodo | Score | vs Baseline |
|--------|-------|-------------|
| Baseline FP16 | 56.27% | - |
| GGUF Q4_K_M | 54.27% | -2% |
| AWQ INT4 | 51.83% | -4% |
| GPTQ INT4 | 46.00% | -10% |

### Impatto sulla velocità (tok/s)

| Metodo | Throughput | TTFT |
|--------|------------|------|
| FP16 baseline | 461 tok/s | ~200ms |
| GPTQ + Marlin | 712 tok/s | ~150ms |
| GGUF (llama.cpp) | 120+ tok/s | ~100ms |
| AWQ (vLLM) | 67 tok/s | ~300ms |

### Gemma 3 su mobile (Samsung Galaxy S24 Ultra)

| Metrica | Valore |
|---------|--------|
| Modello | Gemma 3 1B INT4 QAT |
| Decode throughput | ~90 tok/s |
| Prefill (128 tokens) | ~50ms |
| Memory footprint | ~500 MB |

---

## Risorse aggiuntive

### Documentazione ufficiale
- [Core ML Tools - Quantization Overview](https://apple.github.io/coremltools/docs-guides/source/opt-quantization-overview.html)
- [Gemma 3 QAT Models - Google](https://developers.googleblog.com/en/gemma-3-quantized-aware-trained-state-of-the-art-ai-to-consumer-gpus/)
- [PyTorch AO - Quantization](https://github.com/pytorch/ao)

### Paper e ricerche
- [GPTQ: Accurate Post-Training Quantization](https://arxiv.org/abs/2210.17323)
- [AWQ: Activation-aware Weight Quantization](https://arxiv.org/abs/2306.00978)
- [Apple Neural Engine Transformers](https://machinelearning.apple.com/research/neural-engine-transformers)

### Tool e framework
- [llama.cpp](https://github.com/ggerganov/llama.cpp) - Reference per GGUF
- [AutoGPTQ](https://github.com/AutoGPTQ/AutoGPTQ) - GPTQ automation
- [AutoAWQ](https://github.com/casper-hansen/AutoAWQ) - AWQ automation

---

## Glossario

| Termine | Definizione |
|---------|-------------|
| **BF16** | Brain Float 16, formato a 16 bit usato nel training |
| **FP16** | Float 16, precisione standard per inference |
| **INT8** | Integer 8-bit, quantizzazione a 8 bit |
| **INT4** | Integer 4-bit, quantizzazione aggressiva |
| **PTQ** | Post-Training Quantization |
| **QAT** | Quantization-Aware Training |
| **Perplexity** | Metrica di qualità (più bassa = migliore) |
| **TTFT** | Time To First Token |

---

*Ultimo aggiornamento: Gennaio 2026*
