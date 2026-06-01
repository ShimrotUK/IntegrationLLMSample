//
//  IntegrationLLMSampleApp.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.
//

import SwiftUI

@main
struct IntegrationLLMSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {}

        Settings {
            PreferencesView()
        }
    }
}
