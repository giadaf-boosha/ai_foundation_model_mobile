# Foundation Model On-Device per Dispositivi Mobili
## Stato dell'Arte - Gennaio 2026

> Report di ricerca approfondita su foundation model locali per iOS e Android, architetture agentiche, function calling e integrazione nelle app mobile.

---

## Indice

1. [Introduzione ai foundation model on-device](#1-introduzione-ai-foundation-model-on-device)
2. [Ecosistema Apple: Foundation Models Framework](#2-ecosistema-apple-foundation-models-framework)
3. [Ecosistema Google: Gemini Nano e Gemma](#3-ecosistema-google-gemini-nano-e-gemma)
4. [Parametri di configurazione (temperature, context, top-k)](#4-parametri-di-configurazione)
5. [Architetture agentiche per mobile](#5-architetture-agentiche-per-mobile)
6. [Tools e function calling](#6-tools-e-function-calling)
7. [Quantizzazione e ottimizzazione](#7-quantizzazione-e-ottimizzazione)
8. [Confronto iOS vs Android](#8-confronto-ios-vs-android)
9. [Implementazione passo-passo](#9-implementazione-passo-passo)
10. [Risorse e riferimenti](#10-risorse-e-riferimenti)

---

## 1. Introduzione ai foundation model on-device

### Che cos'è un foundation model on-device?

Un **foundation model on-device** è un modello di intelligenza artificiale di grandi dimensioni (tipicamente un LLM - Large Language Model) che viene eseguito direttamente sul dispositivo dell'utente (smartphone, tablet) invece che su server remoti nel cloud.

### Perché è importante?

| Vantaggio | Descrizione |
|-----------|-------------|
| **Privacy** | I dati rimangono sul dispositivo, mai inviati a server esterni |
| **Latenza zero** | Nessun ritardo di rete, risposte istantanee |
| **Funzionalità offline** | Funziona senza connessione internet |
| **Costi ridotti** | Nessun costo di inference cloud per lo sviluppatore |

### Stato dell'arte gennaio 2026

Secondo le ricerche più recenti:

- **Modelli 7B parametri** sono ora standard su dispositivi mid-range
- **Modelli 13B parametri** saranno eseguibili su flagship entro fine 2026
- NPU con **70+ TOPS** permettono modelli 4B+ parametri a velocità conversazionale
- Latenza multimodale (visione + linguaggio + audio) sotto i **5ms**
- Benchmark: iPhone 17 Pro raggiunge **136 tok/s**, Galaxy S25 Ultra **91 tok/s**

**Fonti**: [Apple ML Research](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates), [F22 Labs Guide 2026](https://www.f22labs.com/blogs/what-is-on-device-ai-a-complete-guide/)

---

## 2. Ecosistema Apple: Foundation Models Framework

### Che cos'è?

Il **Foundation Models Framework** è il framework ufficiale Apple, introdotto al WWDC 2025, che fornisce agli sviluppatori accesso diretto al modello linguistico on-device (~3 miliardi di parametri) che alimenta Apple Intelligence.

### Caratteristiche tecniche

| Specifica | Valore |
|-----------|--------|
| **Parametri modello** | ~3 miliardi |
| **Context window** | 4.096 token (fisso) |
| **Quantizzazione** | 2-bit quantization-aware training |
| **Piattaforme** | iOS 26+, iPadOS 26+, macOS 26+, visionOS 26+ |
| **Dispositivi supportati** | iPhone con chip A17 Pro+, iPad/Mac con chip M-series |

### Architettura del modello Apple

Apple utilizza innovazioni specifiche per l'efficienza:

1. **KV-Cache sharing**: il modello è diviso in 2 blocchi:
   - Blocco 1: 62,5% dei layer transformer
   - Blocco 2: 37,5% dei layer, condivide il KV-cache con Blocco 1
   - Risultato: **riduzione 37,5% dell'uso di memoria KV-cache**

2. **Parallel-Track Mixture-of-Experts (PT-MoE)**: architettura transformer scalabile per il modello server

### Come implementarlo - passo passo

#### Step 1: Configurare il progetto Xcode

```swift
// In Package.swift o tramite Xcode package dependencies
dependencies: [
    .package(url: "https://github.com/apple/swift-foundation-models", from: "1.0.0")
]
```

#### Step 2: Import del framework

```swift
import FoundationModels
```

#### Step 3: Creare una sessione base

```swift
// Creare una sessione con il modello di sistema
let session = LanguageModelSession()

// Generare una risposta semplice
let response = try await session.respond(to: "Scrivi una poesia sul mare")
print(response.content)
```

#### Step 4: Guided Generation con @Generable

La **guided generation** è la funzionalità principale: permette di ottenere output strutturati e type-safe.

```swift
import FoundationModels

// Definire una struttura con @Generable
@Generable
struct Ricetta {
    let nome: String

    @Guide(description: "Lista degli ingredienti necessari")
    let ingredienti: [String]

    @Guide(description: "Tempo di preparazione in minuti")
    let tempoPreparazione: Int

    @Guide(.anyOf(["facile", "media", "difficile"]))
    let difficolta: String
}

// Usare la sessione per generare l'output strutturato
let session = LanguageModelSession()
let response = try await session.respond(
    to: "Dammi una ricetta per la pasta alla carbonara",
    generating: Ricetta.self
)

// response.content è ora di tipo Ricetta, completamente type-safe
print(response.content.nome)           // "Pasta alla Carbonara"
print(response.content.ingredienti)    // ["guanciale", "uova", ...]
print(response.content.difficolta)     // "media"
```

#### Step 5: Streaming delle risposte

```swift
let session = LanguageModelSession()

// Streaming per UI responsive
for try await partial in session.streamResponse(to: "Racconta una storia") {
    // Aggiorna la UI progressivamente
    textView.text = partial.content
}
```

### Tool Calling in Apple Foundation Models

#### Che cos'è?

Il **tool calling** permette al modello di invocare funzioni del tuo codice per eseguire azioni o recuperare dati esterni.

#### Come implementarlo

```swift
import FoundationModels

// Step 1: Definire gli argomenti del tool
@Generable
struct MeteoArgs {
    @Guide(description: "Nome della città per cui recuperare il meteo")
    let citta: String
}

// Step 2: Implementare il tool
struct MeteoTool: Tool {
    var name: String { "ottieni_meteo" }
    var description: String { "Recupera le informazioni meteo attuali per una città" }

    // Definire il tipo degli argomenti
    typealias Arguments = MeteoArgs

    func call(with arguments: MeteoArgs) async throws -> ToolOutput {
        // Chiama il tuo servizio meteo
        let meteo = await MeteoService.shared.getMeteo(citta: arguments.citta)
        return ToolOutput(content: "Temperatura: \(meteo.temperatura)°C, Condizioni: \(meteo.condizioni)")
    }
}

// Step 3: Creare una sessione con i tools
let session = LanguageModelSession(tools: [MeteoTool()])

// Step 4: Il modello userà automaticamente il tool quando appropriato
let response = try await session.respond(to: "Che tempo fa a Roma?")
// Il modello chiamerà MeteoTool e includerà il risultato nella risposta
```

### LoRA Adapters

#### Che cos'è?

**LoRA (Low-Rank Adaptation)** permette di personalizzare il modello base per casi d'uso specifici senza ritrainarlo completamente.

#### Specifiche tecniche

| Specifica | Valore |
|-----------|--------|
| Rank | 32 |
| Storage per adapter | ~160 MB |
| Distribuzione | Background Assets framework |

#### Come creare un LoRA adapter

```bash
# Installare il toolkit Python di Apple
pip install apple-foundation-models-toolkit

# Preparare i dati di training (formato JSONL)
# dataset.jsonl:
# {"input": "...", "output": "..."}

# Eseguire il training
python -m foundation_models.train_lora \
    --dataset dataset.jsonl \
    --rank 32 \
    --output my_adapter.lora
```

```swift
// Caricare l'adapter nel codice Swift
let session = LanguageModelSession()
try await session.loadAdapter(from: Bundle.main.url(forResource: "my_adapter", withExtension: "lora")!)
```

**Fonti**: [Apple Developer Documentation](https://developer.apple.com/documentation/FoundationModels), [WWDC25 Session 286](https://developer.apple.com/videos/play/wwdc2025/286/), [CreateWithSwift Guide](https://www.createwithswift.com/exploring-the-foundation-models-framework/)

---

## 3. Ecosistema Google: Gemini Nano e Gemma

### Panoramica dell'ecosistema

Google offre due percorsi principali per l'AI on-device:

| Tecnologia | Descrizione | Uso principale |
|------------|-------------|----------------|
| **Gemini Nano** | Modello proprietario integrato in Android | App native Android via ML Kit |
| **Gemma** | Famiglia di modelli open-source | Cross-platform, massima flessibilità |
| **Gemma 3n** | Versione ottimizzata mobile di Gemma | Nuovo standard per on-device |

### Gemini Nano

#### Che cos'è?

**Gemini Nano** è il modello on-device più potente di Google, integrato nativamente in Android tramite **AICore**. La versione attuale (nano-v3) condivide l'architettura con Gemma 3n.

#### Dispositivi supportati

- Google Pixel 10 series (nano-v3)
- Google Pixel 9 series
- Honor Magic 6 Pro, Magic 7, Magic V3
- Altri flagship con 8GB+ RAM

#### API disponibili tramite ML Kit GenAI

| API | Descrizione | Complessità |
|-----|-------------|-------------|
| **Summarization** | Riassume testi lunghi | Alta astrazione |
| **Proofreading** | Corregge grammatica e ortografia | Alta astrazione |
| **Rewriting** | Riscrive testo in stile diverso | Alta astrazione |
| **Image Description** | Descrive immagini | Alta astrazione |
| **Prompt API** | Richieste libere in linguaggio naturale | Bassa astrazione |

### Come implementare Gemini Nano su Android

#### Step 1: Aggiungere le dipendenze

```kotlin
// build.gradle.kts (app level)
dependencies {
    // Per API specifiche (summarization, proofreading, etc.)
    implementation("com.google.mlkit:genai-summarization:1.0.0")
    implementation("com.google.mlkit:genai-proofreading:1.0.0")
    implementation("com.google.mlkit:genai-rewriting:1.0.0")
    implementation("com.google.mlkit:genai-image-description:1.0.0")

    // Per Prompt API (flessibilità massima)
    implementation("com.google.mlkit:genai-prompt:1.0.0-alpha1")
}
```

#### Step 2: Usare la Summarization API

```kotlin
import com.google.mlkit.genai.summarization.Summarizer
import com.google.mlkit.genai.summarization.SummarizerOptions

class SummarizationExample {

    suspend fun summarizeText(longText: String): String {
        // Configurare le opzioni
        val options = SummarizerOptions.Builder()
            .setLength(SummarizerOptions.Length.SHORT)  // SHORT, MEDIUM, LONG
            .setFormat(SummarizerOptions.Format.PARAGRAPH)  // PARAGRAPH, BULLETS
            .build()

        // Creare il summarizer
        val summarizer = Summarizer.getClient(options)

        // Opzionale: pre-caricare il modello per ridurre la latenza
        summarizer.warmup()

        // Eseguire la summarization
        val result = summarizer.summarize(longText)

        return result.summary
    }
}
```

#### Step 3: Usare la Prompt API (massima flessibilità)

```kotlin
import com.google.mlkit.genai.prompt.PromptApi
import com.google.mlkit.genai.prompt.PromptApiOptions
import com.google.mlkit.genai.prompt.GenerationConfig

class PromptApiExample {

    suspend fun generateResponse(userPrompt: String): String {
        // Configurare i parametri di generazione
        val generationConfig = GenerationConfig.Builder()
            .setTemperature(0.7f)        // Creatività (0.0 - 1.0)
            .setTopK(40)                  // Diversità del vocabolario
            .setMaxOutputTokens(1024)     // Limite output
            .setSeed(42)                  // Per risultati riproducibili
            .setCandidateCount(1)         // Numero di risposte
            .build()

        val options = PromptApiOptions.Builder()
            .setGenerationConfig(generationConfig)
            .build()

        // Creare il client
        val promptApi = PromptApi.getClient(options)

        // Pre-caricare (opzionale ma consigliato)
        promptApi.warmup()

        // Generare la risposta
        val result = promptApi.generateContent(userPrompt)

        return result.text
    }

    // Con input multimodale (testo + immagine)
    suspend fun analyzeImage(image: Bitmap, question: String): String {
        val promptApi = PromptApi.getClient()

        val result = promptApi.generateContent(
            content {
                image(image)
                text(question)
            }
        )

        return result.text
    }
}
```

### Gemma 3n - Il nuovo standard mobile

#### Che cos'è?

**Gemma 3n** è la versione mobile-first di Gemma, progettata in collaborazione con Qualcomm, MediaTek e Samsung. Utilizza un'architettura condivisa con Gemini Nano v3.

#### Innovazioni chiave

| Innovazione | Beneficio |
|-------------|-----------|
| **Per-Layer Embeddings (PLE)** | Riduzione drastica dell'uso di RAM |
| **KVC sharing** | Condivisione cache key-value tra layer |
| **Activation quantization avanzata** | Compressione aggressiva senza perdita qualità |

#### Varianti disponibili

| Modello | Parametri | RAM effettiva | Velocità avvio |
|---------|-----------|---------------|----------------|
| Gemma 3n 2B | 2 miliardi | ~1.5 GB | 1.5x più veloce |
| Gemma 3n 4B | 4 miliardi | ~3 GB | 1.5x più veloce |

#### Input supportati

- ✅ Testo
- ✅ Immagini
- 🔜 Audio (prossimamente)

### Come implementare Gemma con MediaPipe LLM Inference API

#### Step 1: Scaricare il modello

```kotlin
// I modelli pre-convertiti sono disponibili su:
// - Kaggle Models: https://kaggle.com/models/google/gemma
// - HuggingFace LiteRT Community
```

#### Step 2: Aggiungere le dipendenze

```kotlin
// build.gradle.kts
dependencies {
    implementation("com.google.mediapipe:tasks-genai:0.10.14")
}
```

#### Step 3: Inizializzare e usare

```kotlin
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mediapipe.tasks.genai.llminference.LlmInferenceOptions

class GemmaInference(private val context: Context) {

    private lateinit var llmInference: LlmInference

    fun initialize(modelPath: String) {
        val options = LlmInferenceOptions.builder()
            .setModelPath(modelPath)
            .setMaxTokens(1024)
            .setTemperature(0.7f)
            .setTopK(40)
            .setRandomSeed(42)
            .build()

        llmInference = LlmInference.createFromOptions(context, options)
    }

    // Generazione singola
    fun generateResponse(prompt: String): String {
        return llmInference.generateResponse(prompt)
    }

    // Generazione in streaming
    fun generateResponseStreaming(prompt: String, onPartial: (String) -> Unit) {
        llmInference.generateResponseAsync(prompt) { partialResult, done ->
            onPartial(partialResult)
        }
    }

    // Chat multi-turno con gestione sessione
    fun chat(userMessage: String): String {
        // MediaPipe gestisce automaticamente la history della conversazione
        return llmInference.generateResponse(userMessage)
    }
}
```

### Google AI Edge Gallery

#### Che cos'è?

**Google AI Edge Gallery** è un'app sperimentale che permette di testare modelli GenAI direttamente su dispositivo, completamente offline.

#### Requisiti

- Android 12+ o iOS
- Minimo 6 GB RAM

#### Funzionalità

| Feature | Descrizione |
|---------|-------------|
| Chat multi-turno | Conversazioni continue |
| Ask Image | Analisi immagini con domande |
| Audio Scribe | Trascrizione e traduzione audio |
| Prompt Lab | Summarization, rewriting, generazione codice |
| Performance Insights | Metriche real-time (TTFT, velocità decode) |
| BYOM | Importa modelli LiteRT personalizzati |

**Fonti**: [Android Developers Blog](https://android-developers.googleblog.com/2025/05/on-device-gen-ai-apis-ml-kit-gemini-nano.html), [Gemma 3n Announcement](https://developers.googleblog.com/en/introducing-gemma-3n/), [Google AI Edge Gallery](https://github.com/google-ai-edge/gallery)

---

## 4. Parametri di configurazione

### Panoramica dei parametri

Quando si lavora con LLM on-device, è fondamentale comprendere i parametri che controllano la generazione del testo.

### Temperature

#### Che cos'è?

La **temperature** controlla la casualità/creatività dell'output. Tecnicamente, modifica la distribuzione di probabilità dei token successivi.

| Valore | Comportamento |
|--------|---------------|
| 0.0 | Deterministico, sempre lo stesso output (greedy) |
| 0.1 - 0.3 | Molto conservativo, risposte prevedibili |
| 0.5 - 0.7 | Bilanciato (consigliato per la maggior parte dei casi) |
| 0.8 - 1.0 | Creativo, risposte più varie |
| > 1.0 | Molto casuale, può diventare incoerente |

#### Esempio pratico

```swift
// iOS - Apple Foundation Models
// Temperature è gestita internamente, ma puoi influenzarla
// tramite il sampling mode

// Android - ML Kit GenAI
val config = GenerationConfig.Builder()
    .setTemperature(0.7f)  // Valore bilanciato
    .build()
```

### Top-K

#### Che cos'è?

**Top-K** limita la selezione dei token ai K token più probabili. Riduce il rischio di output strani ma mantiene varietà.

| Valore | Effetto |
|--------|---------|
| 1 | Solo il token più probabile (come temperature 0) |
| 10-20 | Conservativo |
| 40 | Default tipico |
| 100+ | Molto diverso, maggiore creatività |

#### Implementazione

```kotlin
// Android
val config = GenerationConfig.Builder()
    .setTopK(40)  // Default consigliato
    .build()
```

### Top-P (Nucleus Sampling)

#### Che cos'è?

**Top-P** seleziona token finché la probabilità cumulativa raggiunge P. Più adattivo di Top-K.

| Valore | Effetto |
|--------|---------|
| 0.1 | Molto ristretto |
| 0.5 | Moderato |
| 0.9 | Default tipico, buon bilanciamento |
| 1.0 | Nessun filtro |

### Context Window

#### Che cos'è?

Il **context window** è il numero massimo di token che il modello può "vedere" contemporaneamente, includendo sia l'input che l'output.

| Piattaforma | Context Window |
|-------------|----------------|
| Apple Foundation Models | 4.096 token (fisso) |
| Gemini Nano | Variabile per dispositivo |
| Gemma 3 | 128.000 token (ma limitato su mobile) |

#### Gestione del context window

```swift
// iOS - Gestire il limite del context
// Il context include TUTTO: system prompt + cronologia chat + risposta

let session = LanguageModelSession()

// Monitorare l'uso del context
let transcript = session.transcript
let usedTokens = transcript.estimatedTokenCount
let remainingTokens = 4096 - usedTokens

// Se il context si riempie, creare una nuova sessione
// o implementare una strategia di "sliding window"
if remainingTokens < 500 {
    // Riassumere la conversazione e iniziare nuova sessione
    let summary = try await summarizeConversation(transcript)
    session = LanguageModelSession()
    // Iniettare il riassunto come contesto
}
```

### Seed

#### Che cos'è?

Il **seed** è un valore che inizializza il generatore di numeri casuali. Usando lo stesso seed, otterrai output identici (a parità di altri parametri).

```kotlin
// Utile per debugging e testing
val config = GenerationConfig.Builder()
    .setSeed(42)  // Output riproducibile
    .build()
```

### Max Output Tokens

#### Che cos'è?

Limita la lunghezza massima della risposta generata.

```kotlin
val config = GenerationConfig.Builder()
    .setMaxOutputTokens(1024)  // Massimo 1024 token di output
    .build()
```

### Tabella riassuntiva configurazione consigliata

| Caso d'uso | Temperature | Top-K | Max Tokens |
|------------|-------------|-------|------------|
| Assistente informativo | 0.3 | 20 | 512 |
| Chat conversazionale | 0.7 | 40 | 1024 |
| Scrittura creativa | 0.9 | 60 | 2048 |
| Generazione codice | 0.2 | 10 | 1024 |
| Riassunti | 0.5 | 30 | 256 |

**Fonti**: [Apple TN3193](https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window), [Google ML Kit Prompt Design](https://developers.google.com/ml-kit/genai/prompt/android/prompt-design)

---

## 5. Architetture agentiche per mobile

### Che cos'è un agente AI?

Un **agente AI** è un sistema che non si limita a rispondere a domande, ma può:
- Pianificare sequenze di azioni
- Eseguire task in modo autonomo
- Interagire con l'ambiente (API, dispositivo)
- Apprendere dai risultati

### Differenza chatbot vs agente

| Caratteristica | Chatbot | Agente |
|----------------|---------|--------|
| Interazione | Domanda → Risposta | Goal → Piano → Esecuzione |
| Autonomia | Nessuna | Alta |
| Uso di strumenti | No | Sì |
| Memoria | Limitata | Gerarchica |
| Adattamento | Statico | Dinamico |

### Architettura ibrida on-device + cloud

L'architettura moderna per agenti mobile è **ibrida**:

```
┌─────────────────────────────────────────────────┐
│                 DISPOSITIVO MOBILE              │
│  ┌─────────────────────────────────────────┐   │
│  │   SLM (Small Language Model)            │   │
│  │   - Riconoscimento intent               │   │
│  │   - Pianificazione leggera              │   │
│  │   - Privacy-sensitive tasks             │   │
│  │   - Routing decisioni                   │   │
│  └─────────────────────────────────────────┘   │
│                      │                          │
│                      ▼                          │
│  ┌─────────────────────────────────────────┐   │
│  │   ROUTER INTELLIGENTE                    │   │
│  │   - Dati sensibili? → On-device          │   │
│  │   - Batteria critica? → Semplifica       │   │
│  │   - Task complesso? → Cloud              │   │
│  └─────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────┘
                        │ (quando necessario)
                        ▼
┌─────────────────────────────────────────────────┐
│                      CLOUD                       │
│  ┌─────────────────────────────────────────┐   │
│  │   LLM Completo                           │   │
│  │   - Ragionamento complesso               │   │
│  │   - Generazione lunga                    │   │
│  │   - Multi-step planning                  │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

### Pattern architetturali principali

#### 1. ReAct (Reasoning + Acting)

##### Che cos'è?

**ReAct** combina il ragionamento chain-of-thought (CoT) con l'uso di strumenti esterni. Il modello alterna tra "pensare" e "agire".

##### Ciclo ReAct

```
THOUGHT → ACTION → OBSERVATION → THOUGHT → ACTION → ...
```

##### Implementazione concettuale

```kotlin
class ReActAgent(
    private val llm: LlmInference,
    private val tools: List<Tool>
) {
    suspend fun execute(goal: String): String {
        var context = "Goal: $goal\n"

        while (true) {
            // THOUGHT: Il modello ragiona sul prossimo step
            val prompt = """
                $context

                Available tools: ${tools.map { it.name }}

                Think about what to do next.
                Format:
                Thought: [your reasoning]
                Action: [tool_name or FINISH]
                Action Input: [input for the tool]
            """.trimIndent()

            val response = llm.generateResponse(prompt)
            context += response

            // Parse the response
            val action = parseAction(response)

            if (action.name == "FINISH") {
                return action.input  // Risultato finale
            }

            // Esegui il tool
            val tool = tools.find { it.name == action.name }
            val observation = tool?.execute(action.input) ?: "Tool not found"

            context += "\nObservation: $observation\n"
        }
    }
}
```

#### 2. Planning Agent

##### Che cos'è?

Un **planning agent** prima crea un piano completo, poi lo esegue step by step.

##### Implementazione

```swift
// iOS
struct PlanningAgent {
    let session: LanguageModelSession
    let tools: [any Tool]

    func execute(goal: String) async throws -> String {
        // Step 1: Generare il piano
        @Generable struct Plan {
            @Guide(description: "Lista ordinata di step da eseguire")
            let steps: [String]
        }

        let planPrompt = """
        Goal: \(goal)

        Available tools: \(tools.map { $0.name })

        Create a step-by-step plan to achieve this goal.
        """

        let plan = try await session.respond(
            to: planPrompt,
            generating: Plan.self
        )

        // Step 2: Eseguire ogni step
        var results: [String] = []
        for step in plan.content.steps {
            let result = try await executeStep(step)
            results.append(result)
        }

        // Step 3: Sintetizzare i risultati
        let summary = try await session.respond(
            to: "Summarize: \(results.joined(separator: "\n"))"
        )

        return summary.content
    }
}
```

#### 3. Multi-Agent System

##### Che cos'è?

Più agenti specializzati collaborano per completare task complessi.

##### Architettura tipica

```
┌─────────────────────────────────────────┐
│           ORCHESTRATOR AGENT            │
│   (decide quale agente attivare)        │
└─────────────┬───────────────────────────┘
              │
    ┌─────────┼─────────┐
    ▼         ▼         ▼
┌───────┐ ┌───────┐ ┌───────┐
│PLANNER│ │CODER  │ │CRITIC │
│ AGENT │ │ AGENT │ │ AGENT │
└───────┘ └───────┘ └───────┘
```

#### 4. Hierarchical Agent

##### Che cos'è?

Agenti organizzati in livelli gerarchici: quelli di alto livello fanno decisioni strategiche, quelli di basso livello eseguono task tattici.

### Framework per agenti mobile

| Framework | Piattaforma | Caratteristiche |
|-----------|-------------|-----------------|
| **DroidRun** | Android | Multi-step reasoning, controllo UI |
| **LangChain Mobile** | Cross-platform | ReAct, planning, memory |
| **AutoGen** | Cloud + edge | Multi-agent orchestration |

### Memoria negli agenti

#### Architettura a tre livelli (ispirata ai sistemi operativi)

| Livello | Nome | Contenuto | Durata |
|---------|------|-----------|--------|
| L1 | Working Memory | Contesto attuale | Sessione |
| L2 | Main Memory | Cronologia recente | Ore/giorni |
| L3 | Archive | Storage lungo termine con retrieval | Permanente |

```kotlin
class AgentMemory {
    // L1: Contesto immediato
    private val workingMemory = mutableListOf<Message>()

    // L2: Cronologia recente (ultime N interazioni)
    private val mainMemory = CircularBuffer<Interaction>(size = 100)

    // L3: Vector store per retrieval semantico
    private val archiveMemory = VectorDatabase()

    fun getRelevantContext(query: String): String {
        // Combina working memory + retrieval da archive
        val recentContext = workingMemory.takeLast(5)
        val relevantArchive = archiveMemory.similaritySearch(query, k = 3)

        return buildContext(recentContext, relevantArchive)
    }
}
```

**Fonti**: [IBM ReAct Agent](https://www.ibm.com/think/topics/react-agent), [MarkTechPost AI Agents Guide 2025](https://www.marktechpost.com/2025/07/19/the-definitive-guide-to-ai-agents-architectures-frameworks-and-real-world-applications-2025/), [Google Cloud Agentic Design Patterns](https://cloud.google.com/architecture/choose-design-pattern-agentic-ai-system)

---

## 6. Tools e function calling

### Che cos'è il function calling?

Il **function calling** (o tool use) è la capacità di un LLM di generare chiamate strutturate a funzioni esterne invece di semplice testo.

### Flusso di function calling

```
1. USER: "Che tempo fa a Milano?"
            │
            ▼
2. LLM analizza e decide di usare un tool
            │
            ▼
3. LLM genera: { "function": "get_weather", "args": { "city": "Milano" } }
            │
            ▼
4. APP esegue la funzione get_weather("Milano")
            │
            ▼
5. APP restituisce: "15°C, soleggiato"
            │
            ▼
6. LLM genera risposta finale: "A Milano ci sono 15°C con cielo soleggiato."
```

### Model Context Protocol (MCP)

#### Che cos'è?

**MCP** è un protocollo open-source (creato da Anthropic) che standardizza come gli LLM si connettono a strumenti e dati esterni. È il "telecomando universale" per AI.

#### Vantaggi

- **Implementazione unica**: sviluppa una volta, usa ovunque
- **Ecosistema ampio**: migliaia di server MCP disponibili
- **Standard de-facto**: adottato dall'industria

#### Architettura MCP

```
┌─────────────────┐         ┌─────────────────┐
│   MCP CLIENT    │◄───────►│   MCP SERVER    │
│  (LLM Agent)    │   JSON  │  (Tool/Data)    │
└─────────────────┘   RPC   └─────────────────┘
```

### FunctionGemma - Il modello specializzato per function calling

#### Che cos'è?

**FunctionGemma** (rilasciato dicembre 2025) è una versione specializzata di Gemma 3 da 270M parametri, ottimizzata specificamente per function calling on-device.

#### Specifiche

| Specifica | Valore |
|-----------|--------|
| Parametri | 270 milioni |
| Dimensione | 288 MB |
| Velocità | ~126 tok/s decode |
| Accuratezza base | 58% |
| Accuratezza dopo fine-tuning | 85% |
| Vocabolario | 256k (ottimizzato per JSON) |

#### Come funziona

```
USER: "Crea un evento calendario per pranzo domani"
            │
            ▼
FunctionGemma genera:
{
    "function": "create_calendar_event",
    "arguments": {
        "title": "Pranzo",
        "date": "2026-01-18",
        "time": "12:30"
    }
}
            │
            ▼
APP: CalendarAPI.createEvent(...)
```

### Google AI Edge Function Calling SDK

#### Che cos'è?

SDK ufficiale Google (attualmente solo Android) per abilitare function calling on-device con Gemma 3n.

#### Implementazione

```kotlin
import com.google.ai.edge.functioncalling.FunctionCallingClient
import com.google.ai.edge.functioncalling.FunctionDefinition
import com.google.ai.edge.functioncalling.Parameter

// Step 1: Definire le funzioni disponibili
val weatherFunction = FunctionDefinition(
    name = "get_weather",
    description = "Ottiene il meteo attuale per una città",
    parameters = listOf(
        Parameter(
            name = "city",
            type = "string",
            description = "Nome della città"
        ),
        Parameter(
            name = "unit",
            type = "string",
            description = "Unità di temperatura: celsius o fahrenheit",
            enum = listOf("celsius", "fahrenheit"),
            default = "celsius"
        )
    )
)

val calendarFunction = FunctionDefinition(
    name = "create_event",
    description = "Crea un evento nel calendario",
    parameters = listOf(
        Parameter(name = "title", type = "string"),
        Parameter(name = "datetime", type = "string"),
        Parameter(name = "duration_minutes", type = "integer", default = 60)
    )
)

// Step 2: Inizializzare il client
val fcClient = FunctionCallingClient.builder()
    .setModelPath("gemma-3n-4b-fc.tflite")
    .addFunction(weatherFunction)
    .addFunction(calendarFunction)
    .build()

// Step 3: Processare richieste utente
suspend fun processUserRequest(userInput: String) {
    val result = fcClient.process(userInput)

    when (result) {
        is FunctionCall -> {
            // Il modello vuole chiamare una funzione
            val functionResult = when (result.functionName) {
                "get_weather" -> {
                    val city = result.arguments["city"] as String
                    WeatherService.getWeather(city)
                }
                "create_event" -> {
                    val title = result.arguments["title"] as String
                    val datetime = result.arguments["datetime"] as String
                    CalendarService.createEvent(title, datetime)
                }
                else -> "Funzione non riconosciuta"
            }

            // Restituire il risultato al modello per risposta finale
            val finalResponse = fcClient.generateWithFunctionResult(
                userInput,
                result.functionName,
                functionResult
            )
            showToUser(finalResponse)
        }
        is TextResponse -> {
            // Risposta diretta senza function call
            showToUser(result.text)
        }
    }
}
```

### Apple Foundation Models - Tool Calling avanzato

#### Implementazione completa con più tools

```swift
import FoundationModels

// Tool 1: Ricerca nel database
@Generable
struct SearchArgs {
    @Guide(description: "Query di ricerca")
    let query: String

    @Guide(description: "Numero massimo di risultati", .range(1...10))
    let maxResults: Int
}

struct DatabaseSearchTool: Tool {
    var name: String { "search_database" }
    var description: String { "Cerca nel database locale dell'app" }
    typealias Arguments = SearchArgs

    func call(with args: SearchArgs) async throws -> ToolOutput {
        let results = await Database.shared.search(
            query: args.query,
            limit: args.maxResults
        )
        return ToolOutput(content: results.map { $0.title }.joined(separator: ", "))
    }
}

// Tool 2: Invio notifica
@Generable
struct NotificationArgs {
    let title: String
    let body: String

    @Guide(.anyOf(["now", "1hour", "tomorrow"]))
    let schedule: String
}

struct NotificationTool: Tool {
    var name: String { "send_notification" }
    var description: String { "Programma una notifica per l'utente" }
    typealias Arguments = NotificationArgs

    func call(with args: NotificationArgs) async throws -> ToolOutput {
        let triggerDate = parseTriggerDate(args.schedule)
        await NotificationManager.shared.schedule(
            title: args.title,
            body: args.body,
            at: triggerDate
        )
        return ToolOutput(content: "Notifica programmata per \(triggerDate)")
    }
}

// Tool 3: Operazioni file
@Generable
struct FileArgs {
    @Guide(.anyOf(["read", "write", "list"]))
    let operation: String

    let path: String
    let content: String?
}

struct FileTool: Tool {
    var name: String { "file_operations" }
    var description: String { "Esegue operazioni sui file dell'app" }
    typealias Arguments = FileArgs

    func call(with args: FileArgs) async throws -> ToolOutput {
        switch args.operation {
        case "read":
            let content = try await FileManager.readFile(at: args.path)
            return ToolOutput(content: content)
        case "write":
            try await FileManager.writeFile(args.content ?? "", at: args.path)
            return ToolOutput(content: "File scritto con successo")
        case "list":
            let files = try await FileManager.listDirectory(at: args.path)
            return ToolOutput(content: files.joined(separator: "\n"))
        default:
            return ToolOutput(content: "Operazione non supportata")
        }
    }
}

// Creare l'agente con tutti i tools
class AIAssistant {
    let session: LanguageModelSession

    init() {
        session = LanguageModelSession(tools: [
            DatabaseSearchTool(),
            NotificationTool(),
            FileTool()
        ])
    }

    func chat(_ message: String) async throws -> String {
        // Il framework gestisce automaticamente:
        // - Decidere quale tool usare
        // - Generare gli argomenti corretti
        // - Eseguire i tools in parallelo se possibile
        // - Combinare i risultati nella risposta finale

        let response = try await session.respond(to: message)
        return response.content
    }
}

// Uso
let assistant = AIAssistant()
let response = try await assistant.chat(
    "Cerca 'vacanze' nel database e programmami un promemoria per domani"
)
// Il modello chiamerà automaticamente search_database e send_notification
```

**Fonti**: [FunctionGemma Blog](https://blog.google/technology/developers/functiongemma/), [Gemma Function Calling Docs](https://ai.google.dev/gemma/docs/capabilities/function-calling), [Anthropic MCP](https://modelcontextprotocol.io/specification/2025-06-18/server/tools)

---

## 7. Quantizzazione e ottimizzazione

### Che cos'è la quantizzazione?

La **quantizzazione** riduce la precisione dei numeri usati per rappresentare i pesi del modello, diminuendo drasticamente dimensione e requisiti computazionali.

### Confronto formati

| Formato | Byte/parametro | Modello 3B | Qualità |
|---------|----------------|------------|---------|
| FP32 | 4 | 12 GB | 100% |
| FP16 | 2 | 6 GB | ~99% |
| INT8 | 1 | 3 GB | ~97% |
| INT4 | 0.5 | 1.5 GB | ~94% |
| INT2 | 0.25 | 0.75 GB | ~85% (sconsigliato) |

### Risultati pratici

Un modello **Llama 3.2 3B** quantizzato a 4-bit:
- Dimensione originale: 6.00 GB
- Dimensione dopo q4_k_m: **1.88 GB** (-68.66%)
- Eseguibile su smartphone Android con 12 GB RAM

### Tecniche di quantizzazione

#### 1. Post-Training Quantization (PTQ)

##### Che cos'è?

Quantizza il modello **dopo** il training, senza necessità di ritrainarlo.

##### Implementazione con HuggingFace + BitsAndBytes

```python
from transformers import AutoModelForCausalLM, BitsAndBytesConfig
import torch

# Configurazione per quantizzazione 4-bit
quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",  # Normalized Float 4-bit
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True  # Double quantization per ulteriore compressione
)

# Caricare il modello quantizzato
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.2-3B",
    quantization_config=quantization_config,
    device_map="auto"
)

# Salvare in formato GGUF per mobile
# (richiede llama.cpp)
```

#### 2. Quantization-Aware Training (QAT)

##### Che cos'è?

Il modello viene trainato sapendo che verrà quantizzato, ottenendo qualità migliore.

##### Quando usarlo

- Quando la PTQ degrada troppo la qualità
- Per modelli mission-critical
- Quando hai risorse per il training

#### 3. GGUF - Il formato standard per mobile

##### Che cos'è?

**GGUF** (GPT-Generated Unified Format) è il formato standard per eseguire LLM su hardware consumer, inclusi smartphone.

##### Livelli di quantizzazione GGUF

| Formato | Descrizione | Uso consigliato |
|---------|-------------|-----------------|
| Q2_K | 2-bit | Solo esperimenti, qualità scarsa |
| Q3_K_S | 3-bit small | Dispositivi molto limitati |
| Q4_K_M | 4-bit medium | **Default consigliato** |
| Q5_K_M | 5-bit medium | App critiche |
| Q6_K | 6-bit | Qualità quasi FP16 |
| Q8_0 | 8-bit | Massima qualità quantizzata |

##### Conversione a GGUF

```bash
# Installare llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make

# Convertire modello HuggingFace a GGUF
python convert_hf_to_gguf.py \
    --model /path/to/model \
    --outfile model.gguf \
    --outtype q4_k_m  # Quantizzazione 4-bit
```

### Ottimizzazioni specifiche per mobile

#### 1. Operator Fusion

##### Che cos'è?

Combina operazioni multiple in una singola operazione ottimizzata.

```
PRIMA:  MatMul → Add → ReLU  (3 operazioni, 3 accessi memoria)
DOPO:   FusedMatMulAddReLU   (1 operazione, 1 accesso memoria)
```

#### 2. KV-Cache

##### Che cos'è?

Memorizza i vettori Key e Value già calcolati per non ricalcolarli ad ogni token.

##### Implementazione concettuale

```python
class KVCache:
    def __init__(self, max_length, num_layers, hidden_dim):
        self.keys = torch.zeros(num_layers, max_length, hidden_dim)
        self.values = torch.zeros(num_layers, max_length, hidden_dim)
        self.current_length = 0

    def update(self, layer_idx, new_k, new_v):
        pos = self.current_length
        self.keys[layer_idx, pos] = new_k
        self.values[layer_idx, pos] = new_v
        self.current_length += 1

    def get(self, layer_idx):
        return self.keys[layer_idx, :self.current_length], \
               self.values[layer_idx, :self.current_length]
```

#### 3. Speculative Decoding

##### Che cos'è?

Un modello piccolo (draft) genera candidati velocemente, il modello grande valida in batch.

```
1. Draft model genera: ["Il", "cane", "corre", "nel", "parco"]
2. Main model valida in parallelo tutti i token
3. Se validi, si accettano tutti (speedup ~2-3x)
4. Se invalidi, si corregge e riparte
```

#### 4. Per-Layer Embeddings (PLE) - Innovazione Gemma 3n

##### Che cos'è?

Invece di caricare tutti gli embedding in memoria, li carica dinamicamente per layer.

Risultato: modelli con parametri nominali 5B-8B eseguibili come se fossero 2B-3B.

### Configurazione hardware consigliata

| Tipo modello | RAM minima | NPU consigliato | Velocità attesa |
|--------------|------------|-----------------|-----------------|
| 1B params (INT4) | 4 GB | Qualsiasi | 100+ tok/s |
| 3B params (INT4) | 6 GB | 15+ TOPS | 50-80 tok/s |
| 7B params (INT4) | 8 GB | 30+ TOPS | 30-50 tok/s |
| 13B params (INT4) | 12 GB | 45+ TOPS | 15-30 tok/s |

**Fonti**: [Medium On-Device LLM](https://medium.com/@jiminlee-ai/on-device-llm-1ea0476a2df6), [ArXiv LLM Quantization Mobile](https://arxiv.org/html/2512.06490v1), [Local AI Zone Quantization Guide](https://local-ai-zone.github.io/guides/what-is-ai-quantization-q4-k-m-q8-gguf-guide-2025.html)

---

## 8. Confronto iOS vs Android

### Panoramica generale

| Aspetto | iOS | Android |
|---------|-----|---------|
| **Framework ufficiale** | Foundation Models | ML Kit GenAI + AICore |
| **Modello integrato** | Apple FM (~3B) | Gemini Nano (v3) |
| **Modelli open-source** | MLX, Core ML | MediaPipe, TensorFlow Lite |
| **NPU** | Neural Engine (Apple Silicon) | NPU vari (Qualcomm, MediaTek) |
| **Controllo sviluppatore** | Limitato (modello fisso) | Alto (modelli intercambiabili) |
| **Privacy** | Eccellente (tutto on-device) | Buona (AICore gestito) |

### Hardware AI

#### Apple Neural Engine

| Chip | Neural Engine | TOPS |
|------|---------------|------|
| A17 Pro | 16-core | 35 |
| A18 | 16-core | 40+ |
| M4 | 16-core | 38 |
| M4 Pro | 16-core | 40+ |

#### Android NPU (esempi)

| Chip | NPU | TOPS |
|------|-----|------|
| Snapdragon 8 Gen 3 | Hexagon | 45 |
| Snapdragon 8 Gen 4 | Hexagon | 65+ |
| Snapdragon 8 Gen 5 (2026) | Hexagon | 100+ |
| MediaTek Dimensity 9300 | APU 790 | 46 |
| Tensor G4 (Pixel 9) | Google TPU | 45 |

### API e framework

#### iOS

| Strumento | Scopo | Livello astrazione |
|-----------|-------|-------------------|
| Foundation Models | Accesso al FM Apple | Alto |
| Core ML | Modelli custom | Medio |
| MLX | Research/sperimentazione | Basso |
| Metal | GPU compute | Molto basso |

#### Android

| Strumento | Scopo | Livello astrazione |
|-----------|-------|-------------------|
| ML Kit GenAI | Gemini Nano | Alto |
| MediaPipe LLM | Gemma/modelli custom | Medio |
| TensorFlow Lite | Modelli TF | Medio |
| NNAPI | Hardware acceleration | Basso |

### Facilità di integrazione

#### iOS - Foundation Models

**Pro:**
- API Swift-native molto pulita
- Guided generation elimina parsing manuale
- Tool calling automatico
- Integrazione Xcode completa

**Contro:**
- Solo modello Apple, non intercambiabile
- Limitato a dispositivi con Apple Intelligence
- Context window fisso a 4096 token

**Complessità**: ⭐⭐ (bassa)

#### Android - ML Kit GenAI

**Pro:**
- API semplici per casi d'uso comuni
- AICore gestisce download/aggiornamenti
- Nessun costo di distribuzione modello

**Contro:**
- Meno flessibilità vs MediaPipe
- Limitato a dispositivi supportati

**Complessità**: ⭐⭐ (bassa)

#### Android - MediaPipe LLM

**Pro:**
- Massima flessibilità
- Qualsiasi modello Gemma/LLM compatibile
- LoRA adapters supportati
- Multimodale (testo + immagine + audio)

**Contro:**
- Più complesso da configurare
- Responsabilità distribuzione modello

**Complessità**: ⭐⭐⭐ (media)

### Performance comparative

Basandosi su benchmark recenti:

| Dispositivo | Modello | tok/s | TTFT |
|-------------|---------|-------|------|
| iPhone 17 Pro | Apple FM 3B | 136 | <50ms |
| iPhone 16 Pro | Apple FM 3B | 95 | <60ms |
| Pixel 10 Pro | Gemini Nano v3 | 100+ | <50ms |
| Galaxy S25 Ultra | Gemma 3n 4B | 91 | <50ms |
| OnePlus 13 | Gemma 3n 4B | 85 | <60ms |

### Quando scegliere cosa

| Scenario | Scelta consigliata |
|----------|-------------------|
| App iOS-only, massima semplicità | Foundation Models |
| App iOS, modello custom necessario | MLX + Core ML |
| App Android, casi d'uso standard | ML Kit GenAI |
| App Android, massima flessibilità | MediaPipe LLM |
| Cross-platform | MediaPipe (o Cactus) |
| Ricerca/sperimentazione | MLX (Apple) / MediaPipe (Android) |

### Tabella decisionale rapida

```
                              ┌─────────────────────┐
                              │  Ho bisogno di un   │
                              │  modello custom?    │
                              └─────────┬───────────┘
                                        │
                    ┌───────────────────┴───────────────────┐
                    │ NO                                     │ SÌ
                    ▼                                        ▼
        ┌───────────────────┐                   ┌───────────────────┐
        │   iOS?            │                   │   iOS?            │
        └─────────┬─────────┘                   └─────────┬─────────┘
                  │                                       │
         ┌───────┴───────┐                      ┌───────┴───────┐
         │ SÌ            │ NO                   │ SÌ            │ NO
         ▼               ▼                      ▼               ▼
   Foundation       ML Kit              MLX + Core ML      MediaPipe
     Models         GenAI                                    LLM
```

**Fonti**: [Fritz.ai Hardware Comparison](https://fritz.ai/hardware-acceleration-for-machine-learning-on-apple-and-android/), [TechlyFeed AI Comparison](https://www.techlyfeed.com/2025/12/android-vs-ios-ai-features-comparison.html), [Gizmochina Snapdragon 8 Gen 5](https://www.gizmochina.com/2025/12/24/on-device-ai-snapdragon-8-gen-5-npu-explained/)

---

## 9. Implementazione passo-passo

### Progetto iOS completo: assistente AI on-device

#### Requisiti

- Xcode 17+
- iOS 26 SDK
- Device con Apple Intelligence (A17 Pro+)

#### Step 1: Creare il progetto

```swift
// File: AIAssistantApp.swift
import SwiftUI
import FoundationModels

@main
struct AIAssistantApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
        }
    }
}
```

#### Step 2: Modello dati

```swift
// File: Models.swift
import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp: Date

    enum Role {
        case user
        case assistant
    }
}
```

#### Step 3: ViewModel con LanguageModelSession

```swift
// File: ChatViewModel.swift
import Foundation
import FoundationModels

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var session: LanguageModelSession?

    // Tools disponibili
    private let tools: [any Tool] = [
        WeatherTool(),
        ReminderTool(),
        CalculatorTool()
    ]

    init() {
        setupSession()
    }

    private func setupSession() {
        // Verificare disponibilità
        guard SystemLanguageModel.isAvailable else {
            errorMessage = "Apple Intelligence non disponibile su questo dispositivo"
            return
        }

        session = LanguageModelSession(tools: tools)
    }

    func sendMessage() async {
        guard !inputText.isEmpty else { return }
        guard let session = session else { return }

        let userMessage = ChatMessage(
            role: .user,
            content: inputText,
            timestamp: Date()
        )
        messages.append(userMessage)

        let prompt = inputText
        inputText = ""
        isLoading = true

        do {
            // Streaming response
            var responseText = ""
            for try await partial in session.streamResponse(to: prompt) {
                responseText = partial.content
            }

            let assistantMessage = ChatMessage(
                role: .assistant,
                content: responseText,
                timestamp: Date()
            )
            messages.append(assistantMessage)

        } catch {
            errorMessage = "Errore: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
```

#### Step 4: Implementare i tools

```swift
// File: Tools.swift
import FoundationModels
import CoreLocation
import EventKit

// MARK: - Weather Tool
@Generable
struct WeatherArgs {
    @Guide(description: "Nome della città")
    let city: String
}

struct WeatherTool: Tool {
    var name: String { "get_weather" }
    var description: String { "Ottiene le previsioni meteo per una città" }
    typealias Arguments = WeatherArgs

    func call(with args: WeatherArgs) async throws -> ToolOutput {
        // Qui integreresti un'API meteo reale
        // Per demo, restituiamo dati mock
        let weatherData = """
        Città: \(args.city)
        Temperatura: 18°C
        Condizioni: Parzialmente nuvoloso
        Umidità: 65%
        """
        return ToolOutput(content: weatherData)
    }
}

// MARK: - Reminder Tool
@Generable
struct ReminderArgs {
    @Guide(description: "Titolo del promemoria")
    let title: String

    @Guide(description: "Quando ricordare", .anyOf(["tra 5 minuti", "tra 1 ora", "domani mattina"]))
    let when: String
}

struct ReminderTool: Tool {
    var name: String { "create_reminder" }
    var description: String { "Crea un promemoria" }
    typealias Arguments = ReminderArgs

    func call(with args: ReminderArgs) async throws -> ToolOutput {
        // Integrazione con EventKit
        let store = EKEventStore()

        // Richiedere permessi
        try await store.requestFullAccessToReminders()

        let reminder = EKReminder(eventStore: store)
        reminder.title = args.title
        reminder.calendar = store.defaultCalendarForNewReminders()

        // Calcolare la data in base a "when"
        let triggerDate: Date
        switch args.when {
        case "tra 5 minuti":
            triggerDate = Date().addingTimeInterval(5 * 60)
        case "tra 1 ora":
            triggerDate = Date().addingTimeInterval(60 * 60)
        case "domani mattina":
            triggerDate = Calendar.current.date(
                bySettingHour: 9, minute: 0, second: 0,
                of: Date().addingTimeInterval(24 * 60 * 60)
            )!
        default:
            triggerDate = Date().addingTimeInterval(60 * 60)
        }

        reminder.dueDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )

        try store.save(reminder, commit: true)

        return ToolOutput(content: "Promemoria '\(args.title)' creato per \(args.when)")
    }
}

// MARK: - Calculator Tool
@Generable
struct CalculatorArgs {
    @Guide(description: "Espressione matematica da calcolare")
    let expression: String
}

struct CalculatorTool: Tool {
    var name: String { "calculate" }
    var description: String { "Esegue calcoli matematici" }
    typealias Arguments = CalculatorArgs

    func call(with args: CalculatorArgs) async throws -> ToolOutput {
        // Usare NSExpression per calcoli semplici
        let expression = NSExpression(format: args.expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return ToolOutput(content: "Risultato: \(result)")
        }
        return ToolOutput(content: "Impossibile calcolare l'espressione")
    }
}
```

#### Step 5: UI con SwiftUI

```swift
// File: ChatView.swift
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // Lista messaggi
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }

                // Indicatore di caricamento
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                        Text("Elaborazione...")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                // Input
                HStack {
                    TextField("Scrivi un messaggio...", text: $viewModel.inputText)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isLoading)

                    Button {
                        Task {
                            await viewModel.sendMessage()
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                }
                .padding()
            }
            .navigationTitle("AI Assistant")
            .alert("Errore", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer() }

            Text(message.content)
                .padding(12)
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(16)

            if message.role == .assistant { Spacer() }
        }
    }
}
```

---

### Progetto Android completo: assistente AI on-device

#### Requisiti

- Android Studio Ladybug+
- SDK 35+
- Device con Gemini Nano supportato (Pixel 9+, etc.)

#### Step 1: Configurare Gradle

```kotlin
// build.gradle.kts (app)
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    compileSdk = 35

    defaultConfig {
        minSdk = 28
        targetSdk = 35
    }

    buildFeatures {
        compose = true
    }
}

dependencies {
    // ML Kit GenAI
    implementation("com.google.mlkit:genai-prompt:1.0.0-alpha1")

    // Compose
    implementation(platform("androidx.compose:compose-bom:2025.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.0")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.0")
}
```

#### Step 2: Modello dati

```kotlin
// File: ChatModels.kt
package com.example.aiassistant

data class ChatMessage(
    val id: String = java.util.UUID.randomUUID().toString(),
    val role: Role,
    val content: String,
    val timestamp: Long = System.currentTimeMillis()
) {
    enum class Role { USER, ASSISTANT }
}
```

#### Step 3: ViewModel

```kotlin
// File: ChatViewModel.kt
package com.example.aiassistant

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.mlkit.genai.prompt.GenerationConfig
import com.google.mlkit.genai.prompt.PromptApi
import com.google.mlkit.genai.prompt.PromptApiOptions
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class ChatViewModel : ViewModel() {

    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages: StateFlow<List<ChatMessage>> = _messages

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading

    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error

    private var promptApi: PromptApi? = null

    init {
        initializePromptApi()
    }

    private fun initializePromptApi() {
        viewModelScope.launch {
            try {
                val generationConfig = GenerationConfig.Builder()
                    .setTemperature(0.7f)
                    .setTopK(40)
                    .setMaxOutputTokens(1024)
                    .build()

                val options = PromptApiOptions.Builder()
                    .setGenerationConfig(generationConfig)
                    .build()

                promptApi = PromptApi.getClient(options)

                // Pre-caricamento
                promptApi?.warmup()

            } catch (e: Exception) {
                _error.value = "Gemini Nano non disponibile: ${e.message}"
            }
        }
    }

    fun sendMessage(userInput: String) {
        if (userInput.isBlank()) return

        viewModelScope.launch {
            // Aggiungi messaggio utente
            val userMessage = ChatMessage(
                role = ChatMessage.Role.USER,
                content = userInput
            )
            _messages.value = _messages.value + userMessage

            _isLoading.value = true

            try {
                // Costruire il contesto della conversazione
                val conversationContext = buildConversationContext()
                val fullPrompt = """
                    $conversationContext

                    User: $userInput
                    Assistant:
                """.trimIndent()

                // Generare risposta
                val response = promptApi?.generateContent(fullPrompt)

                val assistantMessage = ChatMessage(
                    role = ChatMessage.Role.ASSISTANT,
                    content = response?.text ?: "Nessuna risposta generata"
                )
                _messages.value = _messages.value + assistantMessage

            } catch (e: Exception) {
                _error.value = "Errore: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    private fun buildConversationContext(): String {
        return _messages.value.takeLast(10).joinToString("\n") { msg ->
            val role = when (msg.role) {
                ChatMessage.Role.USER -> "User"
                ChatMessage.Role.ASSISTANT -> "Assistant"
            }
            "$role: ${msg.content}"
        }
    }

    fun clearError() {
        _error.value = null
    }
}
```

#### Step 4: UI con Jetpack Compose

```kotlin
// File: ChatScreen.kt
package com.example.aiassistant

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatScreen(
    viewModel: ChatViewModel = viewModel()
) {
    val messages by viewModel.messages.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val error by viewModel.error.collectAsState()

    var inputText by remember { mutableStateOf("") }
    val listState = rememberLazyListState()

    // Scroll automatico ai nuovi messaggi
    LaunchedEffect(messages.size) {
        if (messages.isNotEmpty()) {
            listState.animateScrollToItem(messages.size - 1)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("AI Assistant") }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            // Lista messaggi
            LazyColumn(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth(),
                state = listState,
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(messages) { message ->
                    MessageBubble(message = message)
                }
            }

            // Indicatore caricamento
            if (isLoading) {
                LinearProgressIndicator(
                    modifier = Modifier.fillMaxWidth()
                )
            }

            // Input
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = inputText,
                    onValueChange = { inputText = it },
                    modifier = Modifier.weight(1f),
                    placeholder = { Text("Scrivi un messaggio...") },
                    enabled = !isLoading
                )

                Spacer(modifier = Modifier.width(8.dp))

                Button(
                    onClick = {
                        viewModel.sendMessage(inputText)
                        inputText = ""
                    },
                    enabled = inputText.isNotBlank() && !isLoading
                ) {
                    Text("Invia")
                }
            }
        }
    }

    // Dialog errore
    error?.let { errorMessage ->
        AlertDialog(
            onDismissRequest = { viewModel.clearError() },
            title = { Text("Errore") },
            text = { Text(errorMessage) },
            confirmButton = {
                TextButton(onClick = { viewModel.clearError() }) {
                    Text("OK")
                }
            }
        )
    }
}

@Composable
fun MessageBubble(message: ChatMessage) {
    val isUser = message.role == ChatMessage.Role.USER

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isUser) Arrangement.End else Arrangement.Start
    ) {
        Box(
            modifier = Modifier
                .background(
                    color = if (isUser) MaterialTheme.colorScheme.primary
                            else MaterialTheme.colorScheme.surfaceVariant,
                    shape = RoundedCornerShape(16.dp)
                )
                .padding(12.dp)
                .widthIn(max = 280.dp)
        ) {
            Text(
                text = message.content,
                color = if (isUser) Color.White
                        else MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}
```

---

## 10. Risorse e riferimenti

### Documentazione ufficiale

#### Apple
- [Foundation Models Framework](https://developer.apple.com/documentation/FoundationModels)
- [WWDC25: Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25: Deep dive into Foundation Models](https://developer.apple.com/videos/play/wwdc2025/301/)
- [Tech Note TN3193: Managing Context Window](https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window)
- [Apple ML Research - Foundation Models 2025](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates)

#### Google
- [ML Kit GenAI APIs](https://developers.google.com/ml-kit/genai)
- [Prompt API Getting Started](https://developers.google.com/ml-kit/genai/prompt/android/get-started)
- [MediaPipe LLM Inference](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference)
- [Gemma Mobile Deployment](https://ai.google.dev/gemma/docs/integrations/mobile)
- [Gemma 3n Announcement](https://developers.googleblog.com/en/introducing-gemma-3n/)
- [FunctionGemma](https://blog.google/technology/developers/functiongemma/)

### Repository GitHub

| Repository | Descrizione |
|------------|-------------|
| [ml-explore/mlx-swift](https://github.com/ml-explore/mlx-swift) | MLX per Swift |
| [ml-explore/mlx-swift-examples](https://github.com/ml-explore/mlx-swift-examples) | Esempi MLX Swift |
| [google-ai-edge/gallery](https://github.com/google-ai-edge/gallery) | Google AI Edge Gallery |
| [stevelaskaridis/awesome-mobile-llm](https://github.com/stevelaskaridis/awesome-mobile-llm) | Lista curata mobile LLM |
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | LLM inference in C++ |

### Paper accademici

- [Apple Intelligence Foundation Language Models Tech Report 2025](https://arxiv.org/abs/2507.13575)
- [Optimizing LLMs Using Quantization for Mobile Execution](https://arxiv.org/html/2512.06490v1)
- [Large Language Model Performance Benchmarking on Mobile Platforms](https://arxiv.org/html/2410.03613v1)

### Tool e framework

| Strumento | Uso |
|-----------|-----|
| [Cactus](https://www.infoq.com/news/2025/12/cactus-on-device-inference/) | Cross-platform LLM inference |
| [LangChain](https://langchain.com) | Framework agenti AI |
| [DroidRun](https://research.aimultiple.com/mobile-ai-agent/) | Mobile AI agents Android |

### Community e blog

- [CreateWithSwift - Foundation Models](https://www.createwithswift.com/exploring-the-foundation-models-framework/)
- [Android Developers Blog](https://android-developers.googleblog.com/)
- [Medium - On-Device LLM](https://medium.com/@jiminlee-ai/on-device-llm-1ea0476a2df6)
- [InfoQ - Gemini Nano ML Kit](https://www.infoq.com/news/2025/06/google-mlkit-genai-gemini-nano/)

---

## Conclusioni

Lo stato dell'arte dei foundation model on-device a gennaio 2026 mostra un ecosistema maturo con due approcci principali:

1. **Apple** offre un'esperienza integrata verticalmente con il Foundation Models Framework, ideale per sviluppatori che vogliono massima semplicità e ottima qualità senza configurazione.

2. **Google/Android** offre maggiore flessibilità con Gemini Nano (per casi d'uso standard) e MediaPipe/Gemma (per personalizzazione avanzata).

Le architetture agentiche stanno emergendo come paradigma dominante, con pattern come ReAct e planning agents che permettono applicazioni AI veramente autonome.

Il function calling è ora supportato nativamente su entrambe le piattaforme, abilitando assistenti AI che possono agire nel mondo reale (calendario, notifiche, API esterne).

La quantizzazione a 4-bit è diventata lo standard, permettendo modelli 3-7B parametri su smartphone mid-range con prestazioni conversazionali (50-100+ tok/s).

---

## Licenza

Questo documento è rilasciato per scopi educativi e di ricerca.

---

*Report generato: Gennaio 2026*
