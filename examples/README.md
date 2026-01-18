# Esempi di Codice

> Esempi pratici pronti all'uso per iOS (Swift) e Android (Kotlin).

---

## Struttura

```
examples/
├── ios/
│   ├── BasicChat.swift          # Chat base con Foundation Models
│   ├── StreamingChat.swift      # Chat con streaming delle risposte
│   └── ToolCallingExample.swift # Tool calling completo
│
└── android/
    ├── BasicChatActivity.kt      # Chat base con AICore/Gemini
    ├── MediaPipeLLMExample.kt    # MediaPipe con modelli custom
    └── FunctionCallingExample.kt # Function calling con FunctionGemma
```

---

## iOS - Requisiti

- **Xcode 17+**
- **iOS 26+ / macOS 26+**
- **Dispositivo con Apple Intelligence** (A17 Pro o superiore)

### Dipendenze

```swift
// Package.swift o Xcode
import FoundationModels
```

### Esempi disponibili

| File | Descrizione | Complessità |
|------|-------------|-------------|
| `BasicChat.swift` | Chat semplice con sessione e contesto | Base |
| `StreamingChat.swift` | Streaming token-by-token con UI reattiva | Intermedio |
| `ToolCallingExample.swift` | Tool personalizzati (meteo, calc, reminder) | Avanzato |

---

## Android - Requisiti

- **Android Studio Ladybug+**
- **Android 14+ (API 34+)**
- **Dispositivo con supporto AICore** (per Gemini Nano)
- Oppure **MediaPipe** con modello GGUF custom

### Dipendenze (build.gradle.kts)

```kotlin
dependencies {
    // AI Core (Gemini Nano)
    implementation("com.google.ai.edge.aicore:aicore:0.0.1-alpha01")

    // MediaPipe LLM Inference
    implementation("com.google.mediapipe:tasks-genai:0.10.14")

    // Jetpack Compose
    implementation(platform("androidx.compose:compose-bom:2024.10.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")

    // Kotlin serialization (per function calling)
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
}
```

### Esempi disponibili

| File | Descrizione | Complessità |
|------|-------------|-------------|
| `BasicChatActivity.kt` | Chat con Gemini Nano via AICore | Base |
| `MediaPipeLLMExample.kt` | Usa modelli Gemma custom (.task) | Intermedio |
| `FunctionCallingExample.kt` | Function calling con FunctionGemma | Avanzato |

---

## Come usare gli esempi

### iOS

1. Crea nuovo progetto Xcode (iOS App)
2. Copia il file `.swift` desiderato nel progetto
3. Assicurati che il target sia iOS 26+
4. Esegui su dispositivo fisico (Simulator non supporta ANE)

### Android

1. Crea nuovo progetto Android Studio (Empty Compose Activity)
2. Aggiungi le dipendenze a `build.gradle.kts`
3. Copia il file `.kt` desiderato
4. Per MediaPipe: scarica il modello `.task` e posizionalo in:
   ```
   /Android/data/[package]/files/models/
   ```
5. Esegui su dispositivo fisico

---

## Download modelli per Android

### Gemma 3 1B (consigliato per iniziare)

```bash
# Da Hugging Face
huggingface-cli download litert-community/Gemma3-1B-IT \
    gemma3-1b-it-int4.task \
    --local-dir ./models/
```

### FunctionGemma

```bash
huggingface-cli download google/functiongemma-270m-it \
    --local-dir ./models/
```

Poi converti in formato `.task` con ai-edge-torch.

---

## Note importanti

### Privacy e dati

Tutti gli esempi eseguono l'inferenza **completamente on-device**:
- Nessun dato inviato a server esterni
- Funziona offline
- Completa privacy dell'utente

### Performance

| Dispositivo | Modello | Token/s (approx) |
|-------------|---------|------------------|
| iPhone 16 Pro | Apple FM | ~136 |
| iPhone 15 Pro | Apple FM | ~120 |
| Galaxy S25 Ultra | Gemma 3 1B | ~150 |
| Pixel 9 Pro | Gemma 3 1B | ~140 |

### Troubleshooting

**iOS - "Apple Intelligence non disponibile"**
- Verifica dispositivo supportato (A17 Pro+)
- Assicurati che Apple Intelligence sia abilitato in Settings

**Android - "Modello non trovato"**
- Verifica path del file `.task`
- Controlla permessi storage
- Usa path assoluto: `context.getExternalFilesDir(null)`

**Android - "Out of memory"**
- Modello troppo grande per il dispositivo
- Usa versione quantizzata (Q4) più piccola
- Chiudi altre app

---

## Licenza

Questi esempi sono forniti come riferimento educativo.
Adatta e modifica liberamente per i tuoi progetti.

---

*Ultimo aggiornamento: Gennaio 2026*
