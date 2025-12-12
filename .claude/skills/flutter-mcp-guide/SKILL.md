---
name: flutter-mcp-guide
description: Flutter MCP 工具使用指南，包括启动应用、调试、热重载、Widget 树检查。当用户提到"运行应用"、"启动 Flutter"、"热重载"、"查看日志"、"检查错误"、"Widget 树"时使用此 skill。
---

# Flutter MCP 工具使用指南

高效使用 Flutter MCP 工具进行开发、调试和验证。

## 快速参考

### 核心原则

| 原则 | 说明 |
|------|------|
| **summaryOnly: true** | 获取 Widget 树必须使用，避免 100k+ tokens |
| **maxLines: 50** | 限制日志行数，避免大响应 |
| **截图优先** | 验证 UI 优先用截图，直观高效 |
| **integration_test** | 使用官方推荐，弃用 flutter_driver |

### 常用命令

| 操作 | 工具 | 关键参数 |
|------|------|----------|
| 列出设备 | `mcp__dart__list_devices` | - |
| 启动应用 | `mcp__dart__launch_app` | device, root, target |
| 连接 DTD | `mcp__dart__connect_dart_tooling_daemon` | uri |
| 检查错误 | `mcp__dart__get_runtime_errors` | - |
| Widget 树 | `mcp__dart__get_widget_tree` | **summaryOnly: true** |
| 应用日志 | `mcp__dart__get_app_logs` | maxLines: 50 |
| 热重载 | `mcp__dart__hot_reload` | clearRuntimeErrors: true |
| 热重启 | `mcp__dart__hot_restart` | - |
| 截图 | `adb exec-out screencap -p` | > /tmp/screen.png |

### 响应大小对比

| 操作 | 响应大小 | 建议 |
|------|----------|------|
| `get_widget_tree(summaryOnly: true)` | ~1-2k tokens | ✅ |
| `get_widget_tree(summaryOnly: false)` | ~100k+ tokens | ❌ |
| `get_app_logs(maxLines: 50)` | ~1-3k tokens | ✅ |
| `get_app_logs(maxLines: -1)` | 不确定 | ❌ |

---

## 标准工作流程

### 1. 启动应用

```bash
# 1. 列出设备
mcp__dart__list_devices

# 2. 启动应用
mcp__dart__launch_app
  device: "emulator-5554"
  root: "/path/to/project"
  target: "lib/main_development.dart"

# 3. 连接 DTD（使用返回的 dtdUri）
mcp__dart__connect_dart_tooling_daemon
  uri: "ws://127.0.0.1:xxxxx/..."
```

### 2. 验证应用状态

```bash
# 1. 检查错误
mcp__dart__get_runtime_errors

# 2. 查看 Widget 树（必须 summaryOnly: true）
mcp__dart__get_widget_tree
  summaryOnly: true

# 3. 截图验证（推荐）
adb exec-out screencap -p > /tmp/screen.png
Read: /tmp/screen.png
```

### 3. 修复错误

```bash
# 1. 修改代码（Edit tool）

# 2. 应用更改
mcp__dart__hot_reload
  clearRuntimeErrors: true

# 3. 验证修复
mcp__dart__get_runtime_errors
adb exec-out screencap -p > /tmp/fixed.png
```

---

## 避免大响应

### 禁止

```bash
# ❌ 完整 Widget 树（100k+ tokens）
mcp__dart__get_widget_tree
  summaryOnly: false

# ❌ 全部日志
mcp__dart__get_app_logs
  maxLines: -1

# ❌ 已弃用的 flutter_driver
mcp__dart__flutter_driver
```

### 推荐

```bash
# ✅ 仅用户代码 Widget 树
mcp__dart__get_widget_tree
  summaryOnly: true

# ✅ 限制日志行数
mcp__dart__get_app_logs
  maxLines: 50

# ✅ 截图验证 UI
adb exec-out screencap -p > /tmp/screen.png

# ✅ integration_test
flutter test integration_test/
```

---

## 重载方式选择

| 场景 | 方式 | 特点 |
|------|------|------|
| UI 调整、小逻辑修改 | Hot Reload | 保持状态 |
| 状态管理、全局变量、main() | Hot Restart | 重置状态 |

---

## 检查清单

### 启动应用前

- [ ] 确认设备已连接
- [ ] 确认项目路径正确
- [ ] 确认入口文件路径

### 检查状态时

- [ ] 先检查 `get_runtime_errors`
- [ ] 使用 `summaryOnly: true`
- [ ] 使用截图验证 UI
- [ ] 限制日志 `maxLines: 50`

### 避免大响应

- [ ] 不使用 `summaryOnly: false`
- [ ] 不使用 `maxLines: -1`
- [ ] 优先截图而非完整 Widget 树

---

## 常见问题

### Hot Reload 失败？

某些更改无法热重载，使用 Hot Restart：
- 状态管理修改
- 全局变量、常量修改
- main() 函数修改

### DTD 连接失败？

1. 确保应用成功启动
2. 使用 launch_app 返回的最新 dtdUri
3. 连接断开时重新启动应用

### 如何快速定位 UI 问题？

```bash
# 1. 截图
adb exec-out screencap -p > /tmp/screen.png

# 2. 查看截图
Read: /tmp/screen.png

# 3. 如需要，查看 Widget 树
mcp__dart__get_widget_tree(summaryOnly: true)
```

---

## 附录

### A. integration_test 配置

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

### B. 完整启动示例

```bash
# 列出设备
mcp__dart__list_devices
# → {"devices":["emulator-5554","linux"]}

# 启动应用
mcp__dart__launch_app
  device: "emulator-5554"
  root: "/home/user/project"
  target: "lib/main_development.dart"
# → {"dtdUri":"ws://127.0.0.1:46545/xxx=","pid":1301}

# 连接 DTD
mcp__dart__connect_dart_tooling_daemon
  uri: "ws://127.0.0.1:46545/xxx="
# → "Connection succeeded"

# 验证
mcp__dart__get_runtime_errors
# → "No runtime errors found."

mcp__dart__get_widget_tree
  summaryOnly: true
# → 简洁的用户代码 Widget 树
```
