//
//  ContentView.swift
//  IntegrationLLMSample
//
//  Created by Eugen.Lysyuk on 31.05.2026.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(spacing: 0) {
            MainAreaView(viewModel: viewModel)
            Divider()
            BottomInputView(viewModel: viewModel)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    openSettings()
                } label: {
                    Image(systemName: "gear")
                }
                .help("Settings")
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

// MARK: - MainAreaView

struct MainAreaView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    if viewModel.requestResponceModel.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(viewModel.requestResponceModel) { model in
                            RequestResponceBubble(model: model)
                                .id(model.id)
                        }
                    }
                }
                .padding(16)
            }
            .onChange(of: viewModel.requestResponceModel.count) { _, _ in
                if let last = viewModel.requestResponceModel.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .textBackgroundColor))
    }

    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No messages yet")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("Type something below to get started.")
                .font(.callout)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }
}

// MARK: - BottomInputView

struct BottomInputView: View {
    @ObservedObject var viewModel: ContentViewModel
    @FocusState private var isInputFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if viewModel.inputText.isEmpty {
                    Text("Type a message…")
                        .foregroundStyle(.tertiary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $viewModel.inputText)
                    .focused($isInputFocused)
                    .frame(minHeight: 36, maxHeight: 120)
                    .scrollContentBackground(.hidden)
                    .onAppear { isInputFocused = true }
            }
            .padding(6)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isInputFocused ? Color.accentColor.opacity(0.6) : Color(nsColor: .separatorColor), lineWidth: 1)
            )

            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(viewModel.canSend ? Color.accentColor : Color.secondary)
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canSend)
            .keyboardShortcut(.return, modifiers: .command)
            .help("Send (⌘ Return)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section("General") {
                    TextField("Display name", text: $userName)
                    Toggle("Enable notifications", isOn: $notificationsEnabled)
                }
            }
            .formStyle(.grouped)
            .padding(.bottom, 8)

            HStack {
                Spacer()
                Button("Done") { dismiss() }
                    .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .frame(width: 360, height: 240)
    }
}

#Preview {
    ContentView()
}
