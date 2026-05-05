// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppleFMDemo",
    platforms: [
        .macOS("26.0")
    ],
    products: [
        .executable(name: "BasicChat", targets: ["BasicChat"]),
        .executable(name: "StreamingChat", targets: ["StreamingChat"]),
        .executable(name: "ToolCalling", targets: ["ToolCalling"])
    ],
    targets: [
        .executableTarget(name: "BasicChat", path: "Sources/BasicChat"),
        .executableTarget(name: "StreamingChat", path: "Sources/StreamingChat"),
        .executableTarget(name: "ToolCalling", path: "Sources/ToolCalling")
    ]
)
