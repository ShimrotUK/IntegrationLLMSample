//
//  ModelItem.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI
import Combine

struct ModelItem: Identifiable {
    enum ModelState: Equatable {
        case load
        case loading(progress: Double)
        case select
        case selected

        static func == (lhs: ModelState, rhs: ModelState) -> Bool {
            switch (lhs, rhs) {
            case (.load, .load): return true
            case (.loading(let a), .loading(let b)): return a == b
            case (.select, .select): return true
            case (.selected, .selected): return true
            default: return false
            }
        }
    }

    let id: UUID
    var name: String
    var downloadURL: String
    var state: ModelState

    init(id: UUID = UUID(), name: String, downloadURL: String, state: ModelState = .load) {
        self.id = id
        self.name = name
        self.downloadURL = downloadURL
        self.state = state
    }
}
