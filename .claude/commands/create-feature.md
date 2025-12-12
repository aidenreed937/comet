---
description: 创建新的 Feature 模块，包含完整的 domain/data/presentation 三层结构
---

创建 Feature: $ARGUMENTS

## 第一步：需求分析与规划

**在编码前必须先规划！** 使用 `EnterPlanMode` 进行需求分析：

1. **分析需求范围**
   - 需要哪些实体？
   - 需要哪些 API 接口？
   - 需要哪些页面/组件？

2. **拆分任务**
   - 大需求拆分为多个小任务（每个任务 < 1 小时）
   - 每个任务有明确的产出物
   - 复杂功能分多个 PR 逐步完成

3. **确认优先级**
   - MVP 核心功能优先
   - 可选功能后续迭代

## 第二步：开发实现

规划确认后，触发 `feature-workflow` skill 执行开发：

```
开发流程: Domain → Data → Provider → UI → Route → L10n → 质量检查
```

## 分支

```bash
git checkout -b feature/$ARGUMENTS
```

## 注意

- ⚠️ 需求过大时，先拆分再开发
- ⚠️ 每完成一个子任务就提交，避免大 PR
- ⚠️ 完成后运行 `flutter analyze && flutter test`
