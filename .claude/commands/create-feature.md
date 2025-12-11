---
description: 创建新的 Feature 模块，包含完整的 domain/data/presentation 三层结构
---

# 创建 Feature: $ARGUMENTS

**⚠️ 重要：必须使用 feature-workflow skill 来创建功能模块！**

请立即执行以下操作：

```
使用 Skill tool 触发 feature-workflow skill，参数为：$ARGUMENTS
```

**为什么必须使用 skill？**

feature-workflow skill 会自动：
1. ✅ 分析现有代码库的架构模式和 API
2. ✅ 检查项目使用的依赖版本（如 Riverpod 3.x）
3. ✅ 了解 Result/Failure、错误处理等核心 API
4. ✅ 参考类似功能的实现方式
5. ✅ 生成符合项目规范的高质量代码
6. ✅ 自动运行代码质量检查并修复问题
7. ✅ 确保测试正确并通过

**禁止直接编码！**

如果不使用 skill，容易出现：
- ❌ API 使用错误（如 Result API）
- ❌ 依赖版本不匹配（如 StateNotifier vs Notifier）
- ❌ 命名不一致
- ❌ 架构模式偏差
- ❌ 测试不完整或错误

---

## 参考信息（供 skill 使用）

### 架构要求

**目录结构**:
```
lib/features/<name>/
├── domain/          # 纯 Dart，无 Flutter 依赖
│   ├── entities/
│   └── repositories/
├── data/            # DTO 与 Entity 分离
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/    # UI + 状态管理
    ├── providers/
    ├── pages/
    ├── widgets/
    └── routes.dart
```

### 分支流程

**从 develop 创建 feature 分支**:
```bash
git checkout develop
git pull origin develop
git checkout -b feature/<name>
```

### 核心原则

1. **Domain 层**: 纯 Dart，不依赖 Flutter
2. **Data 层**: DTO ↔ Entity 转换，错误转 Failure
3. **Presentation 层**:
   - 使用 l10n（无硬编码文本）
   - 使用 Theme（无硬编码颜色）
   - 数据来自 Provider（无模拟数据）
   - 状态使用 sealed class

### 完成清单

- [ ] 创建三层架构目录和文件
- [ ] 注册路由到 `app/router.dart`
- [ ] 添加国际化到 `l10n/app_*.arb`
- [ ] 运行 `flutter gen-l10n`
- [ ] 创建单元测试
- [ ] 运行 `flutter analyze`（0 errors, 0 warnings）
- [ ] 运行 `flutter test`（全部通过）
- [ ] 提交并创建 PR 到 develop

### 提交规范

```bash
# 提交消息格式
git commit -m "feat(<name>): add <name> feature module"

# 创建 PR 到 develop（不是 main！）
gh pr create --base develop --title "feat(<name>): add <name> feature"
```

---

**再次强调：请使用 Skill tool 触发 feature-workflow，不要直接编码！**
