import Foundation
import FoundationModels

// MARK: - Weather Tool

struct WeatherTool: Tool {
    let name = "getWeather"
    let description = "Restituisce il meteo attuale per una citta italiana."

    @Generable
    struct Arguments {
        @Guide(description: "Nome della citta, es. Bologna, Milano, Roma")
        let city: String
    }

    func call(arguments: Arguments) async throws -> String {
        // Mock deterministico — niente rete in aula
        let mockData: [String: (Int, String)] = [
            "bologna": (18, "soleggiato"),
            "milano":  (16, "nuvoloso"),
            "roma":    (22, "sereno"),
            "napoli":  (24, "sereno"),
            "torino":  (15, "pioggia leggera")
        ]
        let key = arguments.city.lowercased()
        let (temp, sky) = mockData[key] ?? (20, "sereno")
        return "{\"city\":\"\(arguments.city)\",\"temperature_celsius\":\(temp),\"sky\":\"\(sky)\"}"
    }
}

// MARK: - Calculator Tool

struct CalculatorTool: Tool {
    let name = "calculate"
    let description = "Esegue un'espressione aritmetica semplice (somma, sottrazione, moltiplicazione, divisione)."

    @Generable
    struct Arguments {
        @Guide(description: "Espressione aritmetica, es. '12 * 7' o '100 / 4'")
        let expression: String
    }

    func call(arguments: Arguments) async throws -> String {
        let expr = NSExpression(format: arguments.expression)
        let result = expr.expressionValue(with: nil, context: nil)
        return "\(result ?? "errore")"
    }
}

// MARK: - Main

@main
struct ToolCallingDemo {
    static func main() async {
        let prompt = CommandLine.arguments.dropFirst().joined(separator: " ")
        let userPrompt = prompt.isEmpty
            ? "Che tempo fa a Bologna oggi? E quanto fa 144 diviso 12?"
            : prompt

        print("• Tools registrati: getWeather, calculate")
        print("• Prompt: \(userPrompt)")
        print("")

        let model = SystemLanguageModel.default
        guard model.availability == .available else {
            print("✗ Modello non disponibile: \(model.availability)")
            exit(1)
        }

        let tools: [any Tool] = [WeatherTool(), CalculatorTool()]
        let session = LanguageModelSession(tools: tools)

        let start = Date()
        do {
            let response = try await session.respond(to: userPrompt)
            let elapsed = Date().timeIntervalSince(start)
            print("─── RISPOSTA ───")
            print(response.content)
            print("───────────────")
            print(String(format: "• Latenza totale: %.2fs", elapsed))
            print("• Il modello ha invocato i tool autonomamente — nessuna logica di routing scritta da noi.")
        } catch {
            print("✗ Errore: \(error)")
            exit(1)
        }
    }
}
