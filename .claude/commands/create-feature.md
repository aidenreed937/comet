---
description: 创建新的 Feature 模块，包含完整的 domain/data/presentation 三层结构
---

# 创建 Feature: $ARGUMENTS

请按照 `.claude/skills/feature-workflow/SKILL.md` 中的工作流创建新功能模块。

## 要求

1. **Feature 名称**: `$ARGUMENTS`（如未提供，请询问用户）

2. **创建目录结构**:
   ```
   lib/features/<name>/
   ├── domain/
   │   ├── entities/<name>.dart
   │   └── repositories/<name>_repository.dart
   ├── data/
   │   ├── datasources/<name>_remote_data_source.dart
   │   ├── models/<name>_dto.dart
   │   └── repositories/<name>_repository_impl.dart
   └── presentation/
       ├── providers/<name>_provider.dart
       ├── pages/<name>_page.dart
       ├── widgets/<name>_view.dart
       └── routes.dart
   ```

3. **遵循原则**:
   - Domain 层：纯 Dart，不依赖 Flutter
   - Data 层：DTO 与 Entity 分离，错误转 Failure
   - Presentation 层：
     - UI 无硬编码文本（使用 l10n）
     - UI 无硬编码颜色（使用 Theme）
     - UI 无模拟数据（数据来自 Provider）
   - 状态使用 sealed class 定义

4. **完成后**:
   - 注册路由到 `app/router.dart`
   - 添加国际化文本到 `l10n/app_*.arb`
   - 运行 `flutter gen-l10n`
   - 创建对应的测试文件

## 执行步骤

1. 确认 Feature 名称和主要实体字段
2. 按顺序创建: Domain → Data → Presentation
3. 配置路由和国际化
4. 验证代码质量（analyze + format）
