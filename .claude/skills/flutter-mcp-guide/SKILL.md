# Flutter MCP 工具使用指南 Skill

## 概述

本 skill 提供 Flutter MCP (Model Context Protocol) 工具的使用指南和最佳实践，帮助开发者高效使用 Flutter MCP 工具进行开发、调试和验证。

## 何时使用此 Skill

当用户执行以下操作时，**自动触发**此 skill：

### 1. 启动和运行 Flutter 应用
- 用户说："运行应用"、"启动 Flutter"、"launch app"
- 用户说："在模拟器上运行"、"在设备上测试"
- 用户请求使用 MCP 工具启动应用

### 2. 检查和调试应用
- 用户说："检查页面"、"查看 UI"、"验证界面"
- 用户说："有什么错误"、"查看日志"、"检查运行时错误"
- 用户请求查看 Widget 树或应用状态

### 3. 应用代码更改
- 用户说："热重载"、"hot reload"、"应用修改"
- 用户说："重启应用"、"hot restart"
- 代码修改后需要验证效果

### 4. 性能和响应优化
- 用户提到 "Large MCP response"、"响应太大"
- 使用 MCP 工具时出现超时或响应过大
- 需要优化 MCP 工具调用

### 5. 集成测试相关
- 用户提到 "flutter_driver"、"集成测试"、"UI 测试"
- 需要创建或运行测试

## 核心指导原则

### 🚫 避免的操作（会导致 Large MCP Response）

```bash
# ❌ 不要使用完整 Widget 树
mcp__dart__get_widget_tree
  summaryOnly: false  # 会产生 10万+ tokens

# ❌ 不要获取全部日志
mcp__dart__get_app_logs
  maxLines: -1  # 可能产生巨大响应

# ❌ 不要使用已弃用的 flutter_driver
mcp__dart__flutter_driver  # 已被 integration_test 替代
```

### ✅ 推荐的操作

```bash
# ✅ 使用 summaryOnly 获取 Widget 树
mcp__dart__get_widget_tree
  summaryOnly: true  # 仅用户代码，响应小

# ✅ 限制日志行数
mcp__dart__get_app_logs
  maxLines: 50  # 通常 50-100 行足够

# ✅ 使用截图代替完整树验证 UI
adb exec-out screencap -p > /tmp/screen.png

# ✅ 使用 integration_test
# 在 integration_test/ 目录创建测试文件
```

## 标准工作流程

### 1. 启动应用流程

```bash
# 步骤 1: 列出可用设备
mcp__dart__list_devices

# 步骤 2: 启动应用
mcp__dart__launch_app
  device: "emulator-5554"  # 或其他设备 ID
  root: "/path/to/project"
  target: "lib/main_development.dart"

# 步骤 3: 连接 DTD
mcp__dart__connect_dart_tooling_daemon
  uri: "ws://..."  # 从 launch_app 返回的 dtdUri
```

### 2. 验证应用状态流程

```bash
# 步骤 1: 检查运行时错误
mcp__dart__get_runtime_errors

# 步骤 2: 查看 Widget 树（重要：使用 summaryOnly）
mcp__dart__get_widget_tree
  summaryOnly: true  # ✅ 必须使用 true

# 步骤 3: 截图验证 UI（推荐）
adb exec-out screencap -p > /tmp/screen.png
# 然后使用 Read tool 查看截图
```

### 3. 修复错误流程

```bash
# 步骤 1: 分析代码
mcp__dart__analyze_files
  roots: [{paths: [...], root: "file://..."}]

# 步骤 2: 修改代码
# 使用 Edit 或 Write tool

# 步骤 3: 应用更改
mcp__dart__hot_reload
  clearRuntimeErrors: true  # 清除旧错误

# 或者需要重启状态时
mcp__dart__hot_restart

# 步骤 4: 验证修复
mcp__dart__get_runtime_errors
mcp__dart__get_widget_tree(summaryOnly: true)
adb exec-out screencap -p > /tmp/screen_fixed.png
```

## 关键最佳实践

### 1. 优先使用截图验证 UI

**为什么**：截图直观、响应小、快速

**如何使用**：
```bash
# 截图
adb exec-out screencap -p > /tmp/screen.png

# 读取截图
Read tool: /tmp/screen.png
```

### 2. 始终使用 summaryOnly: true

