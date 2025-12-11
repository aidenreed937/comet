# Flutter 通用脚手架设计方案（非业务）

> 目标：为团队提供一套可复用的 Flutter 项目基础骨架与脚手架命令规范，聚焦基础设施与工程实践，而非具体业务。

## 1. 设计目标

- 非业务化：只提供工程层面的约定（目录、状态管理、网络、路由、配置、国际化等），不耦合任何业务领域模型。
- 一致性：不同项目/仓库按照统一的模板与命名规范，降低迁移与协作成本。
- 可扩展：通过「feature-first + 分层」结构，以及脚手架命令生成代码，支持项目演进。
- 易测试：鼓励分层、依赖倒置、接口抽象，便于单元测试与集成测试。
- 多环境：支持多环境（dev/staging/prod）与多平台（iOS/Android/Web/桌面）的配置切换。
- 可插拔：核心架构与选型尽量模块化，可替换状态管理、路由、网络实现。

## 2. 技术与工具选型（可替换，但脚手架默认如此）

- Flutter：最新 stable 通道。（当前示例环境：Flutter 3.38.3）
- Dart：>= 3.0。（当前示例环境：Dart 3.10.1）
- 状态管理：`flutter_riverpod`（推荐），脚手架保留接口以便将来替换为 BLoC/GetX 等。
- 路由：`go_router`。
- 网络请求：`dio`。
- 本地存储：`shared_preferences` 为简单配置 / flag，`hive` 或 `isar` 用于结构化缓存（按需启用）。
- 依赖注入（可选）：基于 Riverpod + provider family 实现轻量 DI；如有需要可接入 `get_it`。
- 国际化：Flutter 官方 `flutter gen-l10n`。
- 代码规范：`flutter_lints` + 自定义 `analysis_options.yaml`（具体规则见第 11 节）。

### 2.1 依赖版本与兼容性建议（基于 Flutter 3.38.3 / Dart 3.10.1）

以下为截至 2025-12-11 的推荐依赖版本（均为稳定版），并已确认其 Dart SDK 最低版本要求不高于 3.10.1：

- `flutter_riverpod: ^3.0.3`（Dart >= 3.7）
- `go_router: ^17.0.1`（Dart >= 3.9）
- `dio: ^5.9.0`（Dart >= 2.18）
- `shared_preferences: ^2.5.4`（Dart >= 3.9）
- `flutter_secure_storage: ^10.0.0`（Dart >= 3.3）
- 结构化存储（任选一类为主，不必两种都用）：
  - `hive: ^2.2.3` / `hive_flutter: ^1.1.0`
  - 或 `isar: ^3.1.0+1` / `isar_flutter_libs: ^3.1.0+1`（如需 codegen 再配 `isar_generator: ^3.1.0+1`）
- 开发工具与规范：
  - `flutter_lints: ^5.0.0`

示例 `pubspec.yaml` 片段：

```yaml
environment:
  sdk: '>=3.7.0 <4.0.0' # 如选择 flutter_riverpod 3.0.3，建议至少 3.7；当前 Dart 3.10.1 已满足

dependencies:
  flutter:
    sdk: flutter

  flutter_riverpod: ^3.0.3
  go_router: ^17.0.1
  dio: ^5.9.0
  shared_preferences: ^2.5.4
  flutter_secure_storage: ^10.0.0

  # 结构化缓存：二选一
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  # 或使用 Isar：
  # isar: ^3.1.0+1
  # isar_flutter_libs: ^3.1.0+1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  # 如使用 Isar + 代码生成：
  # isar_generator: ^3.1.0+1
```

说明：
- 你的环境（Flutter 3.38.3 / Dart 3.10.1）高于以上所有依赖的最低版本要求，兼容性没有问题。
- 建议定期运行 `flutter pub outdated` 检查可升级的稳定版本，并在确认兼容后更新。  

## 3. 目录结构设计（项目骨架）

### 3.1 顶层目录

```text
project_root/
  lib/
  test/
  assets/
  l10n/
  .vscode/ or .idea/
  analysis_options.yaml
  pubspec.yaml
  README.md
  comet.yaml              # 脚手架配置（工程约定）
```

说明：
- `comet.yaml`：脚手架工具自己的配置文件，用于记录状态管理类型、路由实现、是否启用某些模块等。

