//
//  ContentViewModel.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.
//

import SwiftUI
import Combine

// MARK: - ContentViewModel

@MainActor
final class ContentViewModel: ObservableObject {

    // MARK: Published state

    @Published var requestResponceModel: [RequestResponceModel] = []
    @Published var inputText: String = ""

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
            // Replace this with your real async call
            try? await Task.sleep(for: .milliseconds(800))
            model.responce = .ready(result: "Echo: \(model.request)")
        }
    }
}
