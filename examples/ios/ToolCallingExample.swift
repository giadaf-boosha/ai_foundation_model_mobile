// ToolCallingExample.swift
// Esempio completo di Tool Calling con Apple Foundation Models
// Dimostra come creare tool custom per estendere le capacità del modello

import SwiftUI
import FoundationModels
import CoreLocation
import WeatherKit

// MARK: - Tool Definitions

/// Tool per ottenere il meteo
struct WeatherTool: Tool {
    let name = "getWeather"
    let description = """
        Ottiene le condizioni meteo attuali per una città specificata.
        Usa questo tool quando l'utente chiede del tempo o meteo.
        """

    @Generable
    struct Parameters: Codable {
        /// Nome della città
        let city: String
        /// Unità di misura
        let units: TemperatureUnits

        @Generable
        enum TemperatureUnits: String, Codable {
            case celsius
            case fahrenheit
        }
    }

    func call(with parameters: Parameters) async throws -> String {
        // Simulazione - in produzione usa WeatherKit
        let temps: [String: Int] = [
            "roma": 18, "milano": 12, "napoli": 20, "torino": 10, "firenze": 15
        ]

        let cityLower = parameters.city.lowercased()
        guard let temp = temps[cityLower] else {
            return "Non ho dati meteo per \(parameters.city). Prova con una città italiana."
        }

        let displayTemp = parameters.units == .fahrenheit
            ? "\(temp * 9/5 + 32)°F"
            : "\(temp)°C"

        return """
            Meteo attuale a \(parameters.city.capitalized):
            - Temperatura: \(displayTemp)
            - Condizioni: Parzialmente nuvoloso
            - Umidità: 65%
            """
    }
}

/// Tool per calcoli matematici
struct CalculatorTool: Tool {
    let name = "calculate"
    let description = """
        Esegue calcoli matematici. Usa questo tool quando l'utente
        chiede di calcolare qualcosa o fare operazioni matematiche.
        """

    @Generable
    struct Parameters: Codable {
        let operation: Operation
        let a: Double
        let b: Double

        @Generable
        enum Operation: String, Codable {
            case add
            case subtract
            case multiply
            case divide
            case power
        }
    }

    func call(with parameters: Parameters) async throws -> String {
        let result: Double

        switch parameters.operation {
        case .add:
            result = parameters.a + parameters.b
        case .subtract:
            result = parameters.a - parameters.b
        case .multiply:
            result = parameters.a * parameters.b
        case .divide:
            guard parameters.b != 0 else {
                return "Errore: divisione per zero non permessa"
            }
            result = parameters.a / parameters.b
        case .power:
            result = pow(parameters.a, parameters.b)
        }

        return "Risultato: \(String(format: "%.2f", result))"
    }
}

/// Tool per creare reminder/promemoria
struct ReminderTool: Tool {
    let name = "createReminder"
    let description = """
        Crea un promemoria. Usa questo tool quando l'utente vuole
        ricordare qualcosa o impostare un reminder.
        """

    @Generable
    struct Parameters: Codable {
        let title: String
        let notes: String?
        let priority: Priority

        @Generable
        enum Priority: String, Codable {
            case low
            case medium
            case high
        }
    }

    func call(with parameters: Parameters) async throws -> String {
        // In produzione usa EventKit
        let priorityEmoji = switch parameters.priority {
            case .low: "🟢"
            case .medium: "🟡"
            case .high: "🔴"
        }

        var response = """
            \(priorityEmoji) Promemoria creato:
            Titolo: \(parameters.title)
            Priorità: \(parameters.priority.rawValue)
            """

        if let notes = parameters.notes {
            response += "\nNote: \(notes)"
        }

        return response
    }
}

// MARK: - ViewModel

@MainActor
@Observable
class ToolCallingViewModel {

    struct Message: Identifiable {
        let id = UUID()
        let role: Role
        let content: String
        let toolCalls: [ToolCallInfo]?

        enum Role { case user, assistant, tool }
    }