### 3.2 lib 目录结构（核心）

```text
lib/
  app/
    app.dart              # 根 Widget，注入主题、路由、全局 provider 等
    bootstrap.dart        # 引导应用（runApp，环境初始化，依赖注入等）
    di.dart               # 跨 feature 核心服务 Provider 收口/依赖注入入口
    router.dart           # GoRouter 配置与路由常量

  core/                   # 无业务的基础设施与通用模块
    config/
      env.dart            # Env 抽象
      env_development.dart
      env_staging.dart
      env_production.dart
      app_config.dart     # 汇总读取 Env / dart-define

    error/
      failure.dart        # 域无关 Failure 模型
      error_mapper.dart   # 将异常映射为 Failure
      error_reporter.dart # 上报与记录（Crashlytics/Sentry 等）

    network/
      dio_client.dart
      interceptors/
        auth_interceptor.dart
        logging_interceptor.dart

    storage/
      key_value_storage.dart    # 对 shared_preferences 的封装
      secure_storage.dart       # 可选：对 flutter_secure_storage 的封装

    theme/
      app_theme.dart
      color_schemes.dart
      text_themes.dart

    l10n/
      l10n.dart           # 对 gen_l10n 的二次封装

    utils/
      logger.dart
      date_time_utils.dart
      result.dart         # 通用 Result 类型（Success/Failure）
      extensions/
        iterable_extensions.dart
        string_extensions.dart

    widgets/              # 无业务的可复用 UI 组件
      app_scaffold.dart
      loading_indicator.dart
      error_view.dart
      primary_button.dart

  features/               # Feature-first 的业务模块目录（脚手架只放示例）
    counter/
      presentation/
        pages/
          counter_page.dart
        widgets/
          counter_view.dart
        providers/
          counter_provider.dart  # Riverpod 状态
      domain/
        entities/
          counter.dart
        repositories/
          counter_repository.dart
      data/
        datasources/
          counter_local_data_source.dart
        repositories/
          counter_repository_impl.dart

  main_development.dart   # dev 环境入口
  main_staging.dart       # staging 环境入口
  main_production.dart    # prod 环境入口
```

### 3.3 test 目录结构（建议）

```text
test/
  core/
  features/
    counter/
      presentation/
      domain/
      data/
```

脚手架在生成 feature 时，同步生成对应的 `test/features/<feature_name>/...` 目录和基础测试文件。

## 4. 分层与职责划分

### 4.1 app 层

- 作为组合根（Composition Root），负责：
  - 读取 `Env` / 配置，初始化依赖。
  - 初始化日志、错误上报、网络客户端等基础设施。
  - 配置 `ProviderScope`（Riverpod）和 `MaterialApp.router`。
  - 暴露统一 `runAppWithBootstrap()` 方法，入口文件只做环境选择。

关于 `app/di.dart`：
- 在基于 Riverpod 的架构中，`ProviderScope` 本身扮演依赖注入容器角色。
- `di.dart` 的职责是**集中注册跨多个 feature 共享的、与业务无关的核心服务 Provider**（如 `AuthService`, `AnalyticsService`, `CrashReportingService` 等），并作为这些 Provider 的统一收口：
  - 便于在一个地方查看/管理所有核心服务。
  - 便于在测试中对这些 Provider 进行覆盖（override）。
- 各 feature 自己的业务 Provider 保持在各自的 `features/<feature>/presentation/providers` 中，不放入 `di.dart`。

### 4.2 core 层

- 放置完全无业务的、可跨项目复用的基础设施：
  - 网络层封装：统一 baseUrl、拦截器、错误转换。
  - 存储层封装：key-value / secure storage / local db 抽象。
  - 主题、颜色、字体、基础 Widget。
  - 日志、错误映射、结果模型、工具及扩展方法。
- 原则：
  - `core` 不引用任何 `features`。只提供通用能力。
  - `core/services` 目录用于放置 **跨多个 feature 共享的服务**，例如 `AuthService`, `AnalyticsService`, `RemoteConfigService` 等：
    - 封装第三方 SDK（如 Firebase、Sentry、Analytics）。
    - 自身维护状态或生命周期（如登录态、配置缓存）。
    - 为多个 feature 提供统一能力。
  - 不涉及生命周期或跨 feature 能力的简单工具函数放在 `core/utils` 中，而不是 `core/services`。

