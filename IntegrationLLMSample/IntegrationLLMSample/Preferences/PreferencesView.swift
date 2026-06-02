//
//  PreferencesView.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI

// MARK: - PreferencesView

struct PreferencesView: View {
    var body: some View {
        TabView {
            GeneralPreferencesView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            ModelsPreferencesView()
                .tabItem {
                    Label("Models", systemImage: "cpu")
                }
        }
        .frame(width: 720, height: 600)
    }
}
