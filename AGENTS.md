# AGENTS.md - Stock Tracker

## Project Overview

Flutter app autónoma que descarga precios de acciones desde Yahoo Finance. Sin backend.

## Structure

```
frontend/
├── lib/
│   ├── main.dart           # Entry point
│   ├── models/stock.dart   # Stock data model
│   ├── services/
│   │   ├── stock_service.dart    # Yahoo Finance API
│   │   └── storage_service.dart  # Local persistence
│   ├── screens/home_screen.dart  # Main screen
│   └── widgets/stock_card.dart   # Stock display widget
├── pubspec.yaml             # Dependencies
└── test/                    # Tests
```

## Commands

```bash
# Install dependencies
cd frontend && flutter pub get

# Run app
cd frontend && flutter run

# Run tests
cd frontend && flutter test

# Build APK
cd frontend && flutter build apk --release
```

## Dependencies

- `yahoofin` - Yahoo Finance API
- `shared_preferences` - Local storage for ticker list

## Key Facts

- Flutter requiere instalación local (`brew install flutter` o flutter.dev)
- La app es autónoma - NO necesita backend
- Tickers se guardan localmente con shared_preferences
- Usa Material Design 3
- Subagentes especializados en `opencode.json`: `flutter-expert`, `ui-designer`

## CI/CD (GitHub Actions)

```bash
# El workflow está en .github/workflows/flutter.yml
# Se ejecuta automáticamente en push/PR a main
# Sube APK como artifact: app-debug.apk
```

## Development Notes

- Verificar `pubspec.yaml` antes de añadir nuevas dependencias
- Los tests están en `frontend/test/`
- Para añadir nuevos packages: `flutter pub add <package>`
