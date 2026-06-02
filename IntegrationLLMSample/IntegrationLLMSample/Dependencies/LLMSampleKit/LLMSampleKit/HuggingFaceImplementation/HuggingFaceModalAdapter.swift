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
//import SwiftSyntax
//import SwiftCompilerPlugin
//import SwiftSyntaxBuilder
//import SwiftSyntaxMacros

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
            continuation.finish()
        }
    }
}
