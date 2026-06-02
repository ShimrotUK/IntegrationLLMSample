//
//  ModelRowView.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI

struct ModelRowView: View {
    @StateObject var model: ModelItem
    let onDelete: () -> Void
    let onStateAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Name
            Text(model.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            // State button
            stateButton
            if model.selected {
                Text("Selected")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            else {
                Button("Select", action: onStateAction)
                    .buttonStyle(ModelActionButtonStyle(color: .green))
            }
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .disabled(self.model.removable)
            .help("Remove model")
        }
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var stateButton: some View {
        switch model.state {
        case .notLoaded:
            Button("Load", action: onStateAction)
                .buttonStyle(ModelActionButtonStyle(color: .accentColor))

        case .loading(let progress):
            HStack(spacing: 6) {
                if progress > 0 {
                    ProgressView(value: progress)
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .frame(width: 14, height: 14)
                }
                Text("Loading…")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100)

        case .loaded:
            Text("ready to use")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
    }
}
