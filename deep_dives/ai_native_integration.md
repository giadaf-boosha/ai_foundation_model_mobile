# Foundation Models e Sviluppo Nativo Mobile: Integrazione Pratica

> Come i modelli AI on-device interagiscono con i componenti primitivi dello sviluppo nativo iOS e Android: architetture, pattern, gestione dati e best practice.

**Nota**: Questa guida contiene esempi di codice e implementazioni pratiche. Per una spiegazione teorica e narrativa degli stessi concetti, vedi [ai_native_integration_theory.md](ai_native_integration_theory.md).

---

## Indice

1. [Introduzione](#introduzione)
2. [Architetture a Confronto](#architetture-a-confronto)
3. [iOS: Foundation Models + SwiftUI](#ios-foundation-models--swiftui)
4. [Android: Gemini Nano + Jetpack Compose](#android-gemini-nano--jetpack-compose)
5. [Gestione del Contesto e della Memoria](#gestione-del-contesto-e-della-memoria)
6. [Persistenza dei Dati](#persistenza-dei-dati)
7. [Data Flow e State Management](#data-flow-e-state-management)
8. [Tool Calling e Integrazione API di Sistema](#tool-calling-e-integrazione-api-di-sistema)
9. [Pattern di Error Handling](#pattern-di-error-handling)
10. [Best Practice e Raccomandazioni](#best-practice-e-raccomandazioni)

---

## Introduzione

L'integrazione di Foundation Models on-device con lo sviluppo mobile nativo richiede una comprensione profonda di come questi modelli interagiscono con i pattern architetturali classici. Questa guida esplora praticamente:

- Come i modelli AI si inseriscono nelle architetture **MVC/MVVM/Clean Architecture**
- Come gestiscono il **contesto** e lo **stato** delle conversazioni
- Come interagiscono con **database locali** (CoreData, SwiftData, Room)
- Come si integrano con i **framework UI** nativi (SwiftUI, Jetpack Compose)
- Come implementare **function calling** per accedere alle API di sistema

### Risorse Principali

| Piattaforma | Documentazione | Cookbook |
|-------------|----------------|----------|
| **iOS** | [Foundation Models Docs](https://developer.apple.com/documentation/FoundationModels) | [WWDC25 Code-Along](https://developer.apple.com/videos/play/wwdc2025/259/) |
| **Android** | [ML Kit GenAI](https://developer.android.com/ai/gemini-nano/ml-kit-genai) | [MediaPipe Samples](https://github.com/google-ai-edge/mediapipe-samples) |
| **Cross-platform** | [Gemini Cookbook](https://github.com/google-gemini/cookbook) | [Gemma Cookbook](https://github.com/google-gemini/gemma-cookbook) |

---

## Architetture a Confronto

### Il Dibattito MVC vs MVVM con AI

L'introduzione di Foundation Models non cambia le architetture fondamentali, ma aggiunge nuove considerazioni:

| Aspetto | MVC Tradizionale | MVVM con AI | Clean Architecture + AI |
|---------|------------------|-------------|-------------------------|
| **Dove vive il modello AI** | Model layer | ViewModel | Use Case / Repository |
| **Gestione stato conversazione** | Controller | ViewModel (@Observable) | Repository dedicato |
| **Streaming risposte** | Delegate pattern | Combine/Flow | Use Case con callback |
| **Tool calling** | Servizi separati | ViewModel coordina | Interactor pattern |

### Pattern Consigliato per AI Mobile

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI LAYER                                 │
│   SwiftUI Views / Jetpack Compose                               │
│   - Osserva stato streaming                                     │
│   - Mostra risposte parziali                                    │
│   - Gestisce input utente                                       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│   ViewModel / @Observable                                        │
│   - Mantiene UI State                                           │
│   - Coordina richieste AI                                       │
│   - Gestisce streaming token                                    │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                               │
│   Use Cases / Interactors                                        │
│   - Business logic                                              │
│   - Orchestrazione tool calling                                 │
│   - Validazione input/output                                    │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                │
│   ┌─────────────────┐  ┌─────────────────┐  ┌────────────────┐ │
│   │  AI Repository  │  │  Chat History   │  │  Tool Services │ │
│   │                 │  │   Repository    │  │                │ │
│   │ - Session mgmt  │  │ - SwiftData     │  │ - MapKit       │ │
│   │ - Context       │  │ - Room DB       │  │ - Calendar     │ │
│   │ - Inference     │  │ - Persistence   │  │ - Contacts     │ │
│   └─────────────────┘  └─────────────────┘  └────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## iOS: Foundation Models + SwiftUI

### Struttura Base con @Observable

Apple consiglia l'uso di `@Observable` (iOS 17+) invece di `ObservableObject` per una gestione dello stato più efficiente:

```swift
import FoundationModels
import SwiftUI

@MainActor
@Observable
class ChatViewModel {
    // Stato UI
    var messages: [ChatMessage] = []
    var currentResponse: String = ""
    var isGenerating: Bool = false
    var errorMessage: String?

    // Sessione AI (mantiene contesto conversazione)
    private var session: LanguageModelSession

    init() {
        // Inizializza con istruzioni di sistema
        self.session = LanguageModelSession {
            """
            Sei un assistente italiano amichevole.
            Rispondi in modo conciso e utile.
            """
        }
    }

    // MARK: - Generazione con Streaming

    func sendMessage(_ text: String) async {
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        isGenerating = true
        currentResponse = ""

        do {
            // Streaming: ogni token aggiorna la UI
            let stream = session.streamResponse(to: text)

            for try await partialResponse in stream {
                currentResponse = partialResponse
            }

            // Risposta completa
            let assistantMessage = ChatMessage(
                role: .assistant,
                content: currentResponse
            )
            messages.append(assistantMessage)

        } catch {
            errorMessage = error.localizedDescription
        }

        isGenerating = false
        currentResponse = ""
    }
}
```

### Integrazione SwiftUI con Streaming

```swift
struct ChatView: View {
    @State private var viewModel = ChatViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack {
            // Lista messaggi
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                        }

                        // Risposta in streaming
                        if viewModel.isGenerating {
                            StreamingBubble(text: viewModel.currentResponse)
                                .id("streaming")
                        }
                    }
                }
                .onChange(of: viewModel.currentResponse) {
                    withAnimation {
                        proxy.scrollTo("streaming", anchor: .bottom)
                    }
                }
            }

            // Input
            HStack {
                TextField("Scrivi un messaggio...", text: $inputText)
                    .textFieldStyle(.roundedBorder)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                }
                .disabled(inputText.isEmpty || viewModel.isGenerating)
            }
            .padding()
        }
    }

    private func sendMessage() {
        let text = inputText
        inputText = ""
        Task {
            await viewModel.sendMessage(text)
        }
    }
}
```

### Guided Generation con @Generable

Per output strutturati e type-safe:

```swift
import FoundationModels

// Definizione tipi strutturati
@Generable
struct RecipeResponse: Equatable {
    @Guide(description: "Nome della ricetta")
    let name: String

    @Guide(description: "Tempo di preparazione in minuti", .range(5...120))
    let prepTimeMinutes: Int

    @Guide(description: "Lista ingredienti")
    let ingredients: [Ingredient]

    @Guide(description: "Passaggi della ricetta")
    let steps: [String]
}

@Generable
struct Ingredient: Equatable {
    let name: String
    let quantity: Double

    @Guide(.anyOf(["grammi", "kg", "ml", "litri", "cucchiai", "tazze", "pezzi"]))
    let unit: String
}

// ViewModel con output strutturato
@Observable
class RecipeViewModel {
    var recipe: RecipeResponse.PartiallyGenerated?
    var isLoading = false

    private let session = LanguageModelSession()

    func generateRecipe(ingredients: [String]) async throws {
        isLoading = true

        let prompt = "Crea una ricetta con: \(ingredients.joined(separator: ", "))"

        // Streaming con tipo strutturato
        let stream = session.streamResponse(
            to: prompt,
            generating: RecipeResponse.self
        )

        for try await partial in stream {
            // partial ha tutte le proprietà opzionali
            // si popolano man mano che il modello genera
            recipe = partial
        }

        isLoading = false
    }
}
```

### Verifica Disponibilità Modello

```swift
struct AIFeatureView: View {
    private let model = SystemLanguageModel.default

    var body: some View {
        Group {
            switch model.availability {
            case .available:
                ChatView()

            case .unavailable(.appleIntelligenceNotEnabled):
                UnavailableView(
                    title: "Apple Intelligence Disabilitato",
                    message: "Abilita Apple Intelligence in Impostazioni > Apple Intelligence & Siri"
                )

            case .unavailable(.modelNotReady):
                ProgressView("Modello in download...")

            case .unavailable(.deviceNotEligible):
                UnavailableView(
                    title: "Dispositivo Non Supportato",
                    message: "Richiede iPhone 15 Pro o successivo"
                )

            default:
                UnavailableView(
                    title: "Non Disponibile",
                    message: "Funzionalità AI non disponibile"
                )
            }
        }
    }
}
```

---

## Android: Gemini Nano + Jetpack Compose

### Setup con Dependency Injection (Hilt)

```kotlin
// Module Hilt per AI
@Module
@InstallIn(SingletonComponent::class)
object AIModule {

    @Provides
    @Singleton
    fun provideLlmInference(
        @ApplicationContext context: Context
    ): LlmInference {
        val options = LlmInference.LlmInferenceOptions.builder()
            .setModelPath("/data/local/tmp/llm/gemma-3-1b-it-int4.task")
            .setMaxTokens(1024)
            .setTopK(40)
            .setTemperature(0.8f)
            .build()

        return LlmInference.createFromOptions(context, options)
    }

    @Provides
    @Singleton
    fun provideChatRepository(
        llmInference: LlmInference,
        chatDao: ChatDao
    ): ChatRepository {
        return ChatRepositoryImpl(llmInference, chatDao)
    }
}
```

### Repository Pattern per AI

```kotlin
interface ChatRepository {
    fun getConversationHistory(): Flow<List<ChatMessage>>
    suspend fun sendMessage(text: String): Flow<String>
    suspend fun clearHistory()
}

class ChatRepositoryImpl @Inject constructor(
    private val llmInference: LlmInference,
    private val chatDao: ChatDao
) : ChatRepository {

    override fun getConversationHistory(): Flow<List<ChatMessage>> {
        return chatDao.getAllMessages()
    }

    override suspend fun sendMessage(text: String): Flow<String> = callbackFlow {
        // Salva messaggio utente
        chatDao.insertMessage(
            ChatMessage(role = "user", content = text)
        )

        // Costruisci contesto con history
        val history = chatDao.getRecentMessages(limit = 10)
        val contextPrompt = buildContextPrompt(history, text)

        // Streaming response
        val options = LlmInference.LlmInferenceOptions.builder()
            .setResultListener { partialResult, done ->
                trySend(partialResult)

                if (done) {
                    // Salva risposta completa
                    launch {
                        chatDao.insertMessage(
                            ChatMessage(role = "assistant", content = partialResult)
                        )
                    }
                    close()
                }
            }
            .setErrorListener { error ->
                close(error)
            }
            .build()

        llmInference.generateResponseAsync(contextPrompt)

        awaitClose { }
    }

    private fun buildContextPrompt(
        history: List<ChatMessage>,
        newMessage: String
    ): String {
        val historyText = history.joinToString("\n") { msg ->
            when (msg.role) {
                "user" -> "User: ${msg.content}"
                "assistant" -> "Assistant: ${msg.content}"
                else -> msg.content
            }
        }

        return """
            $historyText
            User: $newMessage
            Assistant:
        """.trimIndent()
    }
}
```

### ViewModel con StateFlow

```kotlin
@HiltViewModel
class ChatViewModel @Inject constructor(
    private val chatRepository: ChatRepository
) : ViewModel() {

    // UI State
    private val _uiState = MutableStateFlow(ChatUiState())
    val uiState: StateFlow<ChatUiState> = _uiState.asStateFlow()

    // Conversation history
    val messages = chatRepository.getConversationHistory()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    fun sendMessage(text: String) {
        viewModelScope.launch {
            _uiState.update { it.copy(isGenerating = true, currentResponse = "") }

            try {
                chatRepository.sendMessage(text)
                    .collect { partialResponse ->
                        _uiState.update {
                            it.copy(currentResponse = partialResponse)
                        }
                    }
            } catch (e: Exception) {
                _uiState.update {
                    it.copy(error = e.message)
                }
            } finally {
                _uiState.update {
                    it.copy(isGenerating = false, currentResponse = "")
                }
            }
        }
    }
}

data class ChatUiState(
    val isGenerating: Boolean = false,
    val currentResponse: String = "",
    val error: String? = null
)
```

### Composable UI con Streaming

```kotlin
@Composable
fun ChatScreen(
    viewModel: ChatViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    val messages by viewModel.messages.collectAsState()

    val listState = rememberLazyListState()

    // Auto-scroll durante streaming
    LaunchedEffect(uiState.currentResponse) {
        if (uiState.isGenerating) {
            listState.animateScrollToItem(messages.size)
        }
    }

    Scaffold(
        bottomBar = {
            ChatInputBar(
                enabled = !uiState.isGenerating,
                onSend = { viewModel.sendMessage(it) }
            )
        }
    ) { padding ->
        LazyColumn(
            state = listState,
            contentPadding = padding,
            modifier = Modifier.fillMaxSize()
        ) {
            items(messages) { message ->
                MessageBubble(message)
            }

            // Streaming response
            if (uiState.isGenerating && uiState.currentResponse.isNotEmpty()) {
                item {
                    StreamingBubble(
                        text = uiState.currentResponse,
                        modifier = Modifier.animateItem()
                    )
                }
            }
        }
    }
}
```

### ML Kit GenAI APIs (Alternativa Semplificata)

Per casi d'uso standard, ML Kit offre API ad alto livello:

```kotlin
// Summarization
val summarizer = Summarization.getClient(
    SummarizationOptions.builder()
        .setOutputType(OutputType.BULLET_POINTS)
        .build()
)

val summary = summarizer.summarize(longText)
    .addOnSuccessListener { result ->
        textView.text = result.summary
    }

// Rewriting
val rewriter = Rewriting.getClient(
    RewritingOptions.builder()
        .setTone(Tone.FORMAL)
        .setLength(Length.SHORTER)
        .build()
)

val rewritten = rewriter.rewrite(originalText)

// Proofreading
val proofreader = Proofreading.getClient()
val corrected = proofreader.proofread(textWithErrors)
```

---

## Gestione del Contesto e della Memoria

### iOS: LanguageModelSession Internals

La `LanguageModelSession` gestisce automaticamente il contesto:

```swift
// Proprietà chiave della sessione
let session = LanguageModelSession()

// Transcript: storico completo della conversazione
let history = session.transcript.entries
for entry in history {
    switch entry {
    case .prompt(let text):
        print("User: \(text)")
    case .response(let text):
        print("Assistant: \(text)")
    }
}

// Context window: 4096 token massimi
// Include: istruzioni + prompt + risposte

// Controllo stato
if session.isResponding {
    // Non inviare nuove richieste
}
```

### Strategie di Context Management

```
┌─────────────────────────────────────────────────────────────────┐
│                     CONTEXT WINDOW (4096 tokens)                 │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ System Instructions (fissi, ~200-500 token)               │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ Conversation History (sliding window)                     │  │
│  │ - Ultimi N messaggi                                       │  │
│  │ - O ultimi X token                                        │  │
│  │ - O summary + recenti                                     │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ Current Prompt + Expected Response                        │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Pattern: Sliding Window + Summarization

```swift
class ContextManager {
    private let maxTokens = 4096
    private let reservedForResponse = 1000
    private let systemInstructionTokens = 300

    var availableContextTokens: Int {
        maxTokens - reservedForResponse - systemInstructionTokens
    }

    func prepareContext(
        history: [ChatMessage],
        newMessage: String
    ) -> (messages: [ChatMessage], needsSummary: Bool) {
        var tokenCount = estimateTokens(newMessage)
        var includedMessages: [ChatMessage] = []

        // Includi messaggi dal più recente
        for message in history.reversed() {
            let messageTokens = estimateTokens(message.content)

            if tokenCount + messageTokens <= availableContextTokens {
                includedMessages.insert(message, at: 0)
                tokenCount += messageTokens
            } else {
                // Contesto pieno, serve summary
                return (includedMessages, true)
            }
        }

        return (includedMessages, false)
    }

    private func estimateTokens(_ text: String) -> Int {
        // Stima approssimativa: ~4 caratteri per token
        return text.count / 4
    }
}
```

### Gestione Overflow Context (iOS)

```swift
func sendMessageWithContextManagement(_ text: String) async {
    do {
        try await session.respond(to: text)
    } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
        // Strategia 1: Nuova sessione
        session = LanguageModelSession()

        // Strategia 2: Riprova con summary
        let summary = await summarizeHistory()
        session = LanguageModelSession {
            "Contesto precedente: \(summary)"
        }
        try await session.respond(to: text)
    }
}
```

---

## Persistenza dei Dati

### iOS: SwiftData per Conversation History

```swift
import SwiftData

// Modello per messaggi chat
@Model
class ChatMessageModel {
    var id: UUID
    var role: String  // "user" o "assistant"
    var content: String
    var timestamp: Date
    var conversationId: UUID

    init(role: String, content: String, conversationId: UUID) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
        self.conversationId = conversationId
    }
}

// Modello per conversazioni
@Model
class ConversationModel {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade)
    var messages: [ChatMessageModel]

    init(title: String = "Nuova conversazione") {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
        self.messages = []
    }
}

// Repository
@Observable
class ChatRepository {
    private let modelContext: ModelContext
    private var currentConversation: ConversationModel?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createConversation() -> ConversationModel {
        let conversation = ConversationModel()
        modelContext.insert(conversation)
        currentConversation = conversation
        return conversation
    }

    func addMessage(role: String, content: String) {
        guard let conversation = currentConversation else { return }

        let message = ChatMessageModel(
            role: role,
            content: content,
            conversationId: conversation.id
        )
        conversation.messages.append(message)
        conversation.updatedAt = Date()

        try? modelContext.save()
    }

    func getRecentMessages(limit: Int = 20) -> [ChatMessageModel] {
        guard let conversation = currentConversation else { return [] }

        return conversation.messages
            .sorted { $0.timestamp > $1.timestamp }
            .prefix(limit)
            .reversed()
            .map { $0 }
    }
}
```

### Android: Room Database

```kotlin
// Entity
@Entity(tableName = "chat_messages")
data class ChatMessageEntity(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val conversationId: String,
    val role: String,
    val content: String,
    val timestamp: Long = System.currentTimeMillis()
)

@Entity(tableName = "conversations")
data class ConversationEntity(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val title: String,
    val createdAt: Long = System.currentTimeMillis(),
    val updatedAt: Long = System.currentTimeMillis()
)

// DAO
@Dao
interface ChatDao {
    @Query("SELECT * FROM chat_messages WHERE conversationId = :conversationId ORDER BY timestamp ASC")
    fun getMessagesForConversation(conversationId: String): Flow<List<ChatMessageEntity>>

    @Query("SELECT * FROM chat_messages WHERE conversationId = :conversationId ORDER BY timestamp DESC LIMIT :limit")
    suspend fun getRecentMessages(conversationId: String, limit: Int): List<ChatMessageEntity>

    @Insert
    suspend fun insertMessage(message: ChatMessageEntity)

    @Query("SELECT * FROM conversations ORDER BY updatedAt DESC")
    fun getAllConversations(): Flow<List<ConversationEntity>>

    @Insert
    suspend fun insertConversation(conversation: ConversationEntity)

    @Query("UPDATE conversations SET updatedAt = :timestamp WHERE id = :id")
    suspend fun updateConversationTimestamp(id: String, timestamp: Long)
}

// Database
@Database(
    entities = [ChatMessageEntity::class, ConversationEntity::class],
    version = 1
)
abstract class ChatDatabase : RoomDatabase() {
    abstract fun chatDao(): ChatDao
}
```

### Pattern: RAG Locale con SQLite-vec

Per applicazioni avanzate con retrieval:

```swift
// iOS: Usando SQLite.swift + vector extension
import SQLite

class LocalRAGStore {
    private let db: Connection

    func storeEmbedding(text: String, embedding: [Float]) throws {
        // Salva testo e embedding per retrieval
        let documents = Table("documents")
        let id = Expression<Int64>("id")
        let content = Expression<String>("content")
        let vector = Expression<Blob>("embedding")

        try db.run(documents.insert(
            content <- text,
            vector <- Data(bytes: embedding, count: embedding.count * 4)
        ))
    }

    func similaritySearch(queryEmbedding: [Float], limit: Int = 5) throws -> [String] {
        // Ricerca per similarità coseno
        // Implementazione con sqlite-vec extension
    }
}
```

---

## Data Flow e State Management

### iOS: Unidirectional Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         SwiftUI View                             │
│                                                                  │
│  ┌──────────────┐                      ┌──────────────────────┐ │
│  │  User Input  │ ─────────────────▶   │   Action/Intent      │ │
│  └──────────────┘                      └──────────┬───────────┘ │
│                                                    │             │
│                                                    ▼             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                     ViewModel (@Observable)               │   │
│  │                                                          │   │
│  │  ┌────────────────┐     ┌─────────────────────────────┐ │   │
│  │  │   UI State     │ ◀── │   Business Logic            │ │   │
│  │  │  - messages    │     │   - sendMessage()           │ │   │
│  │  │  - isLoading   │     │   - handleStreaming()       │ │   │
│  │  │  - error       │     └─────────────┬───────────────┘ │   │
│  │  └───────┬────────┘                   │                 │   │
│  └──────────│────────────────────────────│─────────────────┘   │
│             │                            │                      │
│             │                            ▼                      │
│             │            ┌───────────────────────────────────┐  │
│             │            │        Data Layer                 │  │
│             │            │  ┌─────────┐  ┌────────────────┐ │  │
│             │            │  │ Session │  │   SwiftData    │ │  │
│             │            │  │  (AI)   │  │  (Persistence) │ │  │
│             │            │  └─────────┘  └────────────────┘ │  │
│             │            └───────────────────────────────────┘  │
│             ▼                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    View Re-render                        │   │
│  │         (automatico grazie a @Observable)                │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Android: StateFlow + Compose

```kotlin
// Sealed class per stati UI
sealed class ChatUiState {
    object Idle : ChatUiState()
    object Loading : ChatUiState()
    data class Streaming(val partialResponse: String) : ChatUiState()
    data class Success(val messages: List<ChatMessage>) : ChatUiState()
    data class Error(val message: String) : ChatUiState()
}

// ViewModel con state machine
@HiltViewModel
class ChatViewModel @Inject constructor(
    private val chatRepository: ChatRepository,
    private val aiRepository: AIRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<ChatUiState>(ChatUiState.Idle)
    val uiState: StateFlow<ChatUiState> = _uiState.asStateFlow()

    // Combine multiple data sources
    val screenState = combine(
        _uiState,
        chatRepository.getMessages()
    ) { uiState, messages ->
        ScreenState(uiState, messages)
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = ScreenState(ChatUiState.Idle, emptyList())
    )

    fun onEvent(event: ChatEvent) {
        when (event) {
            is ChatEvent.SendMessage -> sendMessage(event.text)
            is ChatEvent.RetryLastMessage -> retryLast()
            is ChatEvent.ClearHistory -> clearHistory()
        }
    }

    private fun sendMessage(text: String) {
        viewModelScope.launch {
            _uiState.value = ChatUiState.Loading

            try {
                aiRepository.generateResponse(text)
                    .collect { partial ->
                        _uiState.value = ChatUiState.Streaming(partial)
                    }

                _uiState.value = ChatUiState.Idle
            } catch (e: Exception) {
                _uiState.value = ChatUiState.Error(e.message ?: "Errore sconosciuto")
            }
        }
    }
}

// Eventi utente
sealed class ChatEvent {
    data class SendMessage(val text: String) : ChatEvent()
    object RetryLastMessage : ChatEvent()
    object ClearHistory : ChatEvent()
}
```

---

## Tool Calling e Integrazione API di Sistema

### iOS: Tool Protocol

```swift
import FoundationModels
import MapKit
import EventKit

// Tool per cercare luoghi
struct FindPlacesTool: Tool {
    let name = "findPlaces"
    let description = "Cerca luoghi nelle vicinanze basandosi su una query."

    @Generable
    struct Arguments {
        @Guide(description: "Tipo di luogo da cercare (es. ristorante, museo)")
        let query: String

        @Guide(description: "Raggio di ricerca in metri", .range(100...10000))
        let radiusMeters: Int
    }

    func call(arguments: Arguments) async throws -> ToolOutput {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = arguments.query
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.4642, longitude: 9.1900),
            latitudinalMeters: Double(arguments.radiusMeters),
            longitudinalMeters: Double(arguments.radiusMeters)
        )

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        let places = response.mapItems.prefix(5).map { item in
            "\(item.name ?? "Sconosciuto") - \(item.placemark.title ?? "")"
        }

        return ToolOutput(places.joined(separator: "\n"))
    }
}

// Tool per creare eventi
struct CreateEventTool: Tool {
    let name = "createEvent"
    let description = "Crea un evento nel calendario."

    let eventStore = EKEventStore()

    @Generable
    struct Arguments {
        @Guide(description: "Titolo dell'evento")
        let title: String

        @Guide(description: "Data in formato ISO8601")
        let date: String

        @Guide(description: "Durata in minuti", .range(15...480))
        let durationMinutes: Int
    }

    func call(arguments: Arguments) async throws -> ToolOutput {
        let event = EKEvent(eventStore: eventStore)
        event.title = arguments.title
        event.startDate = ISO8601DateFormatter().date(from: arguments.date) ?? Date()
        event.endDate = event.startDate.addingTimeInterval(
            TimeInterval(arguments.durationMinutes * 60)
        )
        event.calendar = eventStore.defaultCalendarForNewEvents

        try eventStore.save(event, span: .thisEvent)

        return ToolOutput("Evento '\(arguments.title)' creato con successo!")
    }
}

// Sessione con tools
let session = LanguageModelSession(
    tools: [FindPlacesTool(), CreateEventTool()]
) {
    """
    Sei un assistente personale.
    Usa findPlaces per cercare luoghi.
    Usa createEvent per creare eventi nel calendario.
    """
}
```

### Android: FunctionGemma Pattern

```kotlin
// Definizione funzioni come JSON schema
val weatherFunction = FunctionDeclaration(
    name = "get_weather",
    description = "Ottiene il meteo per una località",
    parameters = listOf(
        ParameterDeclaration(
            name = "location",
            description = "Nome della città",
            type = "string",
            required = true
        ),
        ParameterDeclaration(
            name = "unit",
            description = "Unità di temperatura",
            type = "string",
            enum = listOf("celsius", "fahrenheit")
        )
    )
)

// Handler per function calling
class FunctionCallHandler @Inject constructor(
    private val weatherService: WeatherService,
    private val calendarService: CalendarService
) {
    suspend fun handle(functionCall: FunctionCall): String {
        return when (functionCall.name) {
            "get_weather" -> {
                val location = functionCall.args["location"] as String
                val unit = functionCall.args["unit"] as? String ?: "celsius"
                weatherService.getWeather(location, unit)
            }
            "create_event" -> {
                val title = functionCall.args["title"] as String
                val date = functionCall.args["date"] as String
                calendarService.createEvent(title, date)
            }
            else -> "Funzione non supportata"
        }
    }
}

// ViewModel con function calling
@HiltViewModel
class AssistantViewModel @Inject constructor(
    private val aiRepository: AIRepository,
    private val functionHandler: FunctionCallHandler
) : ViewModel() {

    fun sendMessage(text: String) {
        viewModelScope.launch {
            val response = aiRepository.generateWithFunctions(
                prompt = text,
                functions = listOf(weatherFunction, calendarFunction)
            )

            if (response.hasFunctionCall) {
                // Esegui la funzione
                val result = functionHandler.handle(response.functionCall)

                // Continua la conversazione con il risultato
                val finalResponse = aiRepository.continueWithResult(
                    functionResult = result
                )

                updateUI(finalResponse)
            } else {
                updateUI(response.text)
            }
        }
    }
}
```

---

## Pattern di Error Handling

### iOS: Gestione Errori Foundation Models

```swift
enum AIError: LocalizedError {
    case modelNotAvailable(reason: SystemLanguageModel.Availability)
    case contextOverflow
    case generationFailed(underlying: Error)
    case networkError
    case toolExecutionFailed(toolName: String, error: Error)

    var errorDescription: String? {
        switch self {
        case .modelNotAvailable(let reason):
            return "Modello non disponibile: \(reason)"
        case .contextOverflow:
            return "Conversazione troppo lunga. Inizia una nuova chat."
        case .generationFailed(let error):
            return "Errore generazione: \(error.localizedDescription)"
        case .networkError:
            return "Errore di rete"
        case .toolExecutionFailed(let name, let error):
            return "Errore esecuzione \(name): \(error.localizedDescription)"
        }
    }
}

@Observable
class ChatViewModel {
    var error: AIError?
    var showingError = false

    func sendMessage(_ text: String) async {
        do {
            // Verifica disponibilità
            guard case .available = SystemLanguageModel.default.availability else {
                throw AIError.modelNotAvailable(
                    reason: SystemLanguageModel.default.availability
                )
            }

            try await session.respond(to: text)

        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            // Gestione specifica overflow
            error = .contextOverflow
            showingError = true

            // Auto-recovery: nuova sessione
            await startNewSession()

        } catch let error as LanguageModelSession.GenerationError {
            self.error = .generationFailed(underlying: error)
            showingError = true

        } catch {
            self.error = .generationFailed(underlying: error)
            showingError = true
        }
    }
}
```

### Android: Result Pattern con Sealed Classes

```kotlin
sealed class AIResult<out T> {
    data class Success<T>(val data: T) : AIResult<T>()
    data class Error(val exception: AIException) : AIResult<Nothing>()
    object Loading : AIResult<Nothing>()
}

sealed class AIException : Exception() {
    object ModelNotAvailable : AIException()
    object ContextOverflow : AIException()
    data class GenerationFailed(val cause: Throwable) : AIException()
    data class ToolExecutionFailed(
        val toolName: String,
        val cause: Throwable
    ) : AIException()
}

// Repository con error handling
class AIRepositoryImpl @Inject constructor(
    private val llmInference: LlmInference
) : AIRepository {

    override suspend fun generateResponse(prompt: String): Flow<AIResult<String>> = flow {
        emit(AIResult.Loading)

        try {
            // Check model availability
            if (!isModelReady()) {
                emit(AIResult.Error(AIException.ModelNotAvailable))
                return@flow
            }

            // Generate with streaming
            callbackFlow<String> {
                llmInference.generateResponseAsync(
                    prompt,
                    object : ResultListener {
                        override fun onResult(result: String, done: Boolean) {
                            trySend(result)
                            if (done) close()
                        }

                        override fun onError(error: Exception) {
                            close(error)
                        }
                    }
                )
                awaitClose { }
            }.collect { partial ->
                emit(AIResult.Success(partial))
            }

        } catch (e: OutOfMemoryError) {
            emit(AIResult.Error(AIException.ContextOverflow))
        } catch (e: Exception) {
            emit(AIResult.Error(AIException.GenerationFailed(e)))
        }
    }
}

// ViewModel con retry logic
@HiltViewModel
class ChatViewModel @Inject constructor(
    private val aiRepository: AIRepository
) : ViewModel() {

    private var retryCount = 0
    private val maxRetries = 3

    fun sendMessage(text: String) {
        viewModelScope.launch {
            aiRepository.generateResponse(text)
                .retryWhen { cause, attempt ->
                    if (cause is AIException.GenerationFailed && attempt < maxRetries) {
                        delay(1000 * (attempt + 1)) // Exponential backoff
                        true
                    } else {
                        false
                    }
                }
                .collect { result ->
                    when (result) {
                        is AIResult.Success -> updateUI(result.data)
                        is AIResult.Error -> handleError(result.exception)
                        is AIResult.Loading -> showLoading()
                    }
                }
        }
    }
}
```

---

## Best Practice e Raccomandazioni

### Performance Optimization

| Pratica | iOS | Android |
|---------|-----|---------|
| **Prewarming** | `session.prewarm()` all'avvio | Inizializza `LlmInference` in background |
| **Streaming** | Sempre per risposte > 100 token | Usa `ResultListener` |
| **Batch operations** | Salva DB dopo risposta completa | Usa `@Transaction` Room |
| **Memory** | Limita history in session | Usa `limit` nelle query |

### Architettura Consigliata

```
Progetto Piccolo (MVP):
├── ViewModel + Session diretta
├── SwiftData/Room per persistence
└── No dependency injection

Progetto Medio:
├── MVVM + Repository pattern
├── Hilt/Koin per DI
├── Use Cases per business logic
└── Separate AI e Data repositories

Progetto Enterprise:
├── Clean Architecture
├── Multi-module (core, feature, data)
├── Abstraction layer per AI (facile swap modelli)
├── Comprehensive testing
└── Feature flags per AI features
```

### Checklist Pre-Release

- [ ] Verifica disponibilità modello su tutti i dispositivi target
- [ ] Implementa fallback UI per dispositivi non supportati
- [ ] Testa con context window pieno
- [ ] Monitora memory usage durante streaming
- [ ] Implementa analytics per errori AI
- [ ] Gestisci gracefully model download in progress
- [ ] Testa offline behavior
- [ ] Verifica privacy compliance (no data leakage)

### Risorse per Approfondire

| Tipo | iOS | Android |
|------|-----|---------|
| **Docs ufficiali** | [Foundation Models](https://developer.apple.com/documentation/FoundationModels) | [ML Kit GenAI](https://developers.google.com/ml-kit/genai) |
| **Video** | [WWDC25 Sessions](https://developer.apple.com/videos/wwdc2025/) | [Android Dev Summit](https://developer.android.com/events) |
| **Sample apps** | [FoundationChat](https://github.com/Dimillian/FoundationChat) | [MediaPipe Samples](https://github.com/google-ai-edge/mediapipe-samples) |
| **Cookbook** | [Create with Swift](https://www.createwithswift.com/) | [Gemini Cookbook](https://github.com/google-gemini/cookbook) |
| **Community** | [Apple Dev Forums](https://developer.apple.com/forums/) | [Android Dev Discord](https://discord.gg/android) |

---

*Ultimo aggiornamento: Gennaio 2026*

*Fonti principali: [Apple Developer Documentation](https://developer.apple.com/documentation/FoundationModels), [Android Developers](https://developer.android.com/ai), [Medium](https://medium.com/), [Create with Swift](https://www.createwithswift.com/)*
