import Foundation
import FoundationModels

@main
struct BasicChat {
    static func main() async {
        let prompt = CommandLine.arguments.dropFirst().joined(separator: " ")
        let userPrompt = prompt.isEmpty
            ? "Spiegami in 3 frasi cos'e un foundation model on-device."
            : prompt

        print("• Modello: SystemLanguageModel.default (Apple Intelligence)")
        print("• Prompt: \(userPrompt)")
        print("")

        let model = SystemLanguageModel.default
        guard model.availability == .available else {
            print("✗ Modello non disponibile: \(model.availability)")
            print("  Verifica che Apple Intelligence sia attivo nelle impostazioni.")
            exit(1)
        }

        let session = LanguageModelSession()

        let start = Date()
        do {
            let response = try await session.respond(to: userPrompt)
            let elapsed = Date().timeIntervalSince(start)
            print("─── RISPOSTA ───")
            print(response.content)
            print("───────────────")
            print(String(format: "• Latenza totale: %.2fs", elapsed))
        } catch {
            print("✗ Errore: \(error)")
            exit(1)
        }
    }
}
