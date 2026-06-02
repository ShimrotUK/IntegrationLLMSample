//
//  ModelsPreferencesViewModel.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI
import Combine
import LLMSampleKit

@MainActor
final class ModelsPreferencesViewModel: ObservableObject {

    @Published var models = [ModelItem]()
    @Published var selectedModel: ModelItem?

    @Published var isAddModelPresented: Bool = false

    let addModelAvailable: Bool = false
    private var identifierInfoMap = [UUID: ModelInfo]()
    private var provider: ModelProvider
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.provider = ModelProvidersManager.shared.provider(for: .huggingFace)
        self.provider.$availiableModelInfos.receive(on: DispatchQueue.main).sink { [weak self] modelInfos in
            guard let self else { return }

            var newItems = [ModelItem]()
            var idInfoMap = [UUID: ModelInfo]()
            let selectedModel = ModelSelectionManager.shared.selectedModelInfo
            for modelInfo in modelInfos {
                let modelItem = ModelItem(name: modelInfo.name, downloadURL: modelInfo.remoteURL?.absoluteString)
                newItems.append(modelItem)
                idInfoMap[modelItem.id] = modelInfo
                self.updateState(for: modelItem, info: modelInfo)

                if selectedModel?.name == modelInfo.name {
                    modelItem.selected = true
                    self.selectedModel = modelItem
                }
            }
            self.models = newItems
            self.identifierInfoMap = idInfoMap

        }.store(in: &self.cancellables)
    }

    // MARK: - Actions

    func handleStateAction(for model: ModelItem) {
        guard let index = models.firstIndex(where: { $0.id == model.id }) else { return }

        switch models[index].state {
        case .notLoaded:
            startLoading(at: index)
        case .loading, .loaded:
            break // non-interactive states
        }
    }

    func remove(_ model: ModelItem) {
    }

    func addModel(name: String, downloadURL: String) {
    }

    // MARK: - Private

    private func updateState(for item: ModelItem, info: ModelInfo) {
        Task { [weak self] in
            guard let self else { return }

            self.updateState(for: item, state: try? await self.provider.model(for: info).state)
        }
    }

    private func updateState(for item: ModelItem, state: Model.ModelState?) {
        switch state {
        case .initial, .none, .failed: item.state = .notLoaded
        case .preparing(let progress): item.state = .loading(progress: (progress?.fractionCompleted ?? 0))
        case .ready: item.state = .loaded
        case .some(_): item.state = .notLoaded
        }
    }

    private func startLoading(at index: Int) {
        let item = models[index]
        item.state = .loading(progress: 0)

        Task { [weak self] in
            guard let self, let modelInfo = self.identifierInfoMap[item.id] else { return }

            guard let model = try? await self.provider.model(for: modelInfo) else { return }

            self.updateState(for: item, state: model.state)

            switch model.state {
            case .initial, .failed:
                model.prepareModel()
            case .preparing, .ready:
                return
            @unknown default:
                fatalError()
            }

            model.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
                guard let self else { return }

                self.updateState(for: item, state: state)
            }.store(in: &self.cancellables)
        }
    }

    func selectModel(item: ModelItem) {
        self.selectedModel?.selected = false
        self.selectedModel = item
        item.selected = true
        ModelSelectionManager.shared.selectedModelInfo = self.identifierInfoMap[item.id]
    }
}