**为什么**：
- `summaryOnly: false` 会返回 10万+ tokens（包含所有 Flutter 框架 Widget）
- `summaryOnly: true` 只返回 1-2千 tokens（仅用户代码）

**对比**：
```bash
# ❌ 不推荐（响应 ~100k tokens）
mcp__dart__get_widget_tree
  summaryOnly: false

# ✅ 推荐（响应 ~1-2k tokens）
mcp__dart__get_widget_tree
  summaryOnly: true
```

### 3. 限制日志行数

```bash
# ✅ 推荐：获取最近 50 行日志
mcp__dart__get_app_logs
  pid: <pid>
  maxLines: 50

# ⚠️ 避免：获取全部日志
# maxLines: -1  # 可能非常大
```

### 4. 选择合适的重载方式

**Hot Reload（热重载）**：
- 适用于：UI 调整、小的逻辑修改
- 特点：保持应用状态

**Hot Restart（热重启）**：
- 适用于：状态管理修改、全局变量、初始化代码
- 特点：重置应用状态

### 5. 使用 integration_test 而非 flutter_driver

**为什么**：
- `flutter_driver` 已被 Flutter 官方弃用
- `integration_test` 是官方推荐的替代方案
- 无需额外配置，更简单易用

**如何使用**：
```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

```dart
// integration_test/example_test.dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('example test', (tester) async {
    // 测试逻辑
  });
}
```

## 快速参考表

### 常用命令

| 操作 | MCP 工具 | 关键参数 |
|------|---------|---------|
| 列出设备 | `mcp__dart__list_devices` | - |
| 启动应用 | `mcp__dart__launch_app` | device, root, target |
| 连接 DTD | `mcp__dart__connect_dart_tooling_daemon` | uri |
| 检查错误 | `mcp__dart__get_runtime_errors` | - |
| Widget 树 | `mcp__dart__get_widget_tree` | **summaryOnly: true** |
| 应用日志 | `mcp__dart__get_app_logs` | maxLines: 50 |
| 热重载 | `mcp__dart__hot_reload` | clearRuntimeErrors: true |
| 热重启 | `mcp__dart__hot_restart` | - |
| 代码分析 | `mcp__dart__analyze_files` | roots |
| 截图 | `adb exec-out screencap -p` | > /tmp/screen.png |

### 响应大小对比

| 操作 | 响应大小 | 建议 |
|------|---------|------|
| `get_widget_tree(summaryOnly: true)` | ~1-2k tokens | ✅ 推荐 |
| `get_widget_tree(summaryOnly: false)` | ~100k+ tokens | ❌ 避免 |
| `get_app_logs(maxLines: 50)` | ~1-3k tokens | ✅ 推荐 |
| `get_app_logs(maxLines: -1)` | 不确定，可能很大 | ❌ 避免 |
| 截图 + Read | ~10-20k tokens | ✅ 推荐 |

## 实战案例

### 案例 1：启动应用并验证 UI

```bash
# 1. 启动应用
mcp__dart__list_devices
# 输出: {"devices":["emulator-5554","linux"]}

mcp__dart__launch_app
  device: "emulator-5554"
  root: "/home/user/project"
  target: "lib/main_development.dart"
# 输出: {"dtdUri":"ws://127.0.0.1:46545/xxx=","pid":1301}

mcp__dart__connect_dart_tooling_daemon
  uri: "ws://127.0.0.1:46545/xxx="
# 输出: "Connection succeeded"

# 2. 验证状态
mcp__dart__get_runtime_errors
# 输出: "No runtime errors found."

mcp__dart__get_widget_tree
  summaryOnly: true  # ✅ 必须
# 输出: 简洁的用户代码 Widget 树

# 3. 截图验证（推荐）
adb exec-out screencap -p > /tmp/screen.png
Read: /tmp/screen.png
# 查看实际 UI 渲染效果
```

### 案例 2：修复错误并验证

```bash
# 1. 发现错误
mcp__dart__get_widget_tree(summaryOnly: true)
# 发现显示 ErrorWidget

# 2. 查看错误详情
adb exec-out screencap -p > /tmp/error.png
Read: /tmp/error.png
# 截图显示: "ProviderException: keyValueStorageProvider must be overridden"

# 3. 查看日志确认
mcp__dart__get_app_logs
  pid: 1301
  maxLines: 50
# 确认错误原因

