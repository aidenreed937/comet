---
name: feature-workflow
description: Flutter Feature 开发工作流，从数据获取到 UI 展示的完整开发流程。当用户提到"创建功能"、"新建页面"、"开发 feature"、"添加模块"时使用此 skill。
---

# Feature 开发工作流

## 📌 快速参考

### 开发流程

```
Domain → Data → Provider → UI → Route → L10n → 质量检查
```

### 核心原则

| 原则 | 要求 |
|------|------|
| **无状态优先** | 使用 `ConsumerWidget`，不用 `StatefulWidget` |
| **状态放 Riverpod** | 所有状态（含 UI 状态）放 Provider |
| **UI 无硬编码** | 文本用 `l10n`，颜色用 `Theme`，间距用 `AppSpacing` |
| **逻辑与 UI 分离** | 验证、业务逻辑、数据转换放 `domain/` 或 `provider/`，UI 层只做展示和映射 |

### 目录结构

```
lib/features/<name>/
├── domain/           # 纯 Dart，无 Flutter 依赖
│   ├── entities/     # 业务实体（const, final, copyWith, ==）
│   ├── repositories/ # 仓库接口（返回 Result<T>）
│   └── validators/   # 字段验证器（可选）
├── data/
│   ├── datasources/  # 远程/本地数据源
│   ├── models/       # DTO（fromJson, toJson, toEntity）
│   └── repositories/ # 仓库实现（异常转 Failure）
└── presentation/
    ├── providers/    # 状态管理（sealed class 状态）
    ├── pages/        # 页面容器
    └── widgets/      # 视图组件
```

### 快速检查清单

- [ ] Domain: 实体 immutable + copyWith + == + hashCode
- [ ] Data: DTO 分离 + toEntity() + 异常转 Failure
- [ ] Provider: sealed class 状态 (Initial/Loading/Loaded/Error)
- [ ] UI: ConsumerWidget + 无硬编码 + switch 处理状态
- [ ] Route: `buildXxxRoutes()` 注册到 router.dart
- [ ] L10n: 添加到 arb 文件 + `flutter gen-l10n`
- [ ] 质量: `flutter analyze` + `dart format` + `flutter test`

---

## 🔄 开发阶段

### Phase 1: Domain 层

**目的**：定义业务实体、仓库接口、验证器（纯 Dart）

**产出物**：
- `entities/<name>.dart` - 业务实体
- `repositories/<name>_repository.dart` - 仓库接口
- `validators/<name>_validators.dart` - 字段验证器（可选）

**检查点**：
- [ ] const 构造函数 + final 字段
- [ ] copyWith + == + hashCode
- [ ] 仓库接口返回 `Result<T>`
- [ ] 无 `package:flutter` 导入

