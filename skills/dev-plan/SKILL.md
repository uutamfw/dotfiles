---
name: dev-plan
description: Create TDD-based implementation plan from docs/goal.md, save to Obsidian vault, and split into step files.
---

# Dev Plan

docs/goal.md を元にTDDベースの実装計画を作成し、Obsidian vault に保存後、stepファイルに分割する。

## Workflow Schema

See [workflow.yaml](../dev/schema/workflow.yaml) for YAML structure.

## Procedure

### 1. Setup & Validation

1. Get branch name from git: `git branch --show-current`
   - Extract number: `feat/#1473` → `1473`

2. Check if `docs/{branch_name}/dev-workflow.yaml` exists
   - If not exists → Create with initial state:
     ```yaml
     plan:
       status: Ready
     execute:
       status: Pending
       current_step: 1
       total_steps: 0
     ```

3. Read YAML and check `plan.status`
   - If `Done` → Ask user: "計画は既に完了しています。再作成しますか？"
   - If `In progress` → Resume from where left off
   - If `Ready` → Proceed

### 2. Read Requirements

1. Read `docs/goal.md`
   - If not exists → Error: "docs/goal.md が見つかりません"

2. Update YAML: `plan.status: In progress`

### 3. Create Plan

1. Enter plan mode using EnterPlanMode
2. Follow TDD structure from [tdd-plan.md](../dev/steps/tdd-plan.md)
   - Red → Green → Refactor order
3. Get user approval via ExitPlanMode

### 4. Save to Obsidian

Launch sub-agent:
```
Task(subagent_type="generalist",
     prompt="Execute /plan-on-md skill to save the plan to Obsidian vault",
     description="Save plan to Obsidian")
```

### 5. Split into Steps

Launch sub-agent:
```
Task(subagent_type="generalist",
     prompt="Execute /plan-steps-split skill to split the plan into step files",
     description="Split plan into steps")
```

### 6. Finalize

1. Count total steps created
2. Update YAML:
   ```yaml
   plan:
     status: Done
   execute:
     status: Ready
     current_step: 1
     total_steps: {count}
   ```

3. Report to user:
   - Plan saved location
   - Number of steps created
   - Next action: `/dev-step` to start implementation
