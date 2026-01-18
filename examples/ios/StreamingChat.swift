// StreamingChat.swift
// Chat con streaming delle risposte
// Mostra i token man mano che vengono generati

import SwiftUI
import FoundationModels

@MainActor
@Observable
class StreamingChatViewModel {

    private(set) var messages: [StreamingMessage] = []
    private(set) var isGenerating = false
    private(set) var currentPartialResponse = ""

    private var session: LanguageModelSession?

    // Inizializzazione
    func initialize() async {
        guard LanguageModelSession.isAvailable else { return }

        let config = LanguageModelSession.Configuration(
            instructions: "Sei un assistente. Rispondi in italiano."
        )
        session = LanguageModelSession(configuration: config)
    }

    // Invio con streaming
    func sendWithStreaming(_ text: String) async {
        guard let session = session else { return }

        // Messaggio utente
        messages.append(StreamingMessage(role: .user, content: text))

        // Prepara risposta assistente (vuota inizialmente)
        let assistantIndex = messages.count
        messages.append(StreamingMessage(role: .assistant, content: ""))

        isGenerating = true
        currentPartialResponse = ""

        do {
            // Usa respond con streaming
            let stream = session.streamResponse(to: text)

            for try await partialResponse in stream {
                // Aggiorna il messaggio in tempo reale
                currentPartialResponse = partialResponse.content
                messages[assistantIndex].content = currentPartialResponse
            }

        } catch {
            messages[assistantIndex].content = "Errore: \(error.localizedDescription)"
        }

        isGenerating = false
    }

    // Cancella generazione in corso
    func cancelGeneration() {
        // La sessione gestisce automaticamente la cancellazione
        // quando il Task viene cancellato
        isGenerating = false
    }
}

struct StreamingMessage: Identifiable {
    let id = UUID()
    let role: Role
    var content: String // var per permettere aggiornamenti streaming

    enum Role {
        case user, assistant
    }
}

struct StreamingChatView: View {

    @State private var viewModel = StreamingChatViewModel()
    @State private var inputText = ""
    @State private var generationTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messaggi
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                StreamingBubble(
                                    message: message,
                                    isGenerating: viewModel.isGenerating &&
                                        message.id == viewModel.messages.last?.id &&
                                        message.role == .assistant
                                )
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.currentPartialResponse) { _, _ in
                        // Scroll durante streaming
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }

                // Indicatore
                if viewModel.isGenerating {
                    HStack {
                        ProgressView()
                        Text("Generando...")
                        Spacer()
                        Button("Stop") {
                            generationTask?.cancel()
                            viewModel.cancelGeneration()
                        }
                        .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                }

                // Input
                HStack(spacing: 12) {
                    TextField("Messaggio...", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isGenerating)

                    Button {
                        let text = inputText
                        inputText = ""
                        generationTask = Task {
                            await viewModel.sendWithStreaming(text)
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(inputText.isEmpty || viewModel.isGenerating)
                }
                .padding()
            }
            .navigationTitle("Streaming Chat")
        }
        .task {
            await viewModel.initialize()
        }
    }
}

struct StreamingBubble: View {
    let message: StreamingMessage
    let isGenerating: Bool

    var body: some View {
        HStack {
            if message.role == .user { Spacer() }

            HStack(alignment: .bottom, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(
                        message.role == .user ? Color.blue : Color(.systemGray5)
                    )
                    .foregroundStyle(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                // Cursore lampeggiante durante streaming
                if isGenerating {
                    Rectangle()
                        .fill(.primary)
                        .frame(width: 2, height: 16)
                        .opacity(0.7)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(),
                            value: isGenerating
                        )
                }
            }
            .frame(maxWidth: 280, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .assistant { Spacer() }
        }
    }
}

#Preview {
    StreamingChatView()
}
