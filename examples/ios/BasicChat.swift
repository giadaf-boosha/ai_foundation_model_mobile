// BasicChat.swift
// Esempio base di chat con Apple Foundation Models
// Requisiti: iOS 26+, Xcode 17+

import SwiftUI
import FoundationModels

// MARK: - ViewModel

@MainActor
@Observable
class ChatViewModel {

    // Stato
    private(set) var messages: [ChatMessage] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // Session per mantenere il contesto
    private var session: LanguageModelSession?

    // Inizializza la sessione
    func initialize() async {
        do {
            // Verifica disponibilità del modello
            guard LanguageModelSession.isAvailable else {
                errorMessage = "Apple Intelligence non disponibile su questo dispositivo"
                return
            }

            // Crea sessione con configurazione
            let config = LanguageModelSession.Configuration(
                instructions: """
                    Sei un assistente amichevole e utile.
                    Rispondi sempre in italiano.
                    Sii conciso ma completo.
                    """
            )
            session = LanguageModelSession(configuration: config)

        } catch {
            errorMessage = "Errore inizializzazione: \(error.localizedDescription)"
        }
    }

    // Invia messaggio
    func send(_ text: String) async {
        guard let session = session else {
            errorMessage = "Sessione non inizializzata"
            return
        }

        // Aggiungi messaggio utente
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        isLoading = true
        errorMessage = nil

        do {
            // Genera risposta
            let response = try await session.respond(to: text)

            // Aggiungi risposta assistente
            let assistantMessage = ChatMessage(
                role: .assistant,
                content: response.content
            )
            messages.append(assistantMessage)

        } catch {
            errorMessage = "Errore: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Pulisci conversazione
    func clearConversation() {
        messages.removeAll()
        // Ricrea sessione per nuovo contesto
        Task { await initialize() }
    }
}

// MARK: - Modelli

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp = Date()

    enum Role {
        case user
        case assistant
    }
}

// MARK: - View

struct ChatView: View {

    @State private var viewModel = ChatViewModel()
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Lista messaggi
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Indicatore caricamento
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                        Text("Sto pensando...")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }

                // Errore
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                // Input
                InputBar(
                    text: $inputText,
                    isLoading: viewModel.isLoading,
                    onSend: {
                        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !text.isEmpty else { return }
                        inputText = ""
                        Task { await viewModel.send(text) }
                    }
                )
            }
            .navigationTitle("Chat AI")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Pulisci") {
                        viewModel.clearConversation()
                    }
                }
            }
        }
        .task {
            await viewModel.initialize()
        }
    }
}

// MARK: - Componenti UI

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer() }

            VStack(alignment: message.role == .user ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(
                        message.role == .user
                            ? Color.blue
                            : Color(.systemGray5)
                    )
                    .foregroundStyle(
                        message.role == .user ? .white : .primary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 280, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .assistant { Spacer() }
        }
    }
}

struct InputBar: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("Scrivi un messaggio...", text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...5)
                .disabled(isLoading)

            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
        }
        .padding()
        .background(.bar)
    }
}

// MARK: - Preview

#Preview {
    ChatView()
}
