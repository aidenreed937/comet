# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Comet is a Flutter scaffold project implementing a feature-first architecture with clean architecture principles. It serves as a reusable template for Flutter applications, focusing on engineering infrastructure rather than business logic.

## Skills & Commands

### 可用 Skills

| Skill | 触发关键词 | 用途 |
|-------|-----------|------|
| `feature-workflow` | 创建功能、新建页面、开发 feature | Feature 完整开发流程 |
| `flutter-best-practices` | 最佳实践、架构、Riverpod | Flutter 开发规范 |
| `code-quality` | 代码检查、分析、格式化、测试 | 代码质量检测 |
| `git-github` | git、提交、推送、PR、合并 | Git 工作流 |
| `flutter-mcp-guide` | 运行应用、热重载、调试 | Flutter MCP 工具使用 |

### 可用 Commands

- `/create-feature <name>` - 创建新 Feature 模块

## Common Commands

```bash
# Run the app
flutter run -t lib/main_development.dart

# Quality check (必须在提交前通过)
flutter analyze --fatal-infos   # 0 issues
dart format --set-exit-if-changed .  # 0 changed
flutter test                    # All passed

# Run tests
flutter test                                    # All tests
flutter test test/features/auth/                # Feature-specific tests

# Localization
flutter gen-l10n                                # Generate l10n files

# Dependencies
flutter pub get
flutter pub outdated
```

## Architecture

### Directory Structure

```
lib/
├── app/                    # Application composition root
│   ├── app.dart           # Root widget (MaterialApp.router + ProviderScope)
│   ├── bootstrap.dart     # App initialization
│   ├── di.dart            # Core service providers
│   └── router.dart        # GoRouter configuration
├── core/                   # Non-business infrastructure (no feature imports)
│   ├── config/            # Environment configuration
│   ├── error/             # Failure models and error mapping
│   ├── l10n/              # Localization
│   ├── network/           # Dio client and interceptors
│   ├── storage/           # Storage wrappers
│   ├── theme/             # AppTheme, AppSpacing
│   ├── utils/             # Logger, Result type
│   └── widgets/           # Reusable UI components
├── features/              # Feature modules
│   └── <feature>/
│       ├── domain/        # Entities, repositories, validators (pure Dart)
│       ├── data/          # Data sources, DTOs, repository implementations
│       └── presentation/  # Pages, widgets, providers
└── main_*.dart            # Environment entry points
```

### Key Patterns

- **State Management**: flutter_riverpod 3.x with Notifier pattern
- **Routing**: go_router with feature-specific route builders
- **Error Handling**: `Result<T>` type with `Failure` models
- **UI State**: All state in Riverpod Provider (not StatefulWidget)

### Core Principles

| 原则 | 说明 |
|------|------|
| **无状态优先** | 使用 `ConsumerWidget`，不用 `StatefulWidget` |
| **状态放 Riverpod** | 所有状态（含 UI 状态）放 Provider |
| **UI 无硬编码** | 文本用 `l10n`，颜色用 `Theme`，间距用 `AppSpacing` |
| **逻辑与 UI 分离** | 验证、业务逻辑放 `domain/` 或 `provider/` |

### Layer Rules

- `core/` never imports from `features/`
- `domain/` layer must be pure Dart (no `package:flutter` imports)
- Features should not directly import other features

## Development Workflow

### 创建新 Feature

```
需求分析(EnterPlanMode) → Domain → Data → Provider → UI → Route → L10n → 质量检查
```

1. **先规划**: 使用 `EnterPlanMode` 分析需求，拆分任务
2. **逐层开发**: Domain → Data → Presentation
3. **质量检查**: 每次提交前必须通过

### Git Workflow

```bash
# 1. 创建分支
git checkout develop && git pull
git checkout -b feature/xxx

# 2. 开发 & 提交
# ... 开发 ...
flutter analyze --fatal-infos && dart format --set-exit-if-changed . && flutter test

# 3. Rebase & 推送
git fetch origin develop && git rebase origin/develop
git push --force-with-lease origin feature/xxx

# 4. 创建 PR & 合并
gh pr create --base develop
gh pr merge <n> --rebase --delete-branch
```

## Testing

- Use `mocktail` for mocking
- Test files mirror source structure: `test/features/<name>/...`
- Provider testing: create `ProviderContainer` with overrides

## Configuration Files

- `l10n.yaml`: Localization settings
- `analysis_options.yaml`: Strict Dart analysis rules
