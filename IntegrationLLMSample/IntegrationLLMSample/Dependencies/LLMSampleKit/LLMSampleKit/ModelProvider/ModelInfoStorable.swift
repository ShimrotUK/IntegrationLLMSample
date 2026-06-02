//
//  ModelInfoProvidable.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

protocol ModelInfoStorable {
    func modelInfos() -> AsyncThrowingStream<ModelInfo, Error>
    func store(infos: [ModelInfo]) async throws
}

extension ModelInfoStorable {
    func store(info: ModelInfo) async throws {
        try await self.store(infos: [info])
    }
}