### 4.3 features 层

- Feature-first 组织方式：每个 feature 有完整的 presentation/domain/data 三层。
- 约定：
  - `presentation`：页面、局部 Widget、Riverpod providers（ViewModel/Controller）。
  - `domain`：实体、UseCase、仓库接口，**禁止依赖 `package:flutter/...`**，保持纯 Dart，便于测试与复用。
  - `data`：网络/本地数据源实现、仓库实现。
- Feature 间通信策略：
  - 推荐通过 `core/services`（如 `AuthService`）或共享的 `domain` 层仓库接口进行数据交互。
  - 禁止 `feature A` 直接依赖 `feature B` 的 Provider 或 Widget，避免强耦合和循环依赖。
- 脚手架仅提供示例 `counter` feature，用于演示约定；实际业务由业务项目按此结构扩展。

## 5. 状态管理约定（以 Riverpod 为例）

### 5.1 命名规范

- `xxxProvider`：普通只读 Provider（如配置、常量）。
- `xxxController`：`StateNotifier` 或 `Notifier`，用于处理业务逻辑与状态变更。
- `xxxRepository`：数据访问抽象/实现。

### 5.2 示例

```dart
// features/counter/presentation/providers/counter_provider.dart
final counterControllerProvider =
    StateNotifierProvider<CounterController, int>((ref) {
  return CounterController();
});
```

脚手架在生成 feature 时，可以选择：
- 生成基础的 `Controller` 与 Provider 模板。
- 允许通过参数选择是否包含 `domain/data` 层（纯 UI feature 可以只生成 presentation）。

## 6. 路由与导航约定

- 使用 `go_router`，单一 `GoRouter` 实例定义在 `app/router.dart`。
- 每个 feature 暴露自己的路由配置片段，由 `app/router.dart` 汇总。

示例约定：

```dart
// features/counter/presentation/routes.dart
class CounterRoutes {
  static const counter = '/counter';
}

List<GoRoute> buildCounterRoutes() => [
      GoRoute(
        path: CounterRoutes.counter,
        builder: (context, state) => const CounterPage(),
      ),
    ];
```

```dart
// app/router.dart (片段)
final appRouter = GoRouter(
  routes: [
    ...buildCounterRoutes(),
    // ...其他 feature routes
  ],
);
```

脚手架生成 feature 时，如果指定了 `--route`，自动为该 feature 生成 `routes.dart` 并在 `app/router.dart` 中插入注册代码（可通过注释占位符或代码生成实现）。  
约定与自动化的关系：
- 文档中对路由组织方式的说明属于“架构约定”，而实际的路由声明/注册工作应尽量由 `comet` CLI 自动完成。
- 推荐通过 `comet create feature --route ...` 来新增路由，而不是手动编辑 `app/router.dart`，以减少人为疏漏并保证所有项目的一致性。

## 7. 环境与配置管理

- 通过多入口文件 + `--dart-define` 实现环境切换：
  - `main_development.dart` / `main_staging.dart` / `main_production.dart`。
- `Env` 抽象负责读取环境变量：
  - API baseUrl、开关配置、Feature Flag 等。
- 脚手架约定在 `comet.yaml` 中声明可选环境，以及 dart-define 的 key 名称：

```yaml
# comet.yaml（envs 片段，完整示例见 10.1 节）
envs:
  - name: development
    flavor: dev
    dart_define:
      APP_ENV: development
  - name: staging
    flavor: stg
    dart_define:
      APP_ENV: staging
  - name: production
    flavor: prod
    dart_define:
      APP_ENV: production
```

脚手架命令可根据该配置生成对应的 `run` 命令提示或脚本。

## 8. 错误处理与日志规范

- 引入统一的 `Failure` 模型，对网络错误/解析错误/业务错误等进行归一化。
- 在 `error_mapper.dart` 中实现从 `Exception` 到 `Failure` 的映射。
- UI 层尽量只依赖 `Failure` 或 `Result<T>`，不关心底层异常类型。
- `logger.dart` 统一提供：
  - 控制台打印（dev 环境）。
  - 远程上报（prod 环境可接入 Crashlytics/Sentry）。
