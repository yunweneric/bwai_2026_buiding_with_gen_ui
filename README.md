# Just Today

A Flutter demo that combines [GenUI](https://pub.dev/packages/genui) with the [Google Gemini API](https://ai.google.dev/) via [`flutter_gemini`](https://pub.dev/packages/flutter_gemini). Chat with an AI task planner that can render interactive UI surfaces (for example, a task list you can mark complete) using the A2UI protocol.

## Features

- Multi-turn chat powered by Gemini
- GenUI surfaces for structured, agent-generated UI
- Custom `TaskDisplay` catalog widget for daily task planning and tracking

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (this project uses [FVM](https://fvm.app/); see `.fvmrc` for the SDK version)
- A [Gemini API key](https://aistudio.google.com/apikey) from Google AI Studio

## Setup

1. Clone the repository and install dependencies:

   ```bash
   flutter pub get
   ```

2. Copy the example env file and add your API key:

   ```bash
   cp env.json.example env.json
   ```

   Edit `env.json` with your [Gemini API key](https://aistudio.google.com/apikey). This file is gitignored — do not commit it.

## Run

**Web (Chrome):**

```bash
flutter run -d chrome --dart-define-from-file=env.json
```

**Other devices:**

```bash
flutter run --dart-define-from-file=env.json
```

### VS Code / Cursor

Use the **Just Today (Chrome)** launch config in `.vscode/launch.json`. It loads `GEMINI_API_KEY` and `GEMINI_MODEL` from `env.json` automatically.

## Project structure

| Path | Description |
|------|-------------|
| `lib/main.dart` | App entry, Gemini chat loop, GenUI conversation wiring |
| `lib/widgets/task_display.dart` | Custom GenUI catalog item for the task list surface |
| `lib/widgets/message_bubble.dart` | Chat message UI |
| `lib/widgets/surface_item.dart` | Renders dynamic GenUI surfaces in the chat list |

## Security

Do not commit API keys or generated Firebase config files. `.gitignore` excludes `env.json` and other secret paths (for example `.env`, `lib/firebase_options.dart`, `google-services.json`). Commit `env.json.example` only as a template.

## Learn more

- [GenUI package](https://pub.dev/packages/genui)
- [flutter_gemini](https://pub.dev/packages/flutter_gemini)
- [Flutter documentation](https://docs.flutter.dev/)
