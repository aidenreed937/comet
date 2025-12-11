# Flutter 最佳实践

本文档总结了针对 Comet 脚手架在 Flutter `>=3.7.0` 版本时适用的约定和规范（见 `pubspec.yaml`）。在添加依赖、编写 Dart 代码或配置工具时，请遵循这些规范。

## 1. 环境与工具配置
- **Flutter 频道**：stable（稳定版）。保持本地 SDK 与 CI 同步（`subosito/flutter-action@v2` 默认使用稳定版）。
- **Dart SDK 范围**：`>=3.7.0 <4.0.0`。提交前通过 `dart --version` 验证版本。
- **本地化流程**：修改 `l10n/arb` 文件后必须运行 `flutter gen-l10n`；生成的文件已在 `analysis_options.yaml` 中被列入白名单。
- **共享构建产物**：Android Gradle 输出已重定向到 `/build`（见 `android/build.gradle.kts`）。切换 Flutter 版本时运行 `flutter clean && rm -rf build/`。

## 2. 依赖管理 (`pubspec.yaml`)
- 优先使用已列出的第一方包：Riverpod 3（`flutter_riverpod`）、GoRouter 17、Dio 5。除非功能特性明确需要，否则避免混合使用其他状态管理库。
- 分离 `shared_preferences`、`flutter_secure_storage` 和 `hive` 的职责：
  - `shared_preferences`：轻量级标志存储（非敏感信息）。
  - `flutter_secure_storage`：存储密钥/凭证（确保在 Android manifest 中声明生物识别权限）。
  - `hive`：结构化离线缓存；在 `bootstrap.dart` 中注册适配器。
- 通过 `flutter pub outdated` 更新依赖，保守地升级版本；优先使用插入符约束 (^) 以获取补丁修复。
- 将环境特定的入口点存储在 `lib/main_<env>.dart`，并传递 `--dart-define=APP_ENV=<env>` 以保证密钥不在源代码中。

## 3. 代码质量 (`analysis_options.yaml`)
- 仓库继承 `package:flutter_lints/flutter.yaml` 并添加更严格的语言设置：
  - `strict-casts`、`strict-inference`、`strict-raw-types` 防止隐式运行时类型转换。
- 高优先级的 lint 规则：
  - **API 表面**：`type_annotate_public_apis`、`always_declare_return_types`、`use_super_parameters`。
  - **不可变性**：`prefer_const_constructors`、`prefer_final_fields`、`prefer_const_literals_to_create_immutables`。
  - **安全性**：`await_only_futures`、`use_build_context_synchronously`、`unawaited_futures`、`only_throw_errors`。
  - **风格**：`flutter_style_todos`、`directives_ordering`、`require_trailing_commas`、`prefer_single_quotes`。
- 已排除生成的文件（`*.g.dart`、`*.freezed.dart`、`*.mocks.dart`、`lib/core/l10n/generated/**`）。不要手动编辑排除的目录。
- 当 lint 规则与有效代码冲突时，优先考虑重构；仅在最小范围内使用 `// ignore` 并包含原因说明。

## 4. 测试与覆盖率
- 推送前运行 `flutter test --coverage`；CI 会将 `coverage/lcov.info` 上传到 Codecov（通过 `CODECOV_TOKEN` secret）。
- 为每个功能编写行为驱动测试：
  - Domain 层：纯 Dart 测试，不导入 Flutter 包。
  - Presentation 层：使用 `WidgetTester` 或 Riverpod `ProviderContainer` 进行 widget 测试。
- 通过排除生成文件降低覆盖率噪音（已在 `codecov.yml` 中处理）。

## 5. 架构与实现模式
- 维护已有的功能优先布局（`lib/features/<feature>/presentation|domain|data`）。
- `lib/core` 包含基础设施（配置、存储、网络、主题、通用 widget）。避免从 core 导入功能模块以防止循环依赖。
- 使用 Riverpod provider 进行依赖注入：
  - 在 `app/di.dart` 中注册核心服务。
  - 对于功能模块，在 `presentation/providers/...` 中创建 provider，在 `StateNotifier`/`AsyncNotifier` 中维护状态。
- 路由流经 `go_router`；添加功能特定的路由构建器，在 `app/router.dart` 中组合它们。
- 通过 `dio` 进行网络操作：在 `lib/core/network` 中集中化拦截器（日志、认证）。
- 使用共享的 `Result<T>` + `Failure` 类型处理错误，保持 UI 逻辑清晰。

## 6. UI 最佳实践
- 保持 widget **小而可复用**。将屏幕分解为 `Page` + 子 widget，使状态保留在 Riverpod provider 而非 `StatefulWidget` 内部。
- 优先使用**无状态 widget**；当状态不可避免时，使用 Riverpod（`StateNotifier`、`AsyncNotifier`）或 Flutter hooks，而非在 build 方法中提升逻辑。
- 从 `lib/core/theme` 通过 `Theme.of(context)` 或自定义主题扩展获取颜色、文本样式和间距。避免硬编码十六进制值或魔数。
- 复用基础组件（`lib/core/widgets`，如 `AppScaffold`、`ErrorView`）保持内边距和排版一致。在行内文档中说明新的共享 widget。
- 尊重响应式设计：用 `LayoutBuilder` 包装布局，依赖 `MediaQuery.size`，为平板/网页断点提供备选布局。
- 可访问性：确保点击目标 ≥48 逻辑像素，为图标提供 `Semantics` 标签，尊重 `MediaQuery.textScaleFactor`。
- 使用 `const` 构造函数和 `const` widget 确保确定性重建；依靠 lint 规则（`prefer_const_constructors`、`require_trailing_commas`）强制代码可读性。

## 7. 平台特定说明
- **Android**：
  - 确保 `android/app/src/main/AndroidManifest.xml` 为 `flutter_secure_storage` 声明 `<uses-permission android:name="android.permission.USE_BIOMETRIC" />`。
  - 除非 AGP 要求，否则坚持使用 Java 17（通过 `actions/setup-java@v4` 配置）。
  - 使用 `./gradlew lint` 验证 manifest 和权限问题；CI 构建已涵盖 `assemble{Debug,Profile,Release}`。
- **iOS**：
  - CI 运行 `flutter build ios --no-codesign`；本地开发应在 `pod install` 后打开 `ios/Runner.xcworkspace`。
  - 添加原生插件时保持 Podfile 同步；如 CocoaPods 反馈缺失 specs，运行 `pod repo update`。

## 8. 工作流检查清单
1. `flutter pub get`
2. 在遵循架构边界的前提下实现功能。
3. `dart format --set-exit-if-changed .`
4. `flutter analyze --fatal-infos`
5. `flutter gen-l10n`（当本地化内容改变时）
6. `flutter test --coverage`
7. 如工具或流程改变，更新文档（CLAUDE.md / AGENT.md / 本文件）。

遵循这些规范可使脚手架易于升级，并确保 CI 与本地开发的一致性。当平台工具演进（如新的 Flutter LTS 版本）时，需同步更新本文档和相关配置文件。

## 9. 参考文档
| 库 / 工具 | 官方文档 |
| --- | --- |
| Flutter SDK | https://docs.flutter.dev |
| Dart 语言 | https://dart.dev/guides |
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
| go_router + Riverpod 模式 | https://docs.flutter.dev/cookbook/navigation/router |

引入新依赖时添加新行，便于贡献者快速查询官方文档。
