//
//  ModelsPreferencesViewModel.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI
import Combine

@MainActor
final class ModelsPreferencesViewModel: ObservableObject {

    @Published var models: [ModelItem] = [
        ModelItem(name: "Llama 3.2 3B", downloadURL: "https://example.com/llama3.2-3b.gguf", state: .load),
        ModelItem(name: "Mistral 7B", downloadURL: "https://example.com/mistral-7b.gguf", state: .select),
        ModelItem(name: "Phi-3 Mini", downloadURL: "https://example.com/phi3-mini.gguf", state: .selected),
    ]

    @Published var isAddModelPresented: Bool = false

    // Active download tasks keyed by model id
    private var downloadTasks: [UUID: Task<Void, Never>] = [:]

    // MARK: - Actions

    func handleStateAction(for model: ModelItem) {
        guard let index = models.firstIndex(where: { $0.id == model.id }) else { return }

        switch models[index].state {
        case .load:
            startLoading(at: index)

        case .select:
            selectModel(at: index)

        case .loading, .selected:
            break // non-interactive states
        }
    }

    func remove(_ model: ModelItem) {
        downloadTasks[model.id]?.cancel()
        downloadTasks[model.id] = nil
        models.removeAll { $0.id == model.id }
    }

    func addModel(name: String, downloadURL: String) {
        let item = ModelItem(name: name, downloadURL: downloadURL, state: .load)
        models.append(item)
    }

    // MARK: - Private

    private func startLoading(at index: Int) {
        let id = models[index].id
        models[index].state = .loading(progress: 0)

        // Simulate download progress — replace with URLSession download task
        let task = Task {
            var progress = 0.0
            while progress < 1.0 {
                try? await Task.sleep(for: .milliseconds(80))
                guard !Task.isCancelled else { return }
                progress = min(progress + Double.random(in: 0.02...0.08), 1.0)
                if let i = models.firstIndex(where: { $0.id == id }) {
                    models[i].state = .loading(progress: progress)
                }
            }
            if let i = models.firstIndex(where: { $0.id == id }) {
                models[i].state = .select
            }
            downloadTasks[id] = nil
        }
        downloadTasks[id] = task
    }

    private func selectModel(at index: Int) {
        let id = models[index].id
        // Deselect any currently selected model
        for i in models.indices where models[i].state == .selected {
            models[i].state = .select
        }
        if let i = models.firstIndex(where: { $0.id == id }) {
            models[i].state = .selected
        }
    }
}
