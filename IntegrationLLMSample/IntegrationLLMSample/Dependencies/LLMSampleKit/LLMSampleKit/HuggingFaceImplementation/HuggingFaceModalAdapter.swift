//
//  HuggingFaceModalAdapter.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation
internal import MLXLLM
internal import MLXLMCommon
internal import MLXHuggingFace
internal import Tokenizers
internal import HuggingFace
internal import Hub

class HuggingFaceModalAdapter: ModelAdaptable {
    private let modelConfiguration: ModelConfiguration
    private var modelContainer: ModelContainer?

    var isReady: Bool { modelContainer != nil }

    init(modelConfiguration: ModelConfiguration) {
        self.modelConfiguration = modelConfiguration
    }

    func prepareModel(progressHandler: @Sendable @escaping (Progress) -> Void) async throws {
        do {
            modelContainer = try await #huggingFaceLoadModelContainer(
                configuration: modelConfiguration,
                progressHandler: progressHandler
            )

        } catch {
            throw error
        }
    }

    func generate(prompt: String) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                guard let modelContainer = self.modelContainer else {
                    continuation.finish()
                    return
                }

                do {
                    let userInput = UserInput(prompt: prompt)
                    let lmInput = try await modelContainer.prepare(input: userInput)

                    let parameters = GenerateParameters(
                        maxTokens: 512,
                        temperature: 0.7
                    )

                    let stream = try await modelContainer.generate(input: lmInput, parameters: parameters)


                    for await token in stream {
                        switch token {
                            case .chunk(let text):
                            continuation.yield(text)
                            case .info(let info):
                            continuation.yield("\nTokens/sec: \(info.tokensPerSecond)")
                            case .toolCall(let toolCall):
                            continuation.yield("Tool call: \(toolCall)")
                            }

                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
