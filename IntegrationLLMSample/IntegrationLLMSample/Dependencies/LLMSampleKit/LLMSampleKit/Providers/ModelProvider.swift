//
//  ModelProvider.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation
import Combine

public class ModelProvider {
    @Published public private(set) var availiableModelInfos = Set<ModelInfo>()

    private var models = [String: Model]()
    private let modelInfoStore: any ModelInfoStorable
    private let modelStore: any ModelStorable
    private var featchModelInfosTask: Task<Void, Error>?

    init(modelInfoStore: any ModelInfoStorable, modelStore: any ModelStorable, featchModelInfos: Bool) {
        self.modelInfoStore = modelInfoStore
        self.modelStore = modelStore

        if featchModelInfos {
            self.featchModelInfos()
        }
    }

    func featchModelInfos() {
        guard self.featchModelInfosTask == nil else { return }

        self.featchModelInfosTask = Task {
            for try await modelInfo in self.modelInfoStore.modelInfos() {
                self.availiableModelInfos.insert(modelInfo)
            }

            self.featchModelInfosTask = nil
        }
    }

    public func model(for info: ModelInfo) async throws -> Model {
        if let model = self.models[info.name] {
            return model
        }

        let model = try await self.modelStore.model(for: info)
        self.models[info.name] = model

        return model
    }
}
