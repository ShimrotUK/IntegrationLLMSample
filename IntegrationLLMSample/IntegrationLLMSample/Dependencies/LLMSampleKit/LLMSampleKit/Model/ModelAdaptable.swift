//
//  ModelAdaptable.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation

protocol ModelAdaptable {
    var isReady: Bool { get }

    func prepareModel(progressHandler: @Sendable @escaping (Progress) -> Void) async throws
    func generate(prompt: String) -> AsyncThrowingStream<String, Error>
}
