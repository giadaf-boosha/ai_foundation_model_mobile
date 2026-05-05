import Foundation
import FoundationModels

@main
struct StreamingChat {
    static func main() async {
        let prompt = CommandLine.arguments.dropFirst().joined(separator: " ")
        let userPrompt = prompt.isEmpty
            ? "Scrivi una breve poesia in italiano sull'intelligenza on-device."
            : prompt

        print("• Streaming token-by-token attivo")
        print("• Prompt: \(userPrompt)")
        print("")

        let model = SystemLanguageModel.default
        guard model.availability == .available else {
            print("✗ Modello non disponibile: \(model.availability)")
            exit(1)
        }

        let session = LanguageModelSession()
        let start = Date()
        var firstTokenAt: TimeInterval = 0
        var tokenCount = 0

        do {
            let stream = session.streamResponse(to: userPrompt)
            print("─── STREAM ───")
            for try await partial in stream {
                if firstTokenAt == 0 {
                    firstTokenAt = Date().timeIntervalSince(start)
                }
                tokenCount += 1
                // partial.content e una stringa progressiva: stampiamo il delta
                // semplificato: ristampiamo l'intero output corrente
                print("\u{1B}[2J\u{1B}[H─── STREAM (token \(tokenCount)) ───")
                print(partial.content)
            }
            let elapsed = Date().timeIntervalSince(start)
            print("──────────────")
            print(String(format: "• Time-to-first-token: %.2fs", firstTokenAt))
            print(String(format: "• Latenza totale: %.2fs", elapsed))
            print("• Update streaming ricevuti: \(tokenCount)")
        } catch {
            print("✗ Errore: \(error)")
            exit(1)
        }
    }
}