> 详细模板见 [附录 A: Domain 层模板](#附录-a-domain-层模板)

---

### Phase 2: Data 层

**目的**：实现数据源和仓库

**产出物**：
- `datasources/<name>_remote_data_source.dart`
- `models/<name>_dto.dart`
- `repositories/<name>_repository_impl.dart`

**检查点**：
- [ ] DTO 与 Entity 分离
- [ ] fromJson / toJson / toEntity
- [ ] 异常捕获 → `ErrorMapper.mapException()`

> 详细模板见 [附录 B: Data 层模板](#附录-b-data-层模板)

---

### Phase 3: Provider 层

**目的**：状态管理和业务逻辑

**产出物**：
- `providers/<name>_provider.dart` - 业务状态
- `providers/<name>_form_state.dart` - 表单 UI 状态（可选）

**检查点**：
- [ ] sealed class 状态定义
- [ ] Initial / Loading / Loaded / Error
- [ ] Controller 继承 Notifier
- [ ] 表单 UI 状态使用独立 Provider

> 详细模板见 [附录 C: Provider 层模板](#附录-c-provider-层模板)

---

### Phase 4: UI 层

**目的**：纯 UI 展示，无业务逻辑

**产出物**：
- `pages/<name>_page.dart` - 页面容器
- `widgets/<name>_view.dart` - 视图组件

**检查点**：
- [ ] **使用 ConsumerWidget**（不用 StatefulWidget）
- [ ] **状态来自 Provider**（含 UI 状态如 obscurePassword）
- [ ] 文本 → `context.l10n.xxx`
- [ ] 颜色 → `Theme.of(context)`
- [ ] 间距 → `AppSpacing.xx`
- [ ] switch 表达式处理状态
- [ ] 验证错误类型 → 国际化文本映射

> 详细模板见 [附录 D: UI 层模板](#附录-d-ui-层模板)

---

### Phase 5: 路由 & 国际化

**路由**：
```dart
// presentation/routes.dart
class XxxRoutes {
  static const xxx = '/xxx';
}

List<GoRoute> buildXxxRoutes() => [
  GoRoute(path: XxxRoutes.xxx, builder: (_, __) => const XxxPage()),
];

// 注册到 app/router.dart
routes: [...buildXxxRoutes()],
```

**国际化**：
```bash
# 1. 添加到 l10n/app_en.arb 和 l10n/app_zh.arb
# 2. 生成
flutter gen-l10n
```

---

### Phase 6: 质量检查

```bash
flutter analyze lib/features/<name>/         # 代码分析
dart format lib/features/<name>/             # 格式化
flutter test test/features/<name>/           # 测试
```

> 详细清单见 [附录 E: 质量检查清单](#附录-e-质量检查清单)

---

## 🚫 常见错误示例

```dart
// ❌ 错误：StatefulWidget 管理 UI 状态
class LoginForm extends ConsumerStatefulWidget { ... }
class _LoginFormState extends ConsumerState<LoginForm> {
  bool _obscurePassword = true;  // 应放 Provider
}

// ❌ 错误：验证逻辑在 UI 层
validator: (value) {
  if (value == null || value.isEmpty) return '请输入';
  final regex = RegExp(r'...');
  if (!regex.hasMatch(value)) return '格式错误';
}

// ❌ 错误：硬编码
Text('用户列表')
Container(color: Color(0xFF2196F3))
SizedBox(height: 24)
```

```dart
// ✅ 正确：ConsumerWidget + Provider 状态
class LoginForm extends ConsumerWidget {
  Widget build(context, ref) {
    final formState = ref.watch(loginFormProvider);
    // formState.obscurePassword 来自 Provider
  }
}

// ✅ 正确：验证逻辑在 Domain 层
validator: (value) {
  final error = AuthValidators.validateEmail(value);
  return switch (error) {
    EmailValidationError.required => l10n.emailRequired,
    EmailValidationError.invalidFormat => l10n.emailInvalid,
    null => null,
  };
}

// ✅ 正确：使用主题和常量
Text(context.l10n.userListTitle)
Container(color: Theme.of(context).colorScheme.primary)
SizedBox(height: AppSpacing.lg)
```

---

# 📎 附录

## 附录 A: Domain 层模板

### 实体模板

```dart
// domain/entities/user.dart
class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  User copyWith({String? id, String? name, String? email}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
```

### 仓库接口模板

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Result<List<User>>> getUsers();
  Future<Result<User>> getUserById(String id);
}
```

### 验证器模板

```dart
// domain/validators/auth_validators.dart
class AuthValidators {
  AuthValidators._();

  static const int minPasswordLength = 6;
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static EmailValidationError? validateEmail(String? value) {
    if (value == null || value.isEmpty) return EmailValidationError.required;
    if (!_emailRegex.hasMatch(value)) return EmailValidationError.invalidFormat;
    return null;
  }

  static PasswordValidationError? validatePassword(String? value) {
    if (value == null || value.isEmpty) return PasswordValidationError.required;
    if (value.length < minPasswordLength) return PasswordValidationError.tooShort;
    return null;
  }
}

enum EmailValidationError { required, invalidFormat }
enum PasswordValidationError { required, tooShort }
```

---

## 附录 B: Data 层模板

### 远程数据源模板

```dart
// data/datasources/user_remote_data_source.dart
abstract class UserRemoteDataSource {
  Future<List<UserDto>> getUsers();
  Future<UserDto> getUserById(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<List<UserDto>> getUsers() async {
    final response = await dioClient.get('/users');
    return (response.data as List).map((json) => UserDto.fromJson(json)).toList();
  }

  @override
  Future<UserDto> getUserById(String id) async {
    final response = await dioClient.get('/users/$id');
    return UserDto.fromJson(response.data);
  }
}
```

### DTO 模板

```dart
// data/models/user_dto.dart
class UserDto {
  UserDto({required this.id, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  final String id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
  User toEntity() => User(id: id, name: name, email: email);
}
```

### 仓库实现模板

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.remoteDataSource});
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      final dtos = await remoteDataSource.getUsers();
      return Success(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Err(ErrorMapper.mapException(e));
    }
  }
}
```

---

## 附录 C: Provider 层模板

### 业务状态 Provider

```dart
// presentation/providers/user_provider.dart

// 状态定义
sealed class UserListState {
  const UserListState();
}
class UserListInitial extends UserListState { const UserListInitial(); }
class UserListLoading extends UserListState { const UserListLoading(); }
class UserListLoaded extends UserListState {
  const UserListLoaded(this.users);
  final List<User> users;
}
class UserListError extends UserListState {
  const UserListError(this.message);
  final String message;
}

// Controller
final userListControllerProvider =
    NotifierProvider<UserListController, UserListState>(UserListController.new);

class UserListController extends Notifier<UserListState> {
  @override
  UserListState build() {
    Future.microtask(loadUsers);
    return const UserListLoading();
  }

  Future<void> loadUsers() async {
    state = const UserListLoading();
    final result = await ref.read(userRepositoryProvider).getUsers();
    result.when(
      success: (users) => state = UserListLoaded(users),
      failure: (failure) => state = UserListError(failure.message),
    );
  }
}
```

### 表单状态 Provider

```dart
// presentation/providers/login_form_state.dart
class LoginFormState {
  const LoginFormState({this.email = '', this.password = '', this.obscurePassword = true});
  final String email;
  final String password;
  final bool obscurePassword;

  LoginFormState copyWith({String? email, String? password, bool? obscurePassword}) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

class LoginFormNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void togglePasswordVisibility() => state = state.copyWith(obscurePassword: !state.obscurePassword);
}

final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(LoginFormNotifier.new);
```

---

## 附录 D: UI 层模板

### Page 模板

```dart
// presentation/pages/user_list_page.dart
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text(context.l10n.userListTitle)),
      body: const UserListView(),
    );
  }
}
```

### View 模板（处理状态）

```dart
// presentation/widgets/user_list_view.dart
class UserListView extends ConsumerWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListControllerProvider);

    return switch (state) {
      UserListInitial() => const SizedBox.shrink(),
      UserListLoading() => const LoadingIndicator(),
      UserListError(:final message) => ErrorView(
          message: message,
          onRetry: () => ref.read(userListControllerProvider.notifier).loadUsers(),
        ),
      UserListLoaded(:final users) => users.isEmpty
          ? Center(child: Text(context.l10n.emptyList))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => UserListItem(user: users[index]),
            ),
    };
  }
}
```

### 表单组件模板（无状态）

```dart
// presentation/widgets/login_form.dart
class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);  // 状态来自 Provider
    final isLoading = ref.watch(loginProvider) is LoginLoading;

    return Column(
      children: [
        _EmailField(
          value: formState.email,
          enabled: !isLoading,
          onChanged: ref.read(loginFormProvider.notifier).setEmail,
        ),
        const SizedBox(height: AppSpacing.md),
        _PasswordField(
          value: formState.password,
          obscureText: formState.obscurePassword,  // UI 状态也在 Provider
          onToggleVisibility: ref.read(loginFormProvider.notifier).togglePasswordVisibility,
          ...
        ),
      ],
    );
  }
}

// 叶子组件：验证错误类型 → 国际化文本映射
class _EmailField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = value.isEmpty ? null : AuthValidators.validateEmail(value);
    return TextFormField(
      decoration: InputDecoration(
        errorText: switch (error) {
          EmailValidationError.required => context.l10n.emailRequired,
          EmailValidationError.invalidFormat => context.l10n.emailInvalid,
          null => null,
        },
      ),
    );
  }
}
```

---

## 附录 E: 质量检查清单

### 静态分析

| 检查项 | 命令 |
|--------|------|
| 无 analyze 错误 | `flutter analyze` |
| 无 analyze 警告 | `flutter analyze --fatal-infos` |
| 代码格式正确 | `dart format --set-exit-if-changed .` |

### 测试覆盖

| 检查项 |
|--------|
| Domain 层单元测试 |
| Provider/Controller 测试 |
| 测试全部通过 |

### 安全检查

| 检查项 |
|--------|
| 无硬编码 API 密钥/Token |
| 敏感数据使用 SecureStorage |
| 网络请求使用 HTTPS |

### 性能检查

| 检查项 | 标准 |
|--------|------|
| 单文件行数 | < 500 行 |
| Widget 嵌套层级 | < 10 层 |
| 列表使用 ListView.builder | - |
| 使用 const 构造函数 | - |

---

## 🔧 命令速查

```bash
# 开发
flutter pub get                    # 获取依赖
flutter gen-l10n                   # 生成国际化

# 质量检查
flutter analyze                    # 代码分析
dart format .                      # 格式化
flutter test                       # 测试

# 依赖
flutter pub outdated               # 检查过期依赖
```
