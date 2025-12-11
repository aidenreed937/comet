# AGENT.md

This document gives high-level instructions for code agents (e.g., GitHub Copilot, ChatGPT, Cursor) that work inside this repository. Use it to understand how the project is wired, which commands to run first, and where common pitfalls live.

## 1. Project Snapshot
- **Stack**: Flutter (stable channel), Dart `>=3.7.0`, Riverpod 3, GoRouter 17, Dio 5, Hive + shared_preferences + flutter_secure_storage.
- **Purpose**: A feature-first Flutter scaffold showcasing clean architecture; business logic is minimal so focus on engineering infrastructure.
- **Key dirs**:
  - `lib/app`: bootstrap, router, dependency wiring.
  - `lib/core`: shared services/utilities; must not import features.
  - `lib/features/<name>/{presentation,domain,data}`: vertical slices.
  - `android/`, `ios/`, `web/`, etc. for platform shells.

## 2. First Things To Do
1. Run `flutter pub get`.
2. Regenerate localization after touching any `arb` files: `flutter gen-l10n`.
3. Format + analyze before committing:
   ```bash
   dart format --set-exit-if-changed .
   flutter analyze --fatal-infos
   ```
4. Execute the fast test target when iterating:
   ```bash
   flutter test --coverage
   ```

## 3. Useful Command Cheat Sheet
| Purpose | Command |
| --- | --- |
| Run development app | `flutter run -t lib/main_development.dart --dart-define=APP_ENV=development` |
| Run staging/prod | swap entrypoint (`main_staging.dart`, `main_production.dart`) and `APP_ENV` define |
| Flutter integration test placeholder | `flutter test integration_test` (create tests if needed) |
| Android build | `cd android && ./gradlew assembleDebug` or `./gradlew build` |
| iOS build (CI-style) | `flutter build ios --no-codesign --dart-define=APP_ENV=development` |
| Clean build outputs | `flutter clean && rm -rf build/` (Flutter) or `cd android && ./gradlew clean` |

## 4. CI & Coverage Notes
- GitHub Actions workflow `.github/workflows/ci.yml` runs `analyze → test → build-android / build-ios`.
- Codecov upload uses `codecov/codecov-action@v4` and expects `CODECOV_TOKEN` in repo secrets. Local testing can run `flutter test --coverage` then inspect `coverage/lcov.info`.
- `codecov.yml` already ignores generated files (`*.g.dart`, `*.freezed.dart`, `lib/core/l10n/generated/**`).
- Warnings like “No config file found”, “xcrun missing”, or “No gcov data” are informational when uploading from Linux—safe to ignore.

## 5. Platform-Specific Tips
### Android
- `android/local.properties` supplies `sdk.dir` and `flutter.sdk`. Keep it untracked or sanitized before committing.
- `flutter_secure_storage` 10.x uses biometrics; ensure `android/app/src/main/AndroidManifest.xml` declares:
  ```xml
  <uses-permission android:name="android.permission.USE_BIOMETRIC" />
  ```
  Without it `./gradlew lint` will fail.
- Place Gradle-only tweaks in `android/build.gradle.kts`. Shared build outputs are redirected to `../build` to keep the repo root tidy.

### iOS
- Builds are performed with `--no-codesign` in CI. When coding locally, open `ios/Runner.xcworkspace` after running `pod install`.
- If you install new CocoaPods deps, run `pod repo update` before `pod install` to avoid stale specs warnings.

## 6. Coding Guidelines
- Follow strict analysis rules from `analysis_options.yaml`; fix or justify any analyzer warning before opening a PR.
- Keep feature boundaries clean:
  - `lib/core` never imports from `lib/features`.
  - `domain` layer must stay Flutter-free (pure Dart).
  - Cross-feature communication goes through shared services (e.g., repositories in `core`).
- Maintain localization by editing `l10n/arb` files; generated output lands under `lib/core/l10n/generated/`.
- Prefer small, composable widgets. Shared UI building blocks go in `lib/core/widgets/`.

## 7. Troubleshooting
- **Gradle lint complaining about biometrics**: verify the permission above; if third-party plugins still fail, run `./gradlew lintVitalRelease --stacktrace` to pinpoint.
- **Codecov token missing in CI**: add `CODECOV_TOKEN` secret under GitHub → Settings → Secrets → Actions and ensure the workflow step includes `token: ${{ secrets.CODECOV_TOKEN }}`.
- **`xcrun` warning during Linux CI**: harmless; shows because macOS-specific tooling is absent.
- **Slow first Android build**: check `~/.gradle/daemon` logs; `./gradlew --stop` followed by `./gradlew build --no-daemon` can help when daemons become unhealthy.

## 8. Workflow Expectations
- Every PR should:
  1. Run `flutter analyze`, `dart format`, and `flutter test --coverage`.
  2. Include updates to `l10n` outputs if strings changed.
  3. Update docs (like this file) when tooling/commands evolve.
- When modifying CI or scripts, document custom behavior here so future agents know how to interact with the pipeline.

Happy shipping! Keep this file up-to-date whenever workflows or tooling change so other agents ramp up instantly.
