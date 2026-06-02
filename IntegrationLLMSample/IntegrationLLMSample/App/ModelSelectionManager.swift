//
//  ModelSelectionManager.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 02.06.2026.
//

import LLMSampleKit
import Combine
import Foundation

class ModelSelectionManager {
    static let shared = ModelSelectionManager()

    @Published var selectedModelInfo: ModelInfo?

    private var provider = ModelProvidersManager.shared.provider(for: .huggingFace)
    private var cancellables = Set<AnyCancellable>()

    private init() {
        Task {
            self.provider.$availiableModelInfos.receive(on: DispatchQueue.main).sink { [weak self] modelInfos in
                guard let self else { return }

                self.selectedModelInfo = modelInfos.first(where: { info in
                    info.name == "mlx-community/Llama-3.2-1B-Instruct-4bit"
                })
            }.store(in: &self.cancellables)
        }
    }
}
