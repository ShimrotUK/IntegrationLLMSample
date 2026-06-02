//
//  ModelProvidersManager.swift
//
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation

public class ModelProvidersManager {
    public enum ModelProviderType: Equatable {
        case huggingFace
    }

    public static let shared = ModelProvidersManager()

    private var providers = [ModelProviderType: ModelProvider]()

    private init() {}

    public func provider(for type: ModelProviderType) -> ModelProvider {
        if let provider = self.providers[type] {
            return provider
        }

        let provider = self.createProvider(for: type)
        self.providers[type] = provider

        return provider
    }

    private func createProvider(for type: ModelProviderType, featchModelInfos: Bool = true) -> ModelProvider {
        switch type {
        case .huggingFace:
            return ModelProvider(
                modelInfoStore: HuggingFaceModalInfoStore(),
                modelStore: HuggingFaceModalStore(),
                featchModelInfos: featchModelInfos
            )
        }
    }
}
