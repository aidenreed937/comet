# Flutter MCP 最佳实践

本文档总结使用 Flutter MCP 工具进行快速开发、验证和调试的最佳实践。

## 目录

- [快速运行验证](#快速运行验证)
- [检查页面 UI 和功能](#检查页面-ui-和功能)
- [修复错误流程](#修复错误流程)
- [避免大响应问题](#避免大响应问题)
- [常用命令组合](#常用命令组合)

## 快速运行验证

### 1. 启动应用的标准流程

```bash
# 步骤 1: 列出可用设备
mcp__dart__list_devices

# 步骤 2: 启动应用到指定设备
mcp__dart__launch_app
  device: "emulator-5554"  # 或 "linux" 等
  root: "/path/to/project"
  target: "lib/main_development.dart"

# 步骤 3: 连接到 Dart Tooling Daemon
mcp__dart__connect_dart_tooling_daemon
  uri: "ws://127.0.0.1:xxxxx/yyy="  # 从 launch_app 返回的 dtdUri
```

### 2. 验证应用状态

```bash
# 检查运行时错误
mcp__dart__get_runtime_errors

# 查看应用日志（限制行数避免过大）
mcp__dart__get_app_logs
  pid: <process_id>
  maxLines: 50  # 推荐 50-100 行
```

## 检查页面 UI 和功能

### 1. 快速检查 Widget 树（推荐）

```bash
# ✅ 推荐：只获取用户创建的 Widget
mcp__dart__get_widget_tree
  summaryOnly: true

# ⚠️ 避免：完整树会导致 Large MCP response
# mcp__dart__get_widget_tree
#   summaryOnly: false
```

**关键经验**：
- `summaryOnly: true` - 仅显示用户代码创建的 Widget，响应小且清晰
- `summaryOnly: false` - 包含所有 Flutter 框架 Widget，响应可达 10万+ tokens

### 2. 使用截图快速定位 UI 问题

```bash
# 截取当前屏幕
adb exec-out screencap -p > /tmp/screen.png

# 读取截图查看实际 UI
Read tool: /tmp/screen.png
```

**优势**：
- 直观看到实际渲染效果
- 快速发现布局问题
- 验证文本、颜色、图标是否正确

### 3. 检查特定 Widget

```bash
# 获取选中的 Widget
mcp__dart__get_selected_widget

# 获取活动位置（编辑器光标位置）
mcp__dart__get_active_location
```

## 修复错误流程

### 1. 代码分析

```bash
# 分析特定文件或目录
mcp__dart__analyze_files
  roots: [
    {
      paths: ["lib/features/auth", "test/features/auth"],
      root: "file:///path/to/project"
    }
  ]
```

### 2. 应用代码更改

```bash
# 热重载（保持应用状态）
mcp__dart__hot_reload
  clearRuntimeErrors: true  # 清除旧错误

# 热重启（重置应用状态）
mcp__dart__hot_restart
```

**选择建议**：
- **Hot Reload**: UI 调整、小的逻辑修改
- **Hot Restart**: 状态管理修改、全局变量更改、初始化代码修改

### 3. 验证修复

```bash
# 1. 检查运行时错误
mcp__dart__get_runtime_errors

# 2. 查看 Widget 树确认结构正确
mcp__dart__get_widget_tree
  summaryOnly: true

# 3. 截图验证 UI
adb exec-out screencap -p > /tmp/screen_fixed.png
```

## 避免大响应问题

### ❌ 避免的操作

```bash
# 1. 避免获取完整 Widget 树
mcp__dart__get_widget_tree
  summaryOnly: false  # ❌ 会产生 10万+ tokens 响应

# 2. 避免获取全部日志
mcp__dart__get_app_logs
  maxLines: -1  # ❌ 可能产生巨大响应

# 3. 避免使用已弃用的 flutter_driver
mcp__dart__flutter_driver  # ❌ 需要额外配置，已被 integration_test 替代
```

### ✅ 推荐的操作

```bash
# 1. 使用 summaryOnly 获取 Widget 树
mcp__dart__get_widget_tree
  summaryOnly: true  # ✅ 仅用户代码，响应小

# 2. 限制日志行数
mcp__dart__get_app_logs
  maxLines: 50  # ✅ 合理范围

# 3. 使用截图代替完整树
adb exec-out screencap -p > /tmp/screen.png  # ✅ 直观高效

# 4. 使用 integration_test 替代 flutter_driver
# 在 integration_test/ 目录创建测试文件
```

## 常用命令组合

### 完整的验证流程

```bash
# 1. 启动应用
mcp__dart__list_devices
mcp__dart__launch_app(device, root, target)
mcp__dart__connect_dart_tooling_daemon(uri)

# 2. 检查状态
mcp__dart__get_runtime_errors
mcp__dart__get_widget_tree(summaryOnly: true)
adb exec-out screencap -p > /tmp/screen.png

# 3. 如果有错误
mcp__dart__get_app_logs(maxLines: 50)
mcp__dart__analyze_files(paths)

# 4. 修复后验证
mcp__dart__hot_reload(clearRuntimeErrors: true)
mcp__dart__get_runtime_errors
adb exec-out screencap -p > /tmp/screen_fixed.png
```

### 快速迭代流程

```bash
# 修改代码 -> 热重载 -> 检查
Edit tool: <file>
mcp__dart__hot_reload
mcp__dart__get_runtime_errors

# 如果需要重启状态
mcp__dart__hot_restart
mcp__dart__get_widget_tree(summaryOnly: true)
```

## 测试最佳实践

### 使用 integration_test（官方推荐）

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

```dart
// integration_test/login_flow_test.dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow test', (tester) async {
    // 测试逻辑
  });
}
```

运行测试：

```bash
flutter test integration_test/login_flow_test.dart
```

### 为什么不用 flutter_driver

- ✅ **integration_test**: Flutter 官方推荐，无需额外配置，性能更好
- ❌ **flutter_driver**: 已弃用，需要单独的 driver 文件和 enableFlutterDriverExtension()

## 实战案例

### 案例：修复 ProviderException

**问题**：应用启动显示错误 Widget

**步骤**：

1. **截图定位问题**

```bash
adb exec-out screencap -p > /tmp/screen.png
# 看到错误: ProviderException: keyValueStorageProvider must be overridden
```

2. **查看日志确认**

```bash
mcp__dart__get_app_logs(maxLines: 50)
# 确认 SharedPreferences 未初始化
```

3. **修复代码**

```dart
// lib/app/bootstrap.dart
final storage = await SharedPreferencesStorage.create();
runApp(
  ProviderScope(
    overrides: [
      keyValueStorageProvider.overrideWithValue(storage),
    ],
    child: const App(),
  ),
);
```

4. **热重启验证**

```bash
mcp__dart__hot_restart
mcp__dart__get_runtime_errors  # No errors
mcp__dart__get_widget_tree(summaryOnly: true)  # 确认 LoginPage 正确加载
adb exec-out screencap -p > /tmp/screen_fixed.png  # 确认 UI 正确
```

## 常见错误和解决方案

### 1. Large MCP response

**错误**：使用 `get_widget_tree(summaryOnly: false)` 导致响应过大

**解决**：始终使用 `summaryOnly: true` 或使用截图

### 2. DTD 连接失败

**错误**：`connect_dart_tooling_daemon` 超时

**解决**：
- 检查 `launch_app` 返回的 `dtdUri` 是否正确
- 确保应用成功启动且未崩溃
- 如果连接断开，重新启动应用获取新的 URI

### 3. Hot reload 失败

**错误**：某些更改无法热重载

**解决**：使用 `hot_restart` 而不是 `hot_reload`
- 状态管理相关更改
- 全局变量、常量更改
- main() 函数更改
- initState() 相关更改

## 工具对比

| 功能 | Flutter MCP 工具 | 传统命令 | 优势 |
|------|------------------|----------|------|
| 启动应用 | `mcp__dart__launch_app` | `flutter run` | 自动返回 DTD URI |
| Widget 树 | `mcp__dart__get_widget_tree` | DevTools | 编程化访问，可过滤 |
| 热重载 | `mcp__dart__hot_reload` | `r` in CLI | 可清除错误 |
| 错误检查 | `mcp__dart__get_runtime_errors` | 查看日志 | 结构化错误信息 |
| 截图 | `adb screencap` | 手动截图 | 可编程化集成 |
| 测试 | `integration_test` | `flutter_driver` | 官方推荐，配置简单 |

## 总结

### 核心原则

1. **优先使用 MCP 工具**而不是原始命令
2. **限制响应大小**：使用 `summaryOnly`、`maxLines` 参数
3. **使用截图验证 UI**：快速直观
4. **迭代式开发**：修改 → 热重载 → 检查 → 截图
5. **使用 integration_test**：官方推荐，避免 flutter_driver

### 推荐工作流

```
代码修改
    ↓
mcp__dart__hot_reload
    ↓
mcp__dart__get_runtime_errors
    ↓
mcp__dart__get_widget_tree (summaryOnly: true)
    ↓
adb screencap（验证 UI）
    ↓
✅ 验证通过 / ❌ 继续修复
```

### 关键技巧

- 📸 **截图优先**：比完整 Widget 树更直观
- 🔥 **热重载优先**：保持状态，快速迭代
- 📊 **summaryOnly**：避免大响应，聚焦用户代码
- 🧪 **integration_test**：替代 flutter_driver，官方推荐
- 📝 **限制日志**：使用 maxLines 避免过多输出

遵循这些最佳实践，可以显著提高 Flutter 开发效率并减少错误。
