# Flutter Best Practices

This document summarizes the conventions and guardrails that apply to the Comet scaffold when targeting Flutter `>=3.7.0` (see `pubspec.yaml`). Follow these notes whenever you add dependencies, write Dart code, or configure tooling.

## 1. Environment & Tooling
- **Flutter channel**: stable. Keep your local SDK in sync with CI (`subosito/flutter-action@v2` defaults to stable).
- **Dart SDK range**: `>=3.7.0 <4.0.0`. Verify via `dart --version` before committing.
- **Localization pipeline**: `flutter gen-l10n` must run after changing `l10n/arb` files; generated output is already whitelisted in `analysis_options.yaml`.
- **Shared build artifacts**: Android Gradle outputs are redirected to `/build` (see `android/build.gradle.kts`). Run `flutter clean && rm -rf build/` when switching Flutter versions.

## 2. Dependency Management (`pubspec.yaml`)
- Favor first-party packages already listed: Riverpod 3 (`flutter_riverpod`), GoRouter 17, Dio 5. Avoid mixing alternative state managers unless the feature justifies it.
- Keep `shared_preferences`, `flutter_secure_storage`, and `hive` responsibilities separated:
  - `shared_preferences`: lightweight flags (non-sensitive).
  - `flutter_secure_storage`: secrets/credentials (ensure biometric permission in Android manifest).
  - `hive`: structured offline cache; register adapters in `bootstrap.dart`.
- Update dependencies with `flutter pub outdated` and bump conservatively; prefer caret constraints to pick up patch fixes.
- Store environment-specific entrypoints in `lib/main_<env>.dart` and pass `--dart-define=APP_ENV=<env>` so secrets stay outside source.

## 3. Code Quality (`analysis_options.yaml`)
- The repo inherits `package:flutter_lints/flutter.yaml` and adds stricter language settings:
  - `strict-casts`, `strict-inference`, `strict-raw-types` prevent implicit runtime casts.
- High-signal lint rules to respect:
  - **API surface**: `type_annotate_public_apis`, `always_declare_return_types`, `use_super_parameters`.
  - **Immutability**: `prefer_const_constructors`, `prefer_final_fields`, `prefer_const_literals_to_create_immutables`.
  - **Safety**: `await_only_futures`, `use_build_context_synchronously`, `unawaited_futures`, `only_throw_errors`.
  - **Style**: `flutter_style_todos`, `directives_ordering`, `require_trailing_commas`, `prefer_single_quotes`.
- Generated files are excluded (`*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `lib/core/l10n/generated/**`). Do not hand-edit excluded directories.
- When a lint conflicts with valid code, prefer refactoring; only suppress with `// ignore` on the narrowest scope and include justification.

## 4. Testing & Coverage
- Run `flutter test --coverage` before pushing; CI uploads `coverage/lcov.info` to Codecov (token via `CODECOV_TOKEN` secret).
- Target behavior-driven tests per feature:
  - Domain layer: pure Dart tests, no Flutter imports.
  - Presentation: widget tests with `WidgetTester` or Riverpod `ProviderContainer`.
- Keep coverage noise low by excluding generated files (already handled in `codecov.yml`).

## 5. Architecture & Implementation Patterns
- Maintain the feature-first layout already present (`lib/features/<feature>/presentation|domain|data`).
- `lib/core` contains infrastructure (config, storage, network, theme, widgets). Never import a feature module from core to avoid circular dependencies.
- Use Riverpod providers for dependency injection:
  - Register core services in `app/di.dart`.
  - For features, create providers in `presentation/providers/...` and keep state in `StateNotifier`/`AsyncNotifier`.
- Routing flows through `go_router`; add feature-specific route builders and compose them inside `app/router.dart`.
- Networking via `dio`: centralize interceptors (logging, auth) under `lib/core/network`.
- Handle errors with the shared `Result<T>` + `Failure` types to keep UI logic declarative.

## 6. UI Best Practices
- Keep widgets **small and composable**. Break screens into `Page` + leaf widgets so state stays in Riverpod providers rather than `StatefulWidget` internals.
- Prefer **stateless widgets**; when state is inevitable use Riverpod (`StateNotifier`, `AsyncNotifier`) or Flutter hooks instead of lifting logic into build methods.
- Source colors, text styles, and spacing from `lib/core/theme` via `Theme.of(context)` or custom theme extensions. Avoid hard-coded hex values or magic numbers.
- Reuse base components (`lib/core/widgets`, e.g., `AppScaffold`, `ErrorView`) to keep padding/typography consistent. Document new shared widgets in-line.
- Honor responsiveness: wrap layouts with `LayoutBuilder`, rely on `MediaQuery.size`, and provide alternate compositions for tablet/web breakpoints as needed.
- Accessibility: ensure tap targets ≥48 logical px, provide `Semantics` labels for icons, and respect `MediaQuery.textScaleFactor`.
- Favor `const` constructors and `const` widgets for deterministic rebuilds; rely on lints (`prefer_const_constructors`, `require_trailing_commas`) to enforce readability.

## 7. Platform Notes
- **Android**:
  - Ensure `android/app/src/main/AndroidManifest.xml` declares `<uses-permission android:name="android.permission.USE_BIOMETRIC" />` for `flutter_secure_storage`.
  - Stick to Java 17 (configured via `actions/setup-java@v4`) unless AGP requires a different version.
  - Use `./gradlew lint` to verify manifest/permission issues; the CI build already covers `assemble{Debug,Profile,Release}`.
- **iOS**:
  - CI runs `flutter build ios --no-codesign`; local dev should open `ios/Runner.xcworkspace` after `pod install`.
  - Keep Podfile in sync when adding native plugins; run `pod repo update` if CocoaPods complains about missing specs.

## 8. Workflow Checklist
1. `flutter pub get`
2. Implement feature respecting architecture boundaries.
3. `dart format --set-exit-if-changed .`
4. `flutter analyze --fatal-infos`
5. `flutter gen-l10n` (when localization changes)
6. `flutter test --coverage`
7. Update docs (CLAUDE.md / AGENT.md / this file) if tooling or processes change.

Adhering to these practices keeps the scaffold upgrade-friendly and ensures CI parity with local development. When platform tooling evolves (e.g., new Flutter LTS), update this document alongside the relevant configuration files.

## 9. Reference Documentation
| Library / Tool | Official Docs |
| --- | --- |
| Flutter SDK | https://docs.flutter.dev |
| Dart language | https://dart.dev/guides |
| flutter_riverpod | https://riverpod.dev/docs/getting_started |
| go_router | https://pub.dev/documentation/go_router/latest/ |
| dio | https://pub.dev/documentation/dio/latest/ |
| intl | https://pub.dev/documentation/intl/latest/intl/intl-library.html |
| shared_preferences | https://pub.dev/documentation/shared_preferences/latest/ |
| flutter_secure_storage | https://pub.dev/documentation/flutter_secure_storage/latest/ |
| hive | https://docs.hivedb.dev/#/ |
| hive_flutter | https://docs.hivedb.dev/#/getting_started/flutter |
| flutter_lints | https://pub.dev/documentation/flutter_lints/latest/ |
| mocktail | https://pub.dev/documentation/mocktail/latest/ |
| go_router + Riverpod patterns | https://docs.flutter.dev/cookbook/navigation/router |

Add new rows when introducing additional dependencies so contributors can quickly discover their official references.
