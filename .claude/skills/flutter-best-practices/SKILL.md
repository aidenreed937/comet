---
name: flutter-best-practices
description: Flutter 开发最佳实践指南，涵盖架构、依赖管理、UI 开发、平台配置。当用户提到"最佳实践"、"架构"、"Riverpod"、"GoRouter"、"Dio"、"主题"、"响应式"、"无障碍"时使用此 skill。
---

# Flutter Best Practices

确保 Flutter 代码遵循项目架构约定和最佳实践。

## 快速参考

### 核心原则

| 原则 | 说明 |
|------|------|
| **无状态优先** | 使用 `ConsumerWidget`，不用 `StatefulWidget` |
| **状态放 Riverpod** | 所有状态（含 UI 状态）放 Provider |
| **UI 无硬编码** | 文本用 `l10n`，颜色用 `Theme`，间距用 `AppSpacing` |
| **逻辑与 UI 分离** | 验证、业务逻辑、数据转换放 `domain/` 或 `provider/` |

### 目录结构

```
lib/
├── app/                    # 组合根（di.dart, router.dart）
├── core/                   # 基础设施（不导入 features）
└── features/<name>/
    ├── domain/             # 纯 Dart（entities, repositories, validators）
    ├── data/               # 数据源 + 实现
    └── presentation/       # UI + Provider（pages, widgets, providers）
```

### 层级规则

| 规则 | 说明 |
|------|------|
| `core/` 禁止导入 `features/` | 保持基础设施独立 |
| `domain/` 禁止导入 Flutter | 纯 Dart，便于测试 |

### 核心依赖

| 功能 | 库 |
|------|-----|
| 状态管理 | `flutter_riverpod` 3.x |
| 路由 | `go_router` 17.x |
| 网络 | `dio` 5.x |
| 轻量存储 | `shared_preferences` |
| 安全存储 | `flutter_secure_storage` |

### 开发流程

```bash
flutter pub get
# ... 实现功能 ...
dart format .
flutter analyze
flutter gen-l10n    # 如有国际化变更
flutter test
```

---

## UI 最佳实践

### Widget 设计

| 原则 | 说明 |
|------|------|
| 小而可组合 | 拆分 Page + 叶子组件 |
| const 构造 | 减少不必要的 rebuild |
| 主题引用 | `Theme.of(context)` 而非硬编码 |

---

## 常见错误示例

### 状态管理

```dart
// ❌ StatefulWidget 管理 UI 状态
class LoginForm extends ConsumerStatefulWidget { ... }
class _LoginFormState extends ConsumerState<LoginForm> {
  bool _obscurePassword = true;  // 状态在 StatefulWidget
}

// ✅ Provider 管理 UI 状态
class LoginForm extends ConsumerWidget {
  Widget build(context, ref) {
    final formState = ref.watch(loginFormProvider);
    // formState.obscurePassword 来自 Provider
  }
}
```

### 验证逻辑

```dart
// ❌ 验证逻辑在 UI 层
validator: (value) {
  if (value == null || value.isEmpty) return '请输入邮箱';
  final regex = RegExp(r'...');
  if (!regex.hasMatch(value)) return '格式错误';
}

// ✅ 验证逻辑在 Domain 层
validator: (value) {
  final error = AuthValidators.validateEmail(value);
  return switch (error) {
    EmailValidationError.required => l10n.emailRequired,
    EmailValidationError.invalidFormat => l10n.emailInvalid,
    null => null,
  };
}
```

### 样式规范

```dart
// ❌ 硬编码
final color = Color(0xFF2196F3);
final textStyle = TextStyle(fontSize: 22);
SizedBox(height: 24);

// ✅ 主题 + 常量
final color = Theme.of(context).colorScheme.primary;
final textStyle = Theme.of(context).textTheme.titleLarge;
SizedBox(height: AppSpacing.lg);
```

---

## 架构约定

### 依赖注入

```dart
// app/di.dart - 核心服务
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

// features/xxx/presentation/providers/ - 功能 Provider
final xxxControllerProvider = NotifierProvider<XxxController, XxxState>(...);
```

### 路由配置

```dart
// features/xxx/presentation/routes.dart
class XxxRoutes {
  static const xxx = '/xxx';
}

List<GoRoute> buildXxxRoutes() => [
  GoRoute(path: XxxRoutes.xxx, builder: (_, __) => const XxxPage()),
];

// app/router.dart
routes: [...buildXxxRoutes(), ...buildYyyRoutes()],
```

### 错误处理

```dart
// 使用 Result<T>
Future<Result<User>> getUser(String id) async {
  try {
    final response = await dio.get('/users/$id');
    return Success(User.fromJson(response.data));
  } on DioException catch (e) {
    return Err(NetworkFailure(e.message));
  }
}

// UI 层处理
result.when(
  success: (user) => showUser(user),
  failure: (f) => showError(f.message),
);
```

---

## 附录

### A. 环境与工具

| 配置项 | 要求 |
|--------|------|
| Flutter channel | stable |
| Dart SDK | `>=3.7.0 <4.0.0` |
| 国际化 | `flutter gen-l10n` |
| 清理构建 | `flutter clean && rm -rf build/` |

### B. 响应式布局

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return MobileLayout();
  },
);
```

### C. 无障碍

| 要求 | 实现 |
|------|------|
| 点击区域 | ≥48 逻辑像素 |
| 图标语义 | 添加 `Semantics` 标签 |
| 字体缩放 | 尊重 `MediaQuery.textScaleFactor` |

### D. 平台配置

**Android**:
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

**iOS**:
```bash
cd ios && pod install && open Runner.xcworkspace
```

### E. 参考文档

| 库 | 文档 |
|---|------|
| Flutter SDK | https://docs.flutter.dev |
| flutter_riverpod | https://riverpod.dev |
| go_router | https://pub.dev/packages/go_router |
| dio | https://pub.dev/packages/dio |
