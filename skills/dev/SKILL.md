---
name: dev
description: Orchestrate TDD-based development workflow. Checks workflow state and guides user to appropriate skill (dev-plan or dev-step).
---

# Dev Orchestrator

開発ワークフローの状態を確認し、適切なスキルへ誘導するオーケストレーター。

## Related Skills

- `/dev-plan` - 計画作成・分割
- `/dev-step` - step単位の実装

## Workflow Schema

See [schema/workflow.yaml](schema/workflow.yaml) for YAML structure.

## Procedure

### 1. Check Workflow State

1. Get branch name: `git branch --show-current`
   - Extract number: `feat/#1473` → `1473`

2. Check `docs/{branch_name}/dev-workflow.yaml`

### 2. Route to Appropriate Skill

```
YAML exists?
├─ No → "ワークフローが未初期化です。/dev-plan を実行しますか？"
│
└─ Yes → Check status
    │
    ├─ plan.status: Ready/In progress
    │   → "/dev-plan を実行して計画を作成してください"
    │
    ├─ plan.status: Done, execute.status: Pending/Ready
    │   → "/dev-step を実行して実装を開始しますか？"
    │
    ├─ execute.status: In progress
    │   → "Step {current}/{total} から再開します。/dev-step を実行しますか？"
    │
    └─ execute.status: Done
        → "全stepが完了しています。お疲れ様でした！"
```

### 3. Summary Display

Show current state:
```
## Workflow Status: {branch_name}

| Phase   | Status      |
|---------|-------------|
| Plan    | {status}    |
| Execute | {status} ({current}/{total}) |

Next action: {recommendation}
```
