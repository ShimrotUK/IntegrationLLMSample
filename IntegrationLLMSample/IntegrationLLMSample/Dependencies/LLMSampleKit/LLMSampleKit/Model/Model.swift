//
//  Model.swift
//  
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import Foundation
import Combine

public class Model {
    public enum ModelError: Error {
        case notPrepared
    }

    public enum ModelState: Equatable {
        public static func == (lhs: Model.ModelState, rhs: Model.ModelState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial), (.preparing, .preparing), (.ready, .ready), (.failed, .failed):
                return true
            default : return false
            }
        }
        
        case initial
        case preparing(progress: Progress?)
        case ready
        case failed(Error)
    }
    
    private let info: ModelInfo
    private let adapter: any ModelAdaptable
    @Published public private(set) var state: ModelState

    private var cancellables = Set<AnyCancellable>()

    init(info: ModelInfo, adapter: any ModelAdaptable) {
        self.info = info
        self.adapter = adapter

        self.state = self.adapter.isReady ? .ready : .initial
    }

    public func prepareModel() {
        switch self.state {
        case .initial, .failed:
            Task { [weak self] in
                guard let self else { return }
                do {
                    self.state = .preparing(progress: nil)
                    try await self.adapter.prepareModel { [weak self] progress in
                        guard let self else { return }

                        self.state = .preparing(progress: progress)
                    }
                    self.state = .ready
                }
                catch {
                    self.state = .failed(error)
                }
            }
        case .preparing, .ready: break
        }
    }

    public func generate(prompt: String, autoprepare: Bool = false) -> AsyncThrowingStream<String, Error> {
        guard self.state == .ready else {
            if autoprepare {
                return self.generateAfterPreparing(prompt: prompt)
            }
            else {
                return AsyncThrowingStream { continuation in
                    continuation.finish(throwing: ModelError.notPrepared)
                }
            }
        }

        return self.adapter.generate(prompt: prompt)
    }

    private func generateAfterPreparing(prompt: String) -> AsyncThrowingStream<String, Error> {
        self.prepareModel()
        return AsyncThrowingStream { continuation in
            self.$state.sink { state in
                switch state {
                case .ready:
                    let task = Task {
                        try? await Task.sleep(for: .milliseconds(100))

                        do {
                            for try await value in self.generate(prompt: prompt) {
                                continuation.yield(value)
                            }
                            continuation.finish()
                        } catch {
                            continuation.finish(throwing: error)
                        }
                    }

                    continuation.onTermination = { @Sendable _ in task.cancel() }
                case .failed(let error):
                    continuation.finish(throwing: error)
                case .initial, .preparing: break
                }
            }.store(in: &self.cancellables)
        }
    }
}