- 脚手架提供基础实现，业务项目可以通过配置替换具体实现。

## 9. 国际化与资源管理

- 默认开启 Flutter 官方 l10n：
  - `l10n/arb` 存放文案。
  - `l10n.yaml` 管理生成规则。
- `core/l10n/l10n.dart` 统一封装 `AppLocalizations` 访问入口。
- `assets/` 目录下按类型划分子目录（如 `images/`, `icons/`, `fonts/`），在 `pubspec.yaml` 中声明。

脚手架可以提供：
- 初始化 `l10n.yaml` 和示例 `app_en.arb`, `app_zh.arb`。
- 在 `README` 中生成国际化使用示例。

## 10. 脚手架命令设计（CLI 约定）

假设脚手架工具名为 `comet`（可实现为 Dart CLI 或集成 Mason 等）。

### 10.1 全局配置

- `comet.yaml` 是脚手架的单一配置源，记录：
  - 工程名、组织 ID。
  - 状态管理方案（如：riverpod/bloc）。
  - 路由方案（如：go_router）。
  - 是否启用网络模块、本地存储模块等。
  - 核心依赖集及版本（如 `flutter_riverpod`, `go_router`, `dio` 等），便于项目统一升级。

一个较完整的 `comet.yaml` 示例（可根据项目实际精简或扩展）：

```yaml
name: my_app
org: com.example

state_management: riverpod
router: go_router

envs:
  - name: development
    flavor: dev
    dart_define:
      APP_ENV: development
  - name: staging
    flavor: stg
    dart_define:
      APP_ENV: staging
  - name: production
    flavor: prod
    dart_define:
      APP_ENV: production

dependencies:
  core:
    flutter_riverpod: ^3.0.3
    go_router: ^17.0.1
    dio: ^5.9.0
    shared_preferences: ^2.5.4
    flutter_secure_storage: ^10.0.0
```

### 10.2 创建应用

```bash
comet create app <app_name> \
  --org com.example \
  --state-management riverpod \
  --router go_router \
  --enable-network \
  --enable-storage \
  --with-l10n \
  [--with-ci]
```

行为：
- 基于 `flutter create` 生成基础工程。
- 替换/补充项目目录为上述骨架结构。
- 填充 `comet.yaml` 与基础 `Env` / `router` / `theme` 等文件。
- 若指定 `--with-ci`，生成基础 CI 配置（如 `.github/workflows/ci.yml`），预设 `flutter analyze`、测试与构建步骤，可由团队按需调整。

### 10.3 创建 Feature

```bash
comet create feature <feature_name> \
  [--route /path] \
  [--no-domain] \
  [--no-data]
```

约定：
- 在 `lib/features/<feature_name>/` 下生成：

```text
features/<feature_name>/
  presentation/
    pages/<feature_name>_page.dart
    widgets/<feature_name>_view.dart
    providers/<feature_name>_controller.dart
  domain/
    entities/<feature_name>.dart
    repositories/<feature_name>_repository.dart
  data/
    datasources/<feature_name>_remote_data_source.dart
    repositories/<feature_name>_repository_impl.dart
```

- 如果指定了 `--route`：
  - 生成 `routes.dart`，并为 `<feature_name>_page` 配置 path。
  - 在 `app/router.dart` 中自动插入路由注册（通过占位注释或代码生成）。
- 如果指定 `--no-domain` / `--no-data`：
  - 不生成对应目录与文件，更适合 UI-only feature。
- 在 `test/features/<feature_name>/` 下生成基础测试文件，默认引入 `mocktail` 和 `riverpod_test`，提供典型用例（如 Controller 状态流转、Repository 行为）作为模板，降低编写测试门槛。

### 10.4 创建 Service（跨切面能力）

```bash
comet create service <service_name>
```

用途：
- 在 `core/` 下生成对应服务骨架，例如 `analytics`, `crash_reporting`, `remote_config` 等。

示例结构：

```text
core/services/
  analytics/
    analytics_service.dart
    analytics_event.dart
```

脚手架可选择：
- 自动在 `app/di.dart` 中注册该服务。推荐通过 `comet create service` 命令新增服务，而不是直接手工修改 `di.dart`，由 CLI 来保证服务注册的一致性和完整性。

