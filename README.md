# Temperament Quest

A Flutter app that runs a **playful, game-style classical temperament quiz** (Sanguine, Choleric, Melancholic, Phlegmatic). Twenty questions use varied inputs (cards, radio, sliders, toggles, dropdowns, and more). Results show your **dominant temperament** plus a **percentage blend** across all four — for reflection only, not a clinical assessment.

## Features

- **PageView flow** — one question per page, horizontal swipe, back button for previous questions
- **Named routes** — home and quiz without circular imports
- **Weighted scoring** — answers add temperament points; totals become percentages (largest-remainder to 100%)
- **Result screen** — hero card, strengths/challenges, blend bars, careers / study / relationship tips

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run
```

**Web:**

```bash
flutter run -d chrome
```

## Project structure

| Path | Description |
|------|-------------|
| `lib/main.dart` | `MaterialApp`, theme, routes |
| `lib/ui/home_screen.dart` | Intro + start quest |
| `lib/ui/quiz_flow_screen.dart` | `PageView`, progress, answers map |
| `lib/ui/question_inputs.dart` | Per-question input widgets |
| `lib/ui/result_screen.dart` | Dominant + blend + tips |
| `lib/ui/game_theme.dart` | Colors, gradients, Fredoka + Nunito |
| `lib/quiz/quiz_bank.dart` | All 20 questions and options |
| `lib/quiz/temperament_scoring.dart` | Score aggregation and breakdown |

## Disclaimer

For fun and self-reflection only — not medical or psychological advice.

## Learn more

- [Flutter documentation](https://docs.flutter.dev/)
- [google_fonts](https://pub.dev/packages/google_fonts)
