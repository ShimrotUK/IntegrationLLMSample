//
//  HuggingFaceModalStore.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation
internal import MLXLLM
internal import MLXLMCommon
internal import MLXHuggingFace

class HuggingFaceModalStore: ModelStorable {
    enum HuggingFaceModalStoreError: Error {
        case unstorable
    }

    func model(for info: ModelInfo) async throws -> Model {
        return Model(
            info: info,
            adapter: HuggingFaceModalAdapter(
                modelConfiguration: LLMRegistry.shared.configuration(id: info.name)
            )
        )
    }

    func store(models: [Model]) async throws {
        throw HuggingFaceModalStoreError.unstorable
    }
}
