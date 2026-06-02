//
//  ModelStatusView.swift
//  IntegrationLLMSample
//
//  Created by Yevhenii Lysiuk on 03.06.2026.
//

import SwiftUI
import LLMSampleKit

struct ModelStatusView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        HStack {
            Spacer(minLength: 32)
            Text("Selected Model: ")
                .font(.headline)
            Text(viewModel.selectedModelInfo?.name ?? "None")
                .font(.headline)
            Spacer(minLength: 32)
            Text("Model Status: ")
                .font(.headline)
            Text(viewModel.selectedModelState ?? "None")
                .font(.headline)
            Spacer(minLength: 32)
        }
    }
}
