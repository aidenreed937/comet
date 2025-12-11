---
description: 创建新的 Feature 模块，包含完整的 domain/data/presentation 三层结构
---

# 创建 Feature: $ARGUMENTS

请按照 `.claude/skills/feature-workflow/SKILL.md` 中的工作流创建新功能模块。

## 前置条件

**必须从 develop 分支创建 feature 分支！**

```bash
# 确保在 develop 分支并更新到最新
git checkout develop
git pull origin develop

# 创建 feature 分支
git checkout -b feature/<name>
```

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

5. **提交流程（参考 `.claude/skills/git-github/SKILL.md`）**:
   ```bash
   # 提交代码
   git add -A
   git commit -m "feat(<name>): add <name> feature module"

   # Rebase 到最新 develop
   git fetch origin develop
   git rebase origin/develop

   # 推送并创建 PR（目标分支：develop）
   git push -u origin feature/<name>
   gh pr create --base develop --title "feat(<name>): add <name> feature"
   ```

## 执行步骤

1. 确认 Feature 名称和主要实体字段
2. 确认当前在 develop 分支，创建 feature 分支
3. 按顺序创建: Domain → Data → Presentation
4. 配置路由和国际化
5. 验证代码质量（analyze + format）
6. 提交并创建 PR 到 develop
