//
//  ContentViewModel.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.
//

import SwiftUI
import Combine
import LLMSampleKit

// MARK: - ContentViewModel

@MainActor
final class ContentViewModel: ObservableObject {

    // MARK: Published state

    @Published var requestResponceModel: [RequestResponceModel] = []
    @Published var inputText: String = ""
    @Published var selectedModelName: String?
    private var provider = ModelProvidersManager.shared.provider(for: .huggingFace)

    // MARK: Computed

    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: Actions

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = RequestResponceModel(request: trimmed)
        requestResponceModel.append(userMessage)
        simulateReply(to: userMessage)
        inputText = ""
    }

    // MARK: Private

    private func simulateReply(to model: RequestResponceModel) {
        Task {
            guard let modelInfo = ModelSelectionManager.shared.selectedModelInfo else {
                return
            }

            guard let modelLLM = try? await self.provider.model(for: modelInfo) else { return }

            do {
                for try await value in modelLLM.generate(prompt: model.request, autoprepare: true) {
                    switch model.responce {
                    case .initial, .error:
                        model.responce = .pending(result: value)
                    case .pending(let result):
                        model.responce = .pending(result: result ?? "" + value)
                    case .ready:
                        model.responce = .pending(result: value)
                    }
                }

                switch model.responce {
                case .initial, .error, .ready:
                    model.responce = .error
                case .pending(let result):
                    if let result {
                        model.responce = .ready(result: result)
                    }
                    else {
                        model.responce = .error
                    }
                }

            } catch {
                model.responce = .error
            }
        }
    }
}
