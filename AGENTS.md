# AGENTS.md - Stock Tracker

## Project Overview

Flutter app autónoma que descarga precios de acciones desde Yahoo Finance. Sin backend.

## GitHub

- **Repo**: https://github.com/yumokete-for-agents/stock-tracker
- **CI/CD**: GitHub Actions (flutter.yml) - Build APK en cada push

## Structure

```
frontend/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/
│   │   ├── stock.dart            # Datos de precio
│   │   ├── stock_fundamentals.dart  # PE, P/B, EPS, Beta, etc.
│   │   └── stock_snapshot.dart   # Snapshot + histórico con timestamps
│   ├── services/
│   │   ├── stock_service.dart    # Yahoo Finance API
│   │   └── storage_service.dart # Persistencia + histórico (30 snapshots)
│   ├── screens/
│   │   └── home_screen.dart    # UI principal
│   └── widgets/
│       ├── stock_card.dart
│       └── fundamentals_panel.dart
├── pubspec.yaml
└── test/
```

## Commands

```bash
# Install dependencies (Flutter local)
cd frontend && flutter pub get

# Run app
cd frontend && flutter run

# Run tests
cd frontend && flutter test

# Build APK
cd frontend && flutter build apk --debug --release

# Flutter analyze
cd frontend && flutter analyze
```

## Dependencies

- `yahoofin: ^0.2.0` - Yahoo Finance API
- `shared_preferences: ^2.2.3` - Persistencia local

## Fundamentales (guardados con timestamp)

| Campo | Descripción |
|-------|-----------|
| trailingPE | P/E actual |
| forwardPE | P/E forward |
| priceToBook | P/B |
| epsTrailing | EPS (TTM) |
| epsForward | EPS forward |
| beta | Beta |
| dividendYield | Dividend Yield % |
| marketCap | Market Cap |
| fiftyTwoWeekHigh/Low | 52W High/Low |

## Key Facts

- Flutter requiere instalación local
- App autónoma - NO necesita backend
- Tickers guardados en shared_preferences
- Histórico: hasta 30 snapshots por ticker
- GitHub Actions compila APK automáticamente

## Subagentes (opencode.json)

- `flutter-expert`: Desarrollo Flutter/Dart
- `ui-designer`: Diseño UI/UX