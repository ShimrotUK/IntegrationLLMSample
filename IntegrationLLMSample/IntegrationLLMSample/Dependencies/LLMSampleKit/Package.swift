// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LLMSampleKit",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "LLMSampleKit",
            targets: ["LLMSampleKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/ml-explore/mlx-swift-lm",
            from: "3.31.3"
        ),
        .package(
            url: "https://github.com/huggingface/swift-huggingface",
            from: "0.9.0"
        ),
        .package(
            url: "https://github.com/huggingface/swift-transformers",
            from: "1.3.3"
        )
    ],
    targets: [
        .target(
            name: "LLMSampleKit",
            dependencies: [
                .product(name: "MLXEmbedders", package: "mlx-swift-lm"),
                .product(name: "MLXHuggingFace", package: "mlx-swift-lm"),
                .product(name: "MLXLLM", package: "mlx-swift-lm"),
                .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
                .product(name: "HuggingFace", package: "swift-huggingface"),
                .product(name: "Hub", package: "swift-transformers"),
                .product(name: "Tokenizers", package: "swift-transformers"),
                .product(name: "Transformers", package: "swift-transformers")
            ],
            path: "LLMSampleKit",
            swiftSettings: [
                .enableUpcomingFeature("MemberImportVisibility")
            ]
        ),
        .testTarget(
            name: "LLMSampleKitTests",
            dependencies: ["LLMSampleKit"],
            path: "LLMSampleKitTests"
        )
    ],
    swiftLanguageModes: [.v5]
)
