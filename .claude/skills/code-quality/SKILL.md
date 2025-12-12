---
name: code-quality
description: Flutter 项目代码质量检测和修复，包括 Dart 代码分析、格式化、测试。当用户提到"代码检查"、"分析"、"格式化"、"代码风格"、"质量检测"、"测试"时使用此 skill。
---

# Flutter 代码质量检测

确保 Flutter/Dart 代码符合项目规范，自动检测和修复问题。

## 快速参考

### 核心命令

| 检测项 | 命令 | 说明 |
|--------|------|------|
| 代码分析 | `flutter analyze` | 检查语法、类型、lint |
| 格式化 | `dart format .` | 统一代码风格 |
| 测试 | `flutter test` | 运行单元/Widget 测试 |
| 依赖检查 | `flutter pub outdated` | 检查过期依赖 |

### 完整质量检查（一键运行）

```bash
flutter analyze && dart format --set-exit-if-changed . && flutter test
```

### 快速检查清单

- [ ] `flutter analyze` 无错误
- [ ] `dart format` 无格式问题
- [ ] `flutter test` 全部通过
- [ ] 无硬编码敏感信息

---

## 子代理执行（推荐）

**建议通过子代理执行完整质量检查**：

```typescript
Task({
  subagent_type: 'general-purpose',
  description: '运行 Flutter 代码质量检查',
  prompt: `运行完整代码质量检查并修复问题，遵循 .claude/skills/code-quality/SKILL.md`,
})
```

**原因**：质量检查失败时可能产生大量输出（10k-20k tokens），子代理可隔离处理。

---

## 安全检查

### 敏感信息

| 禁止 | 允许 |
|------|------|
| 硬编码 API Key/Token | 环境变量 `--dart-define` |
| 硬编码密码 | SecureStorage |
| 内部 URL/IP | 配置文件 |

### 常见漏洞

| 漏洞 | 预防 |
|------|------|
| 数据泄露 | 移除 `print` 敏感日志 |
| 本地存储 | 加密敏感数据 |
| 网络请求 | 强制 HTTPS |

---

## 性能检查

| 检查项 | 标准 |
|--------|------|
| 单文件行数 | < 500 行 |
| Widget 嵌套 | < 10 层 |
| 列表 | 使用 `ListView.builder` |
| 构造函数 | 使用 `const` |

---

## 常见问题修复

```dart
// ❌ 未使用的导入
import 'package:unused/unused.dart';

// ✅ 移除未使用导入
```

```dart
// ❌ 格式不规范
class MyWidget extends StatelessWidget{
@override Widget build(BuildContext context){return Container();}}

// ✅ 运行 dart format
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## 附录

### A. Dart Analyzer 配置

配置文件：`analysis_options.yaml`

检查规则：
- Dart/Flutter 语法规范
- 类型安全检查
- 未使用变量/导入检测
- 命名规范检查
- 空安全检查

### B. 测试命令

```bash
flutter test                        # 所有测试
flutter test test/features/xxx/     # 指定目录
flutter test --coverage             # 覆盖率报告
flutter test --reporter=expanded    # 详细输出
```

### C. CI/CD 集成

```yaml
# .github/workflows/flutter.yml
- name: Analyze
  run: flutter analyze
- name: Format Check
  run: dart format --set-exit-if-changed .
- name: Test
  run: flutter test --coverage
```

### D. Pre-commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash
flutter analyze && dart format --set-exit-if-changed . && flutter test
```