### 10.5 辅助命令

- `comet lint`：运行 `flutter analyze` + 自定义静态检查，要求在本地与 CI 中保持一致，作为合并前的强制校验。
- `comet format`：运行 `dart format`。
- `comet doctor`：检查项目是否符合脚手架约定（目录、配置、依赖版本等）。
- `comet upgrade-core`：根据 `comet.yaml` 中的核心依赖集信息，统一升级项目中的核心依赖版本，并给出变更提示，降低多项目依赖漂移。

## 11. 命名与代码风格约定

- 目录与文件：`snake_case`，例如 `user_profile_page.dart`, `user_profile_view.dart`, `user_profile_controller.dart`。
- Dart 类名：`PascalCase`，例如 `UserProfilePage`, `UserProfileController`。
- 页面/视图：
  - 页面：`<FeatureName>Page`（文件：`<feature_name>_page.dart`）。
  - 纯视图组件：`<FeatureName>View`（文件：`<feature_name>_view.dart`）。
- Provider/Controller：`<FeatureName>Controller`, `<FeatureName>State`（文件：`<feature_name>_controller.dart`）。
- Service：`<Name>Service`（文件：`<name>_service.dart`），如 `AuthService`。
- Repository：`<EntityName>Repository` / `<EntityName>RepositoryImpl`（文件：`<entity_name>_repository.dart` / `<entity_name>_repository_impl.dart`）。
- 常量：`kConstantName`。
- 测试文件：与被测文件同名 + `_test` 后缀，例如 `user_profile_controller_test.dart`。

代码质量与风格：
- `analysis_options.yaml` 基于 `flutter_lints`，并补充更严格的规则（可按团队选择是否引入 `very_good_analysis` 等规则集）。
- 要求在 CI 与本地统一执行 `flutter analyze` 与 `dart format`，保证风格一致，优先发现潜在问题。

### 11.1 推荐的工程质量保障实践

在上述命名与代码风格约定之上，脚手架推荐配套采用以下工程实践，以保障中大型项目的可维护性和演进质量：

- 类型安全路由：
  - 结合 `go_router_builder` 等工具，通过代码生成获得类型安全的路由 API，而不是手写字符串 path。
  - 例如将 `context.go('/users/123')` 演进为 `context.goUser(id: 123)`，在编译期发现路径和参数错误。
- 提交规范与变更管理：
  - 采用 Conventional Commits 规范组织 `git commit` 信息，便于自动生成 `CHANGELOG` 和进行语义化版本管理。
  - 可在项目中引入 `commitlint` 等工具，使规范在 CI 中得到强制执行。
- 统一格式化与预提交钩子：
  - 使用 `pre-commit`/`husky` 等工具，在提交前自动执行 `dart format`、`flutter analyze` 等命令，保证所有提交的代码风格与静态检查一致。
- 测试覆盖率门禁：
  - 在 CI 中集成覆盖率统计（如 `lcov`），并配置最低覆盖率门槛（可由团队根据阶段逐步提高，例如从 50% → 70% → 80%）。
  - 当新代码导致覆盖率低于门槛时，CI 构建失败，促使团队持续关注测试质量。

脚手架本身不强制所有项目一次性启用上述所有措施，但会在模板与文档层面提供示例配置，鼓励团队在合适的阶段逐步接入。

## 12. 后续扩展与演进方向

- 支持多种状态管理模板（riverpod/bloc），通过 `comet.yaml` 选择。
- 集成 Mason 作为模板引擎，降低模板维护成本。
- 扩展常用集成能力脚手架（认证、深度链接、推送、文件上传等），但依旧保持「非业务」。
- 提供 VSCode/Android Studio 插件，直接在 IDE 中调用 `comet` 命令。
 - 在此基础上，脚手架可逐步提供更多针对上述 11.1 节推荐实践的“开箱即用”模板（如 CI 配置片段、pre-commit 示例等），方便项目按需启用。

---

本设计文档聚焦在 Flutter 工程层面的架构与脚手架命令约定，后续可以根据团队反馈与具体项目实践不断调整 `comet.yaml` 配置和模板细节。对于你当前的仓库，建议以此为蓝本先用 `comet create app` 设计目标结构，再逐步实现 CLI 工具本身。
