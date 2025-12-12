# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Comet is a Flutter scaffold project implementing a feature-first architecture with clean architecture principles. It serves as a reusable template for Flutter applications, focusing on engineering infrastructure rather than business logic.

## Common Commands

```bash
# Run the app (different environments)
flutter run -t lib/main_development.dart --dart-define=APP_ENV=development
flutter run -t lib/main_staging.dart --dart-define=APP_ENV=staging
flutter run -t lib/main_production.dart --dart-define=APP_ENV=production

# Flutter run interactive commands (press keys when app is running)
r                 # Hot reload. 🔥🔥🔥
R                 # Hot restart.
h                 # List all available interactive commands.
d                 # Detach (terminate "flutter run" but leave application running).
c                 # Clear the screen
q                 # Quit (terminate the application on the device).

# Run tests
flutter test                                    # All tests
flutter test test/features/counter/             # Feature-specific tests
flutter test --name="CounterController"         # Run tests by name pattern

# Code quality
flutter analyze                                 # Static analysis
dart format .                                   # Format code
dart fix --apply                                # Apply automatic fixes

# Localization
flutter gen-l10n                                # Generate l10n files

# Dependencies
flutter pub get
flutter pub outdated
```

## Architecture

### Directory Structure

```
lib/
├── app/                    # Application composition root
│   ├── app.dart           # Root widget (MaterialApp.router + ProviderScope)
│   ├── bootstrap.dart     # App initialization (Hive, error handling, logging)
│   ├── di.dart            # Core service providers (DioClient, Storage, ErrorReporter)
│   └── router.dart        # GoRouter configuration
├── core/                   # Non-business infrastructure (no feature imports)
│   ├── config/            # Environment configuration (env.dart, app_config.dart)
│   ├── error/             # Failure models and error mapping
│   ├── l10n/              # Localization wrapper (generated files in l10n/generated/)
│   ├── network/           # Dio client and interceptors
│   ├── storage/           # SharedPreferences and SecureStorage wrappers
│   ├── theme/             # AppTheme, ColorSchemes, TextThemes
│   ├── utils/             # Logger, Result type, extensions
│   └── widgets/           # Reusable UI components (AppScaffold, ErrorView, etc.)
├── features/              # Feature modules (feature-first + layered)
│   └── <feature>/
│       ├── presentation/  # Pages, widgets, Riverpod providers
│       ├── domain/        # Entities, repository interfaces (pure Dart, no Flutter)
│       └── data/          # Data sources, repository implementations
└── main_*.dart            # Environment entry points
```

### Key Patterns

- **State Management**: flutter_riverpod with StateNotifier pattern
- **Routing**: go_router with feature-specific route builders (`buildXxxRoutes()`)
- **Dependency Injection**: Riverpod providers in `app/di.dart` for core services
- **Error Handling**: `Result<T>` type with `Failure` models for unified error handling

### Adding a New Feature

1. Create `lib/features/<name>/` with presentation/domain/data subdirectories
2. Add route constants in `presentation/routes.dart` (`XxxRoutes` class)
3. Export route builder function (`buildXxxRoutes()`)
4. Register routes in `app/router.dart`
5. Create corresponding tests in `test/features/<name>/`

### Layer Rules

- `core/` never imports from `features/`
- `domain/` layer must be pure Dart (no `package:flutter` imports)
- Feature cross-communication goes through `core/services/` or shared domain interfaces
- Features should not directly import other features' providers or widgets

## Testing

- Use `mocktail` for mocking
- Test files mirror source structure: `test/features/<name>/...`
- Provider testing pattern: create `ProviderContainer` with overrides, dispose in `tearDown`

## Configuration Files

- `comet.yaml`: Scaffold configuration (environments, state management choice, core dependencies)
- `l10n.yaml`: Localization settings (output to `lib/core/l10n/generated/`)
- `analysis_options.yaml`: Strict Dart analysis with comprehensive lint rules
