//
//  ModelItem.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI
import Combine

class ModelItem: Identifiable, ObservableObject {
    enum ModelState: Equatable {
        case notLoaded
        case loading(progress: Double)
        case loaded

        static func == (lhs: ModelState, rhs: ModelState) -> Bool {
            switch (lhs, rhs) {
            case (.notLoaded, .notLoaded): return true
            case (.loading(let a), .loading(let b)): return a == b
            case (.loaded, .loaded): return true
            default: return false
            }
        }
    }

    let id: UUID
    let removable: Bool
    var name: String
    var downloadURL: String?
    @Published var state: ModelState
    @Published var selected: Bool = false

    init(
        id: UUID = UUID(),
        name: String,
        downloadURL: String?,
        state: ModelState = .notLoaded,
        removable: Bool = false
    ) {
        self.id = id
        self.name = name
        self.downloadURL = downloadURL
        self.state = state
        self.removable = removable
    }
}
