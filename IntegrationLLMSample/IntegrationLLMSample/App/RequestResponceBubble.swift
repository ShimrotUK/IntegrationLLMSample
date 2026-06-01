//
//  Untitled.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.

import SwiftUI

struct RequestResponceBubble: View {
    let model: RequestResponceModel

    var body: some View {
        HStack {
            Spacer(minLength: 60)
            VStack {
                HStack {
                    Spacer()
                    Text(model.request)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Rectangle().fill(Color.gray.opacity(0.3)).frame(minWidth: 10, maxHeight: 10)
                HStack {
                    Text(model.request)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Spacer()
                }
            }.background {
                RoundedRectangle(cornerRadius: 16, style: RoundedCornerStyle.continuous).fill(Color.green.opacity(0.3))
            }
        }
    }
}


