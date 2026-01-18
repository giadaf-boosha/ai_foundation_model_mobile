# Function Calling e Tool Use per LLM Mobile: Guida Completa

> Approfondimento tecnico su come implementare function calling e tool use su dispositivi mobili iOS e Android.

---

## Indice

1. [Cos'è il function calling](#cosè-il-function-calling)
2. [Apple Foundation Models - Tool Calling](#apple-foundation-models---tool-calling)
3. [FunctionGemma per Android](#functiongemma-per-android)
4. [Model Context Protocol (MCP)](#model-context-protocol-mcp)
5. [Pattern di implementazione](#pattern-di-implementazione)
6. [Best practices](#best-practices)
7. [Confronto piattaforme](#confronto-piattaforme)

---

## Cos'è il function calling

Il **function calling** (o tool calling) permette a un LLM di invocare funzioni esterne definite dallo sviluppatore, estendendo le sue capacità oltre la generazione di testo.

### Il problema che risolve

| Senza function calling | Con function calling |
|------------------------|----------------------|
| LLM genera solo testo | LLM può eseguire azioni |
| Informazioni statiche | Dati real-time |
| Isolato dall'app | Integrato nel sistema |
| Hallucination su dati | Dati verificati da API |

### Flow tipico

```
┌──────────┐    ┌─────────┐    ┌──────────┐    ┌──────────┐
│  User    │───▶│   LLM   │───▶│  Tool    │───▶│ Response │
│  Input   │    │         │    │  Call    │    │   +      │
│          │    │         │◀───│          │◀───│  Result  │
└──────────┘    └─────────┘    └──────────┘    └──────────┘
```

### Esempio pratico

**Input utente**: "Che tempo fa a Milano?"

**Senza function calling**:
```
Il tempo a Milano è generalmente... [informazioni potenzialmente obsolete]
```

**Con function calling**:
```
1. LLM identifica: serve weather data
2. LLM chiama: getWeather(city: "Milano")
3. API ritorna: { temp: 15°C, conditions: "nuvoloso" }
4. LLM risponde: "A Milano ci sono 15°C con cielo nuvoloso"
```

---

## Apple Foundation Models - Tool Calling

### Overview (WWDC 2025)

Apple ha introdotto il **Foundation Models framework** alla WWDC 2025, dando agli sviluppatori accesso diretto al modello on-device (~3B parametri) che alimenta Apple Intelligence.

> "Tool calling allows the model to autonomously execute code you define in your app."
> — Apple Developer Documentation

### Il protocollo Tool

In Swift, i tool sono definiti implementando il protocollo `Tool`:

```swift
import FoundationModels

struct WeatherTool: Tool {
    // Nome e descrizione per il modello
    let name = "getWeather"
    let description = "Ottiene il meteo attuale per una città"

    // Schema dei parametri (guided generation)
    @Generable
    struct Parameters {
        let city: String
        let units: Units

        enum Units: String, Generable {
            case celsius, fahrenheit
        }
    }

    // Implementazione
    func call(with parameters: Parameters) async throws -> String {
        let weather = try await WeatherKit.current(for: parameters.city)
        return "Temperatura: \(weather.temp)°\(parameters.units)"
    }
}
```

### Guided Generation

La chiave del sistema Apple è la **guided generation** con il macro `@Generable`:

```swift
@Generable
struct TravelPlan {
    let destination: String
    let departureDate: Date
    let activities: [Activity]

    @Generable
    struct Activity {
        let name: String
        let duration: TimeInterval
    }
}
```

**Vantaggi di Guided Generation:**
- Garantisce correttezza strutturale (constrained decoding)
- Prompt più semplici (focus sul comportamento, non sul formato)
- Migliora l'accuratezza del modello

### Registrazione dei tool

```swift
let session = LanguageModelSession()

// Registra i tool disponibili
session.tools = [
    WeatherTool(),
    CalendarTool(),
    MapsTool()
]

// Il modello può ora chiamare autonomamente questi tool
let response = try await session.respond(
    to: "Pianifica il mio weekend a Roma"
)
```

### Call graph automatico

Il framework gestisce automaticamente grafi di chiamate complessi:

```
User: "Organizza il viaggio a Roma questo weekend"
    │
    ├── WeatherTool.call(city: "Roma", date: weekend)
    │       ↓
    │   [temp: 18°C, sunny]
    │
    ├── CalendarTool.checkAvailability(weekend)
    │       ↓
    │   [sabato: libero, domenica: impegno ore 18]
    │
    └── MapsTool.getAttractions(city: "Roma")
            ↓
        [Colosseo, Vaticano, Trastevere...]

Final Response: Piano dettagliato con meteo, disponibilità e attrazioni
```

### Integrazione con framework Apple

Tool calling si integra nativamente con:
- **WeatherKit**: meteo real-time
- **MapKit**: mappe e luoghi
- **EventKit**: calendario e reminder
- **Contacts**: rubrica
- **HealthKit**: dati salute

---

## FunctionGemma per Android

### Overview

[FunctionGemma](https://blog.google/technology/developers/functiongemma/) è un modello Gemma 3 da **270M parametri** specializzato per function calling on-device, rilasciato da Google a dicembre 2025.

### Specifiche tecniche

| Caratteristica | Valore |
|----------------|--------|
| Parametri | 270M |
| Dimensione | 288 MB |
| Velocità decode | ~126 tok/s |
| Accuracy (fine-tuned) | 85% |
| Accuracy (baseline) | 58% |

### Use case mobile

FunctionGemma traduce linguaggio naturale in chiamate a strumenti Android:

```
Input: "Crea un evento calendario per pranzo domani"
Output: {
    "function": "createCalendarEvent",
    "parameters": {
        "title": "Pranzo",
        "date": "2026-01-19",
        "time": "12:30"
    }
}
```

### Formato delle function definitions

```json
{
    "name": "send_message",
    "description": "Invia un messaggio a un contatto",
    "parameters": {
        "type": "object",
        "properties": {
            "recipient": {
                "type": "string",
                "description": "Nome del destinatario"
            },
            "message": {
                "type": "string",
                "description": "Contenuto del messaggio"
            }
        },
        "required": ["recipient", "message"]
    }
}
```

### Deployment su Android

#### 1. Conversione del modello

```python
import ai_edge_torch

# Converti in TFLite con quantizzazione
model_tflite = ai_edge_torch.convert(
    model,
    quantization="dynamic_int8"
)
model_tflite.export("functiongemma.tflite")
```

#### 2. Creazione bundle MediaPipe

```python
from mediapipe.tasks.python.genai import bundle_config

config = bundle_config.BundleConfig(
    tflite_model="functiongemma.tflite",
    tokenizer_model="tokenizer.model",
    stop_tokens=["<end_of_turn>"]
)

bundle_config.create_bundle(config, "functiongemma.task")
```

#### 3. Uso nell'app Android

```kotlin
import com.google.mediapipe.tasks.genai.llminference.*

class FunctionCallingService(context: Context) {

    private val llmInference: LlmInference

    init {
        val options = LlmInference.LlmInferenceOptions.builder()
            .setModelPath("/path/to/functiongemma.task")
            .setMaxTokens(256)
            .build()

        llmInference = LlmInference.createFromOptions(context, options)
    }

    suspend fun parseIntent(userInput: String): FunctionCall {
        val prompt = buildPrompt(userInput, availableFunctions)
        val response = llmInference.generateResponse(prompt)
        return parseFunctionCall(response)
    }
}
```

### Fine-tuning per domini custom

FunctionGemma può essere fine-tuned per tool specifici dell'app:

```python
# Dataset di training
training_data = [
    {
        "input": "Ordina una pizza margherita",
        "output": {
            "function": "place_order",
            "parameters": {"item": "pizza margherita", "quantity": 1}
        }
    },
    # ... altri esempi
]

# Fine-tuning con Unsloth
from unsloth import FastLanguageModel

model, tokenizer = FastLanguageModel.from_pretrained(
    "google/functiongemma-270m-it"
)

# Training
trainer.train(training_data)
```

### AI Edge Gallery

Google fornisce [AI Edge Gallery](https://github.com/google-ai-edge/gallery) con un'opzione "Mobile Actions" pronta all'uso per testare FunctionGemma.

---

## Model Context Protocol (MCP)

### Cos'è MCP

Il **Model Context Protocol** è uno standard open-source introdotto da Anthropic nel novembre 2024 per standardizzare l'integrazione tra LLM e tool esterni.

> MCP è come "USB-C per applicazioni AI" — un connettore universale che permette a qualsiasi modello AI di comunicare con qualsiasi tool attraverso un'interfaccia standardizzata.

### Adozione (2025-2026)

| Data | Milestone |
|------|-----------|
| Nov 2024 | Lancio da parte di Anthropic |
| Mar 2025 | OpenAI adotta MCP in ChatGPT |
| Dic 2025 | MCP donato alla Linux Foundation |
| 2025 | 97M+ download SDK mensili |

Supportato da: Anthropic, OpenAI, Google, Microsoft

### Architettura MCP

```
┌─────────────────────────────────────────────────────┐
│                    LLM APPLICATION                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────┐         ┌──────────────────────────┐ │
│  │   LLM    │────────▶│      MCP Client          │ │
│  └──────────┘         └───────────┬──────────────┘ │
│                                   │                 │
└───────────────────────────────────┼─────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
              ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
              │MCP Server │  │MCP Server │  │MCP Server │
              │ (Weather) │  │(Calendar) │  │ (Files)   │
              └─────┬─────┘  └─────┬─────┘  └─────┬─────┘
                    │              │              │
              ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
              │Weather API│  │Google Cal │  │Local FS   │
              └───────────┘  └───────────┘  └───────────┘
```

### Componenti MCP

#### 1. MCP Server
Espone tool/risorse attraverso il protocollo standard:

```json
{
    "name": "weather-server",
    "version": "1.0.0",
    "tools": [
        {
            "name": "get_weather",
            "description": "Get current weather for a location",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "location": {"type": "string"}
                }
            }
        }
    ]
}
```

#### 2. MCP Client
Intercetta le richieste dell'LLM e gestisce le chiamate:

```
LLM Output: "Chiamo get_weather con location='Milano'"
    │
    ▼
MCP Client: Intercetta, valida, esegue
    │
    ▼
MCP Server: Esegue la chiamata API
    │
    ▼
Result: { "temp": 15, "conditions": "cloudy" }
    │
    ▼
LLM: Continua con il risultato nel contesto
```

### MCP su Mobile

Per applicazioni mobile, MCP può essere implementato:

#### Architettura embedded
```
┌─────────────────────────────────────┐
│           MOBILE APP                 │
├─────────────────────────────────────┤
│  ┌─────────┐    ┌────────────────┐ │
│  │On-device│───▶│ MCP Client     │ │
│  │  LLM    │    │ (embedded)     │ │
│  └─────────┘    └───────┬────────┘ │
│                         │          │
│  ┌──────────────────────▼────────┐ │
│  │     Local MCP Servers         │ │
│  │  ┌────────┐  ┌────────┐      │ │
│  │  │Contacts│  │Calendar│ ...  │ │
│  │  └────────┘  └────────┘      │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### Considerazioni di sicurezza

La ricerca di Knostic (luglio 2025) ha identificato rischi con MCP server esposti su internet senza autenticazione. Per mobile:

- **Sempre** implementare autenticazione
- Limitare i server a connessioni locali
- Validare tutti gli input
- Usare permission system del OS

---

## Pattern di implementazione

### 1. Direct tool calling (semplice)

Per casi d'uso semplici con pochi tool:

```
User Input → LLM → Tool Call → Result → LLM → Response
```

**Pro**: Semplice, bassa latenza
**Contro**: Limitato a scenari base

### 2. ReAct + Tools (flessibile)

Combina reasoning con tool calling:

```
User Input → [Thought → Action → Observation]* → Response
```

**Pro**: Gestisce task complessi
**Contro**: Più lento, più token

### 3. Router pattern (scalabile)

Un LLM piccolo decide quale tool/specialist chiamare:

```
              ┌──────────┐
              │  Router  │
              │  (270M)  │
              └────┬─────┘
         ┌────────┼────────┐
         ▼        ▼        ▼
    ┌────────┐┌────────┐┌────────┐
    │Tool A  ││Tool B  ││LLM 3B  │
    │(API)   ││(Local) ││(Complex│
    └────────┘└────────┘└────────┘
```

**Pro**: Efficiente, specializzato
**Contro**: Setup più complesso

### 4. Hybrid local/cloud

Tool semplici locali, complessi su cloud:

```swift
func routeToolCall(_ call: ToolCall) async -> ToolResult {
    if call.complexity == .low || !hasNetwork {
        return await executeLocally(call)
    } else {
        return await executeOnCloud(call)
    }
}
```

---

## Best practices

### 1. Definizioni tool chiare

```swift
// ❌ Cattiva definizione
let name = "do_thing"
let description = "Does a thing"

// ✅ Buona definizione
let name = "getWeatherForecast"
let description = """
    Ottiene le previsioni meteo per i prossimi N giorni.
    Usa questo tool quando l'utente chiede del tempo futuro,
    non per il meteo attuale (usa getCurrentWeather per quello).
    """
```

### 2. Gestione errori robusta

```swift
struct WeatherTool: Tool {
    func call(with params: Parameters) async throws -> String {
        do {
            let weather = try await api.fetch(params.city)
            return formatSuccess(weather)
        } catch APIError.cityNotFound {
            return "Città '\(params.city)' non trovata. Verifica il nome."
        } catch APIError.networkError {
            return "Impossibile ottenere il meteo. Riprova più tardi."
        } catch {
            return "Errore sconosciuto: \(error.localizedDescription)"
        }
    }
}
```

### 3. Limita il numero di tool

| Numero tool | Raccomandazione |
|-------------|-----------------|
| 1-5 | Ideale per mobile |
| 6-10 | Accettabile |
| 10+ | Considera grouping o router |

### 4. Timeout appropriati

```kotlin
val toolCallTimeout = when (tool) {
    is LocalTool -> 1.seconds
    is NetworkTool -> 5.seconds
    is ComplexTool -> 15.seconds
}
```

### 5. Caching intelligente

```swift
class CachedWeatherTool: Tool {
    private var cache: [String: (Weather, Date)] = [:]
    private let cacheValidity = TimeInterval(300) // 5 min

    func call(with params: Parameters) async throws -> String {
        if let cached = cache[params.city],
           Date().timeIntervalSince(cached.1) < cacheValidity {
            return format(cached.0)
        }

        let weather = try await api.fetch(params.city)
        cache[params.city] = (weather, Date())
        return format(weather)
    }
}
```

### 6. Feedback all'utente

```swift
// Mostra cosa sta facendo l'agente
func executeWithFeedback(_ call: ToolCall) async {
    await ui.show(message: "Cerco informazioni meteo...")
    let result = await tool.call(call.parameters)
    await ui.hide()
    return result
}
```

---

## Confronto piattaforme

### Apple Foundation Models vs FunctionGemma

| Aspetto | Apple FM | FunctionGemma |
|---------|----------|---------------|
| **Dimensione modello** | ~3B | 270M |
| **Approccio** | Guided generation | JSON schema |
| **Linguaggio** | Swift nativo | Multi-platform |
| **Accuratezza** | Alta (constrained) | 85% (fine-tuned) |
| **Personalizzazione** | Tool protocol | Fine-tuning |
| **Latenza** | Ottimizzata ANE | ~126 tok/s |
| **Disponibilità** | iOS/macOS 26+ | Android, iOS, Web |

### Quando usare cosa

```
iOS app nativa         → Apple Foundation Models
Android app nativa     → FunctionGemma + MediaPipe
Cross-platform         → FunctionGemma + MCP
Task molto complessi   → Hybrid con cloud fallback
```

### Esempio comparativo

**Task**: "Trova ristoranti italiani vicino a me"

**Apple FM (Swift)**:
```swift
struct RestaurantTool: Tool {
    @Generable struct Params {
        let cuisine: String
        let maxDistance: Double
    }

    func call(with params: Params) async throws -> String {
        let restaurants = try await MapKit.search(
            query: params.cuisine,
            radius: params.maxDistance
        )
        return restaurants.formatted()
    }
}
```

**FunctionGemma (Kotlin)**:
```kotlin
val functionDef = """
{
    "name": "search_restaurants",
    "parameters": {
        "cuisine": {"type": "string"},
        "max_distance_km": {"type": "number"}
    }
}
"""

val response = llm.generate(buildPrompt(userInput, functionDef))
val call = parseFunction(response)
val results = mapsApi.searchNearby(call.params)
```

---

## Risorse aggiuntive

### Documentazione ufficiale

#### Apple
- [Foundation Models Documentation](https://developer.apple.com/documentation/FoundationModels)
- [WWDC25: Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [WWDC25: Deep dive into Foundation Models](https://developer.apple.com/videos/play/wwdc2025/301/)

#### Google
- [FunctionGemma Overview](https://ai.google.dev/gemma/docs/functiongemma)
- [Fine-tune FunctionGemma for Mobile Actions](https://ai.google.dev/gemma/docs/mobile-actions)
- [FunctionGemma su Hugging Face](https://huggingface.co/google/functiongemma-270m-it)

#### MCP
- [Model Context Protocol Specification](https://modelcontextprotocol.io/specification/2025-11-25)
- [MCP GitHub Organization](https://github.com/modelcontextprotocol)

### Tutorial

- [Foundation Models on iOS 26 Guide](https://medium.com/@himalimarasinghe/foundation-models-framework-on-ios-26-a-simple-guide-to-guided-generation-streaming-and-tool-3bdbb1374441)
- [On-Device Function Calling with FunctionGemma](https://medium.com/google-developer-experts/on-device-function-calling-with-functiongemma-39f7407e5d83)
- [Tools for Your LLM: Deep Dive into MCP](https://towardsdatascience.com/tools-for-your-llm-a-deep-dive-into-mcp/)

---

## Glossario

| Termine | Definizione |
|---------|-------------|
| **Function calling** | Capacità dell'LLM di invocare funzioni esterne |
| **Tool** | Funzione o API che l'LLM può chiamare |
| **Guided generation** | Generazione vincolata a strutture dati specifiche |
| **Constrained decoding** | Tecnica che forza output strutturalmente corretti |
| **MCP** | Model Context Protocol, standard per tool integration |
| **MCP Server** | Componente che espone tool via MCP |
| **MCP Client** | Componente che orchestra chiamate MCP |
| **Router** | Pattern che smista richieste a tool specializzati |

---

*Ultimo aggiornamento: Gennaio 2026*
