# IntegrationLLMSample

A macOS sample project demonstrating on-device LLM inference using [MLX Swift](https://github.com/ml-explore/mlx-swift-examples). The app downloads and runs quantised language models (Llama 3.2 1B) locally on Apple Silicon via the Metal Performance Shaders framework — no internet connection required at inference time.

---

## Requirements

| Requirement | Version |
|---|---|
| macOS | 14 Sonoma or later |
| Xcode | 16.0 or later |
| Hardware | Apple Silicon (M1 or later) |

---

## Preparation

### 1. Install the Metal Toolchain (if needed)

MLX Swift relies on Metal shader compilation. On a fresh machine you may need to install the Xcode Command Line Tools and confirm the active developer directory is set correctly.

Open **Terminal** and run:

```bash
xcode-select --install
```

If you already have Xcode installed and only need to confirm the toolchain is pointing to it:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
xcodebuild -version   # should print Xcode 16.x
```

---

## Getting Started

### 2. Clone the repository

```bash
git clone https://github.com/ShimrotUK/IntegrationLLMSample.git
cd IntegrationLLMSample
```

### 3. Open the project

Open the Xcode project file located at:

```
IntegrationLLMSample/IntegrationLLMSample.xcodeproj
```

You can do this from the terminal:

```bash
open IntegrationLLMSample/IntegrationLLMSample.xcodeproj
```

> **Trust prompt** — Xcode may show an alert asking whether to trust the project. Click **Trust and Open**.

Xcode will automatically resolve Swift Package Manager dependencies (MLX Swift, mlx-swift-lm, swift-transformers). This may take a minute on the first open.

---

## Running the App

### 4. First build attempt — enable the macro plugin

1. Select the **IntegrationLLMSample** scheme and your Mac as the run destination.
2. Press **⌘R** (or click the Run button) to build and run.
3. The build will stop with an error about an untrusted macro or plugin.
4. **Click on the error** in the Issue navigator or the build log.
5. An alert will appear asking you to trust the macro package — click **Trust** (or **Enable & Trust**).

### 5. Run again

Press **⌘R** a second time. The build will now succeed and the app will launch.

> The first time you load a model the app will download the quantised weights (~700 MB) from Hugging Face. Progress is shown inline. Subsequent launches use the cached weights and start immediately.

---

## Project Structure

```
IntegrationLLMSample/
├── IntegrationLLMSample.xcodeproj
└── IntegrationLLMSample/
    ├── MyApp.swift                      # App entry point + Settings scene
    ├── ContentView.swift                # Main window: toolbar, chat area, text input
    ├── ContentViewModel.swift           # Message state, send/receive logic
    ├── LLMService.swift                 # MLX model loading + streaming generation
    ├── PreferencesView.swift            # Settings window (General + Models tabs)
    └── ModelsPreferencesViewModel.swift # Model list state, download simulation
```

---

## How It Works

- **Model loading** — `LLMService` uses `MLXLMCommon.loadModelContainer` with a sandboxed cache directory inside the app's Application Support folder. No special entitlements beyond `network.client` are required.
- **Streaming generation** — tokens stream into the UI as they are generated via Swift Concurrency (`AsyncSequence`).
- **Model management** — the Models preferences tab lets you add, load, select, and remove models. The load button simulates (and can be wired to) a real download with live progress.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Build fails with macro/plugin error | Click the error → Trust & Enable the plugin → rebuild |
| `HuggingFaceDownloaderError` at launch | Ensure `com.apple.security.network.client` entitlement is present in the target |
| `basic_string nullptr` crash | Avoid calling `applyChatTemplate` with an empty messages array; guard input before generating |
| Model download stalls | Check your internet connection; delete `~/Library/Containers/<bundle-id>/Data/Library/Application Support/huggingface/` and retry |
| App is slow on first inference | Normal — MLX JIT-compiles Metal shaders on first run; subsequent runs are faster |

---

## License

MIT
