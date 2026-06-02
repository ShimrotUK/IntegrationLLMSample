//
//  Untitled.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.
//

import SwiftUI
import Combine

class RequestResponceModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: RequestResponceModel, rhs: RequestResponceModel) -> Bool {
        lhs.id == rhs.id
    }

    enum ResponceStatus {
        case initial
        case pending(result: String?)
        case ready(result: String)
        case error

        var text : String {
            switch self {
            case .initial:
                return "Initial"
            case .pending(let result):
                return "Pending ... " + (result ?? "")
            case .ready(let result):
                return "Complete answer:" + result
            case .error:
                return "Some error occurred"
            }
        }
    }

    let id: UUID
    let request: String
    @Published var responce: ResponceStatus
    let timestamp: Date

    init(id: UUID = UUID(), request: String, responce: ResponceStatus = .initial, timestamp: Date = .now) {
        self.id = id
        self.request = request
        self.responce = responce
        self.timestamp = timestamp
    }
}