    struct ToolCallInfo: Identifiable {
        let id = UUID()
        let toolName: String
        let parameters: String
        let result: String
    }

    private(set) var messages: [Message] = []
    private(set) var isProcessing = false

    private var session: LanguageModelSession?

    // Registra tutti i tool
    let availableTools: [any Tool] = [
        WeatherTool(),
        CalculatorTool(),
        ReminderTool()
    ]

    func initialize() async {
        guard LanguageModelSession.isAvailable else { return }

        let config = LanguageModelSession.Configuration(
            instructions: """
                Sei un assistente AI con accesso a diversi strumenti.
                Puoi:
                - Ottenere informazioni meteo con getWeather
                - Fare calcoli matematici con calculate
                - Creare promemoria con createReminder

                Usa gli strumenti quando appropriato. Rispondi in italiano.
                Dopo aver usato uno strumento, riassumi il risultato in modo naturale.
                """
        )

        // Crea sessione con tools
        session = LanguageModelSession(
            configuration: config,
            tools: availableTools
        )
    }

    func send(_ text: String) async {
        guard let session = session else { return }

        messages.append(Message(role: .user, content: text, toolCalls: nil))
        isProcessing = true

        do {
            // Il framework gestisce automaticamente le chiamate ai tool
            let response = try await session.respond(to: text)

            // Estrai info sulle chiamate tool (se disponibili)
            var toolCallInfos: [ToolCallInfo] = []

            // In base alla risposta, potremmo avere info sui tool usati
            // Questa è una semplificazione - il framework reale fornisce metadata

            messages.append(Message(
                role: .assistant,
                content: response.content,
                toolCalls: toolCallInfos.isEmpty ? nil : toolCallInfos
            ))

        } catch {
            messages.append(Message(
                role: .assistant,
                content: "Errore: \(error.localizedDescription)",
                toolCalls: nil
            ))
        }

        isProcessing = false
    }
}

// MARK: - View

struct ToolCallingView: View {

    @State private var viewModel = ToolCallingViewModel()
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tool disponibili
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.availableTools.map { $0.name }, id: \.self) { name in
                            Label(name, systemImage: iconFor(tool: name))
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                Divider()

                // Messaggi
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            ToolMessageView(message: message)
                        }
                    }
                    .padding()
                }

                // Loading
                if viewModel.isProcessing {
                    HStack {
                        ProgressView()
                        Text("Elaborazione...")
                    }
                    .padding()
                }

                // Input
                HStack {
                    TextField("Es: Che tempo fa a Roma?", text: $inputText)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        let text = inputText
                        inputText = ""
                        Task { await viewModel.send(text) }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(inputText.isEmpty || viewModel.isProcessing)
                }
                .padding()
            }
            .navigationTitle("Tool Calling")
        }
        .task {
            await viewModel.initialize()
        }
    }

    func iconFor(tool: String) -> String {
        switch tool {
        case "getWeather": return "cloud.sun"
        case "calculate": return "function"
        case "createReminder": return "bell"
        default: return "wrench"
        }
    }
}

struct ToolMessageView: View {
    let message: ToolCallingViewModel.Message

    var body: some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 8) {
            // Badge ruolo
            HStack {
                if message.role == .user { Spacer() }
                Text(message.role == .user ? "Tu" : "Assistente")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if message.role == .assistant { Spacer() }
            }

            // Contenuto
            HStack {
                if message.role == .user { Spacer() }

                Text(message.content)
                    .padding()
                    .background(
                        message.role == .user
                            ? Color.blue
                            : Color(.systemGray5)
                    )
                    .foregroundStyle(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if message.role == .assistant { Spacer() }
            }

            // Info tool calls
            if let toolCalls = message.toolCalls, !toolCalls.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(toolCalls) { call in
                        HStack {
                            Image(systemName: "wrench.and.screwdriver")
                            Text("\(call.toolName)")
                                .fontWeight(.medium)
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ToolCallingView()
}