# 4. 修复代码
Edit: lib/app/bootstrap.dart
# 添加 SharedPreferences 初始化

# 5. 应用修复
mcp__dart__hot_restart
# 输出: "Hot restart succeeded."

# 6. 验证修复
mcp__dart__get_runtime_errors
# 输出: "No runtime errors found."

mcp__dart__get_widget_tree(summaryOnly: true)
# 确认 LoginPage 正确显示

adb exec-out screencap -p > /tmp/fixed.png
Read: /tmp/fixed.png
# 截图显示登录页面正确渲染 ✅
```

### 案例 3：避免 Large Response

```bash
# ❌ 错误做法（会导致 Large MCP Response）
mcp__dart__get_widget_tree
  summaryOnly: false
# 结果: 返回 100k+ tokens，可能超时或截断

# ✅ 正确做法
mcp__dart__get_widget_tree
  summaryOnly: true
# 结果: 返回 1-2k tokens，快速清晰

# ✅ 或者使用截图
adb exec-out screencap -p > /tmp/screen.png
Read: /tmp/screen.png
# 结果: 直观查看 UI，响应适中
```

## 常见问题和解决方案

### Q1: 如何避免 Large MCP response？

**A**: 遵循以下原则：
1. ✅ 使用 `get_widget_tree(summaryOnly: true)`
2. ✅ 限制 `get_app_logs(maxLines: 50)`
3. ✅ 优先使用截图验证 UI
4. ❌ 避免 `summaryOnly: false`
5. ❌ 避免 `maxLines: -1`

### Q2: Hot Reload 失败怎么办？

**A**: 某些更改无法热重载，需要使用 Hot Restart：
- 状态管理相关修改
- 全局变量、常量修改
- main() 函数修改
- initState() 相关修改

```bash
# 使用 Hot Restart 代替 Hot Reload
mcp__dart__hot_restart
```

### Q3: DTD 连接失败怎么办？

**A**:
1. 确保应用成功启动（检查 launch_app 输出）
2. 使用 launch_app 返回的最新 dtdUri
3. 如果连接断开，重新启动应用获取新 URI

### Q4: 如何快速定位 UI 问题？

**A**: 使用截图优先策略：
```bash
# 1. 截图
adb exec-out screencap -p > /tmp/screen.png

# 2. 查看截图
Read: /tmp/screen.png

# 3. 如需要，再查看 Widget 树
mcp__dart__get_widget_tree(summaryOnly: true)
```

### Q5: 应该使用 flutter_driver 吗？

**A**: 不应该，flutter_driver 已被弃用。使用 integration_test：

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

```dart
// integration_test/test.dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test', (tester) async {
    // 测试逻辑
  });
}
```

## 执行清单

当使用 Flutter MCP 工具时，遵循以下清单：

### ☑️ 启动应用前
- [ ] 确认设备已连接（`list_devices`）
- [ ] 确认项目路径正确
- [ ] 确认入口文件路径（通常是 `lib/main_development.dart`）

### ☑️ 检查应用状态时
- [ ] 先检查运行时错误（`get_runtime_errors`）
- [ ] 使用 `summaryOnly: true` 获取 Widget 树
- [ ] 使用截图验证 UI（推荐）
- [ ] 限制日志行数（maxLines: 50）

### ☑️ 修复错误后
- [ ] 选择合适的重载方式（reload vs restart）
- [ ] 清除旧错误（`clearRuntimeErrors: true`）
- [ ] 再次检查运行时错误
- [ ] 截图验证修复效果

### ☑️ 避免大响应
- [ ] 不使用 `summaryOnly: false`
- [ ] 不使用 `maxLines: -1`
- [ ] 优先使用截图而非完整 Widget 树
- [ ] 使用 integration_test 而非 flutter_driver

## 参考文档

完整的最佳实践文档：`.claude/flutter_mcp_best_practices.md`

## 总结

使用 Flutter MCP 工具时，记住以下核心原则：

1. 📸 **截图优先** - 直观高效
2. 🎯 **summaryOnly: true** - 避免大响应
3. 📊 **限制日志** - maxLines: 50 通常足够
4. 🔥 **选择重载** - reload 保持状态，restart 重置状态
5. 🧪 **integration_test** - 官方推荐，弃用 flutter_driver

遵循这些最佳实践，可以显著提高 Flutter 开发效率并避免常见错误。
