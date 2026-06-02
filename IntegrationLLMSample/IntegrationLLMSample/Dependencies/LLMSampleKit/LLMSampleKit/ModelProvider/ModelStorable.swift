//
//  ModelStoragable.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

protocol ModelStorable {
    func model(for info: ModelInfo) async throws -> Model
    func store(models: [Model]) async throws
}

extension ModelStorable {
    func store(model: Model) async throws {
        try await self.store(models: [model])
    }
}
