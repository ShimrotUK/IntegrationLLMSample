//
//  ModelRowView.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 01.06.2026.
//

import SwiftUI

struct ModelRowView: View {
    @Binding var model: ModelItem
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

            // Delete button
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Remove model")
        }
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var stateButton: some View {
        switch model.state {
        case .load:
            Button("Load", action: onStateAction)
                .buttonStyle(ModelActionButtonStyle(color: .accentColor))

        case .loading(let progress):
            HStack(spacing: 6) {
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                    .controlSize(.small)
                    .frame(width: 14, height: 14)
                Text("Loading…")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100)

        case .select:
            Button("Select", action: onStateAction)
                .buttonStyle(ModelActionButtonStyle(color: .green))

        case .selected:
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 13))
                Text("Selected")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100)
        }
    }
}
