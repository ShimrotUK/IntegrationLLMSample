//
//  ModelsPreferencesView.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI

struct ModelsPreferencesView: View {
    @StateObject private var viewModel = ModelsPreferencesViewModel()

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach($viewModel.models) { $model in
                    ModelRowView(model: model, onDelete: {
                        viewModel.remove(model)
                    }, onStateAction: {
                        viewModel.handleStateAction(for: model)
                    }, onSelectAction: {
                        viewModel.selectModel(item: model)
                    })
                    .listRowSeparator(.visible)
                    .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                }
            }
            .listStyle(.plain)

            Divider()

            // Bottom + button
            HStack {
                Button {
                    viewModel.isAddModelPresented = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .help("Add model")
                .disabled(self.viewModel.addModelAvailable)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .sheet(isPresented: $viewModel.isAddModelPresented) {
            AddModelView { name, url in
                viewModel.addModel(name: name, downloadURL: url)
            }
        }
    }
}
